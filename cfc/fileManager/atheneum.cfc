<cfcomponent extends="ArchimedesCFC.common">

	<!---
			GetFolders
					
	--->
	<cffunction name="GetFolders" access="public" returntype="query">
		<cfargument name="FolderID" type="numeric" required="no" default="#NullInt#" />
	
		<cfquery datasource="#DSN#" name="qryGetFolders">
			SELECT
					folderID,
					folderPath,
					folderFriendlyName
			FROM
					file_Folder
			WHERE
					isActive = 1
					AND isDeleted = 0
					<cfif Arguments.FolderID gt NullInt>
						AND folderID = #Arguments.FolderID#
					</cfif>
			ORDER BY
					sortOrder
		</cfquery>

		<cfreturn qryGetFolders />
	
	</cffunction>
	
	<!---
			GetFiles
					
	--->
	<cffunction name="GetFiles" access="public" returntype="query">
		<cfargument name="FolderID" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="FileID" type="numeric" required="no" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetFiles">
			SELECT
					f.fileID,
					f.fileName,
					f.fileTypeID,
					ft.mimetype,
					CASE
						WHEN f.title IS NULL THEN f.fileName
						ELSE f.title
					END AS title,
					f.fileSize,
					f.width,
					f.height,
					f.keywords,
					f1.folderPath
			FROM
					file_File f INNER JOIN
					file_FileType ft ON f.fileTypeID = ft.fileTypeID INNER JOIN
					file_Folder f1 ON f.folderID = f1.folderID
			WHERE
					1 = 1
					AND f.isDeleted = 0
					<cfif Arguments.FolderID gt NullInt>
						AND f.folderID = #Arguments.FolderID#
					</cfif>
					
					<cfif Arguments.FileID gt NullInt>
						AND f.fileID = #Arguments.FileID#
					</cfif>
			ORDER BY
					f.title
		</cfquery>
		
		<cfreturn qryGetFiles />
		
	</cffunction>
	
	<!---
			GetFileTypes
					
	--->
	<cffunction name="GetFileTypes" access="public" returntype="query">
		<cfargument name="FileTypeID" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="MimeType" type="string" required="no" default="#NullString#" />
		<cfargument name="Extension" type="string" required="no" default="#NullString#" />
		
		<cfquery datasource="#DSN#" name="qryGetFileTypes">
			SELECT
					fileTypeID,
					mimeType,
					extension
			FROM
					file_FileType
			WHERE
					1 = 1
					
					<cfif Arguments.FileTypeID gt NullInt>
						AND fileTypeID = #Arguments.FileTypeID#
					</cfif>
					
					<cfif NOT IsEmpty(Arguments.MimeType)>
						AND mimeType = '#Arguments.MimeType#'
					</cfif>
					
					<cfif NOT IsEmpty(Arguments.Extension)>
						AND extension = '#Arguments.Extension#'
					</cfif>
		</cfquery>
		
		<cfreturn qryGetFileTypes />
		
	</cffunction>
	
	<!---
			UploadFile
					Uploads a file to the specified folder
	--->
	<cffunction name="UploadFile" access="public" returntype="struct">
		<cfargument name="FormField" type="string" required="yes" default="#NullString#" /><!--- NOTE: This is the name of the form field, NOT it's value. --->
		<cfargument name="FolderID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="QuarantineFile" type="boolean" required="no" default="True" />
		
		<cftry>
		
			<!--- Create a return structure to store our data. --->
			<cfset retStruct = StructNew() />
			
			<!--- By default, we should quarantine all files that get uploaded to the server so they can be scanned. --->
			<cfif Arguments.QuarantineFile>
			
				<cfset folderPath = Application.SiteSettings.QuarantinePath />
			
			<cfelse>
		
				<!--- Get the folder's info. --->
				<cfset qryFolderInfo = GetFolders(Arguments.FolderID) />
				<cfset folderPath = ExpandPath(qryFolderInfo.folderPath) />
			
			</cfif>
			
			<!--- Upload the file. --->
			<cffile action="upload" filefield="#Arguments.FormField#" destination="#folderPath#" nameconflict="makeunique" />
			
			<!--- Get the list of allowed file types. --->
			<cfset qryAllowedFileTypes = GetFileTypes() />
			<cfset AllowedFileTypeList = ValueList(qryAllowedFileTypes.mimeType) />
			
			<!--- Get the file's type. --->
			<cfset mimeType = GetFileType(file.ServerDirectory & file.ServerFile & "." & file.ServerFileExt) />
			
			<!--- If the file's mimeType is not an allowed type, delete it. --->
			<cfif ListFind(AllowedFileTypeList, mimeType, ",") eq 0>
			
				<cffile action="delete" file="#file.ServerDirectory##file.ServerFile#.#file.ServerFileExt#" />
				
				<!--- Update the return structure to inform the user that the file is not allowed. --->
				<cfscript>
					
					StructInsert(retStruct, "Success", false);
					StructInsert(retStruct, "ErrorMessage", "This file type is not permitted");
					
				</cfscript>
				
			<cfelse>
			
				<!--- 
				
						Use cfschedule to programatically schedule a task to complete processing this file once the scan has had time to run. 
						
				--->
				
				<!--- If the QuarantinedFiles array does not exist in the application scope, create it. --->
				<cfif NOT isDefined("Application.QuarantinedFiles")>
					<cfset Application.QuarantinedFiles = ArrayNew(1) />
				</cfif>
				
				<cfscript>
				
					// Create an empty structure.
					QuarantineInfo = StructNew();
					
					// Create a new UUID to identify this item in the application array.
					quarantineUUID = CreateUUID();
	
					// Add the values to the structure.
					StructInsert(QuarantineInfo, "UUID", quarantineUUID);
					StructInsert(QuarantineInfo, "QuarantinedFile", folderPath & file.ServerFile & "." & file.ServerFileExt);
					StructInsert(QuarantineInfo, "TimeStamp", now());
					StructInsert(QuarantineInfo, "DestinationFolderID", Arguments.FolderID);
					StructInsert(QuarantineInfo, "NotificationEmail", Session.Profile.EmailAddress);
					
					// Add the structure to the array.
					ArrayAppend(Application.QuarantinedFiles, QuarantineInfo);
				
				</cfscript>
				
				<!--- Schedule a task five minutes from now to move the file once it has been scanned. --->
				<cfschedule
						action="update" 
						operation="httprequest" 
						task="RemoveFileFromQuarantine#quarantineUUID#"
						startdate="#DateFormat(DateAdd('n', 5, now()), 'mm/dd/yyyy')#" 
						starttime="#TimeFormat(DateAdd('n', 5, now()), 'hh:mm:ss')#" 
						interval="once" 
						url="/cfc/fileManager/antheneum.cfc?method=MoveFileFromQuarantine?uuid=#quarantineUUID#" />
				
				<!--- Get the fileTypeID. --->
				<cfset qryFileTypeInfo = GetFileTypes(MimeType=mimeType) />
				
				<!--- Add the values to the structure. --->
				<cfscript>
				
					StructInsert(retStruct, "Success", true);
					StructInsert(retStruct, "FileName", file.ServerFile & "." & file.ServerFileExt);
					StructInsert(retStruct, "FileSize", file.FileSize);
					StructInsert(retStruct, "MimeType", mimeType);
					StructInsert(retStruct, "FileTypeID", qryFileTypeInfo.fileTypeID);
					StructInsert(retStruct, "FileTimeCreated", file.TimeCreated);
					StructInsert(retStruct, "IsQuarantined", Arguments.QuarantineFile);
					if(Arguments.QuarantineFile)
					{
						StructInsert(retStruct, "QuarantineUUID", quarantineUUID);
					}
				
				</cfscript>
		
			</cfif>
			
			<!--- Return the structure. --->
			<cfreturn retStruct />
			
			<cfcatch>
				
				<!--- Update the return structure to inform the user that the upload failed. --->
				<cfscript>
					
					StructInsert(retStruct, "Success", false);
					StructInsert(retStruct, "ErrorMessage", cfcatch.Message);
					
				</cfscript>
				
			</cfcatch>
			
		</cftry>
		
	</cffunction>
	
	<cffunction name="MoveFileFromQuarantine" access="remote" returntype="void">
		<cfargument name="UUID" type="string" required="yes" default="#NullGuid#" />
		
		<!--- Make sure the UUID is valid --->
		<cfif IsGuid(Arguments.UUID)>
		
			<cftry>
			
				<!--- Loop through the Quarantined files array and find the one to process. --->
				<cfloop from="1" to="#ArrayLen(Application.QuarantinedFiles)#" index="i">
					
					<!--- Get the structure --->
					<cfset QuarantineInfo = Application.QuarantinedFiles[i] />
					
					<!--- Check to see if it matches the specified UUID --->
					<cfif QuarantineInfo.UUID eq Arguments.UUID>
					
						<!--- Get the path of the destination folder. --->
						<cfset qryFolderInfo = GetFolders(QuarantineInfo.DestinationFolderID) />
					
						<!--- Move the file to the correct folder. --->
						<cffile action="move" source="#QuarantineInfo.QuarantinedFile#" destination="#ExpandPath(qryFolderInfo.folderPath)#" />
						
						<!--- If the file is an image, get its height and width. --->
						<cfif QuarantineInfo.mimeType CONTAINS "image">
							<cfset imageStruct = ImageInfo(file.ServerDirectory & file.ServerFile & "." & file.ServerFileExt) />
						</cfif>
						
						<!--- If the user has requested that the image be resized, process the requested sizes. --->
						<cfif IsDefined("QuarantineInfo.ImageSizes")>
						
							<!--- If the user has selected a large image size... (600px width) --->
							<cfif QuarantineInfo.ImageSizes.Large>
							
								<!--- Calculate the new height of the image. --->
								<cfset largeImageHeight = (ImageInfo.Height * 600) / ImageInfo.Width />
								<cffile action="copy" source="#file.ServerDirectory##file.ServerFile#.#file.ServerFileExt#" destination="#file.ServerDirectory##file.ServerFile#_Large.#file.ServerFileExt#" result="largeFile" />
								<cfset ImageScaleToFit(largeFile.ServerDirectory & largeFile.ServerFile & '.' & largeFile.ServerFileExt, 600, largeImageHeight, 'bilinear') />
							
								<!--- Get the file info, such as file size. --->
								<cfset largeFileInfo = GetFileInfo(largeFile.ServerDirectory & largeFile.ServerFile & '.' & largeFile.ServerFileExt) />
							
								<!--- Get the height and width of the new image. --->
								<cfset imageStruct = ImageInfo(largeFile.ServerDirectory & largeFile.ServerFile & "." & largeFile.ServerFileExt) />
								
								<!--- Add the file to the database. --->
								<cfinvoke method="CreateFile">
									<cfinvokeargument name="FolderID" value="#QuarantineInfo.DestinationFolderID#" />
									<cfinvokeargument name="FileName" value="#largeFile.ServerFile#.#largeFile.ServerFileExt#" />
									<cfinvokeargument name="FileTypeID" value="#QuarantineInfo.FileTypeID#" />
									<cfinvokeargument name="FileSize" value="#largeFileInfo.FileSize#" />
									<cfinvokeargument name="Keywords" value="#QuarantineInfo.Keywords#" />
									<cfinvokeargument name="Title" value="#QuarantineInfo.Title# (Large)" />
									<cfinvokeargument name="Height" value="#ImageStruct.Height#" />
									<cfinvokeargument name="Width" value="#ImageStruct.Width#" />
								</cfinvoke>
							
							</cfif>
							
							<!--- If the user has selected a mediun image size... (400px width) --->
							<cfif QuarantineInfo.ImageSizes.Medium>
							
								<!--- Calculate the new height of the image. --->
								<cfset mediumImageHeight = (ImageInfo.Height * 400) / ImageInfo.Width />
								<cffile action="copy" source="#file.ServerDirectory##file.ServerFile#.#file.ServerFileExt#" destination="#file.ServerDirectory##file.ServerFile#_Medium.#file.ServerFileExt#" result="mediumFile" />
								<cfset ImageScaleToFit(mediumFile.ServerDirectory & mediumFile.ServerFile & '.' & mediumFile.ServerFileExt, 600, mediumImageHeight, 'bilinear') />
							
								<!--- Get the file info, such as file size. --->
								<cfset mediumFileInfo = GetFileInfo(mediumFile.ServerDirectory & mediumFile.ServerFile & '.' & mediumFile.ServerFileExt) />
							
								<!--- Get the height and width of the new image. --->
								<cfset imageStruct = ImageInfo(mediumFile.ServerDirectory & mediumFile.ServerFile & "." & mediumFile.ServerFileExt) />
								
								<!--- Add the file to the database. --->
								<cfinvoke method="CreateFile">
									<cfinvokeargument name="FolderID" value="#QuarantineInfo.DestinationFolderID#" />
									<cfinvokeargument name="FileName" value="#mediumFile.ServerFile#.#mediumFile.ServerFileExt#" />
									<cfinvokeargument name="FileTypeID" value="#QuarantineInfo.FileTypeID#" />
									<cfinvokeargument name="FileSize" value="#mediumFileInfo.FileSize#" />
									<cfinvokeargument name="Keywords" value="#QuarantineInfo.Keywords#" />
									<cfinvokeargument name="Title" value="#QuarantineInfo.Title# (Medium)" />
									<cfinvokeargument name="Height" value="#ImageStruct.Height#" />
									<cfinvokeargument name="Width" value="#ImageStruct.Width#" />
								</cfinvoke>
							
							</cfif>
							
							<!--- If the user has selected a small image size... (200px width) --->
							<cfif QuarantineInfo.ImageSizes.Small>
							
								<!--- Calculate the new height of the image. --->
								<cfset smallImageHeight = (ImageInfo.Height * 200) / ImageInfo.Width />
								<cffile action="copy" source="#file.ServerDirectory##file.ServerFile#.#file.ServerFileExt#" destination="#file.ServerDirectory##file.ServerFile#_Small.#file.ServerFileExt#" result="smallFile" />
								<cfset ImageScaleToFit(smallFile.ServerDirectory & smallFile.ServerFile & '.' & smallFile.ServerFileExt, 600, smallImageHeight, 'bilinear') />
							
								<!--- Get the file info, such as file size. --->
								<cfset smallFileInfo = GetFileInfo(smallFile.ServerDirectory & smallFile.ServerFile & '.' & smallFile.ServerFileExt) />
							
								<!--- Get the height and width of the new image. --->
								<cfset imageStruct = ImageInfo(smallFile.ServerDirectory & smallFile.ServerFile & "." & smallFile.ServerFileExt) />
								
								<!--- Add the file to the database. --->
								<cfinvoke method="CreateFile">
									<cfinvokeargument name="FolderID" value="#QuarantineInfo.DestinationFolderID#" />
									<cfinvokeargument name="FileName" value="#smallFile.ServerFile#.#smallFile.ServerFileExt#" />
									<cfinvokeargument name="FileTypeID" value="#QuarantineInfo.FileTypeID#" />
									<cfinvokeargument name="FileSize" value="#smallFileInfo.FileSize#" />
									<cfinvokeargument name="Keywords" value="#QuarantineInfo.Keywords#" />
									<cfinvokeargument name="Title" value="#QuarantineInfo.Title# (Small)" />
									<cfinvokeargument name="Height" value="#ImageStruct.Height#" />
									<cfinvokeargument name="Width" value="#ImageStruct.Width#" />
								</cfinvoke>
							
							</cfif>
							
							<!--- If the user has selected a custom image size... --->
							<cfif NOT IsEmpty(QuarantineInfo.ImageSizes.Custom)>
								
								<!--- Get the specified width and height. --->
								<cfset customImageWidth = ListGetAt(QuarantineInfo.ImageSizes.Custom, 0, "|") />
								<cfset customImageHeight = ListGetAt(QuarantineInfo.ImageSizes.Custom, 1, "|") />
								
							</cfif>
							
						<!--- Otherwise, just add this file to the database. --->
						<cfelse>
						
							<!--- Add the file to the database. --->
							<cfinvoke method="CreateFile">
								<cfinvokeargument name="FolderID" value="#QuarantineInfo.DestinationFolderID#" />
								<cfinvokeargument name="FileName" value="#file.ServerFile#.#file.ServerFileExt#" />
								<cfinvokeargument name="FileTypeID" value="#QuarantineInfo.FileTypeID#" />
								<cfinvokeargument name="FileSize" value="#QuarantineInfo.FileSize#" />
								<cfinvokeargument name="Keywords" value="#QuarantineInfo.Keywords#" />
								<cfinvokeargument name="Title" value="#QuarantineInfo.Title#" />
								<cfif QuarantineInfo.mimeType CONTAINS "image">
									<cfinvokeargument name="Height" value="#ImageStruct.Height#" />
									<cfinvokeargument name="Width" value="#ImageStruct.Width#" />
								</cfif>
							</cfinvoke>
							
						</cfif>
						
						<!--- Notify the user that the file has been released from quarantine. --->
						<cfmail from="CampusRecNoReply@colostate.edu" to="#QuarantineInfo.NotificationEmail#" subject="Quarantined File Release">
							Your quarantined file has been released and can now be accessed in the File Manager.
							
							Thank you.
						</cfmail>
						
						<!--- Delete this item from the array. --->
						<cfset ArrayDeleteAt(Application.QuarantinedFiles, i) />
						
						<!--- Break from the loop. --->
						<cfbreak />
					
					</cfif>
					
				</cfloop>
			
				<cfcatch></cfcatch>
				
			</cftry>
		
		</cfif>
		
	</cffunction>
	
	<!---
			CreateFile
					
	--->
	<cffunction name="CreateFile" access="public" returntype="boolean">
		<cfargument name="FolderID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="FileName" type="string" required="yes" default="#NullString#" />
		<cfargument name="FileTypeID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="FileSize" type="string" required="yes" default="#NullString#" />
		<cfargument name="Keywords" type="string" required="no" default="#NullString#" />
		<cfargument name="Title" type="string" required="yes" default="#NullString#" />
		<cfargument name="Height" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="Width" type="numeric" required="no" default="#NullInt#" />
	
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryCreateFile">
					INSERT
							file_File
							(
								folderID,
								fileName,
								fileTypeID,
								fileSize,
								keywords,
								title
								<cfif Arguments.Height gt NullInt>
									,height
								</cfif>
								<cfif Arguments.Width gt NullInt>
									,width
								</cfif>
							)
					VALUES
							(
								#Arguments.FolderID#,
								'#Arguments.FileName#',
								#Arguments.FileTypeID#,
								'#Arguments.FileSize#',
								'#Arguments.Keywords#',
								'#Arguments.Title#'
								<cfif Arguments.Height gt NullInt>
									,#Arguments.Height#
								</cfif>
								<cfif Arguments.Width gt NullInt>
									,#Arguments.Width#
								</cfif>
							)
				</cfquery>
				
				<cfreturn True />
				
				<cfcatch><cfreturn False /></cfcatch>
			
			</cftry>
			
		<cfelse>
		
			<cfreturn False />
		
		</cfif>

	</cffunction>
	
	<!---
			EditFile
					
	--->
	<cffunction name="EditFile" access="public" returntype="boolean">
		<cfargument name="FileID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="FolderID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="FileName" type="string" required="yes" default="#NullString#" />
		<cfargument name="FileTypeID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="FileSize" type="string" required="yes" default="#NullString#" />
		<cfargument name="Keywords" type="string" required="no" default="#NullString#" />
		<cfargument name="Title" type="string" required="yes" default="#NullString#" />
		<cfargument name="Height" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="Width" type="numeric" required="no" default="#NullInt#" />

		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryEditFile">
					UPDATE
							file_File
					SET
							folderID = #Arguments.FolderID#,
							fileName = '#Arguments.FileName#',
							fileTypeID = #Arguments.FileTypeID#,
							fileSize = '#Arguments.FileSize#',
							keywords = '#Arguments.Keywords#'
							title = '#Arguments.Title#',
							dateLastModified = getDate()
							<cfif Arguments.Height gt NullInt>
								,height = #Arguments.Height#
							</cfif>
							<cfif Arguments.Width gt NullInt>
								,width = #Arguments.Width#
							</cfif>
					WHERE
							fileID = #Arguments.FileID#
				</cfquery>
				
				<cfreturn True />
				
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
			
		<cfelse>
		
			<cfreturn False />
			
		</cfif>

	</cffunction>
	
	<!---
			DeleteFile
					
	--->
	<cffunction name="DeleteFile" access="public" returntype="boolean">
		<cfargument name="FileID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryDeleteFile">
					UPDATE
							file_File
					SET
							isDeleted = 1
					WHERE
							fileID = #Arguments.FileID#
				</cfquery>
				
				<cfreturn qryDeleteFile.RowAffected gt 0>
				
				<cfcatch><cfreturn False /></cfcatch>
			
			</cftry>
			
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>
	
	<!---
			DestroyFile
					Permanently deletes the record from the database and deletes the file from the server's hard disk.
	--->
	<cffunction name="DestroyFile" access="public" returntype="boolean">
		<cfargument name="FileID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<!--- Get the folder path and the file name for this file. --->
				<cfquery datasource="#DSN#" name="qryGetFileDetails">
					SELECT
							f1.folderPath + f.fileName AS filePath,						
					FROM
							file_File f INNER JOIN
							file_Folder f1 ON f.folderID = f1.folderID
					WHERE
							f.fileID = #Arguments.FileID#
				</cfquery>		
				
				<!--- Get the physical server path. --->
				<cfset serverFilePath = ExpandPath(qryGetFileDetails.filePath) />
				
				<!--- Delete the file from the hard disk. --->
				<cffile action="delete" file="#serverFilePath#" />
				
				<!--- Delete the file from the database. --->
				<cfquery datasource="#DSN#" name="qryDeleteFile">
					DELETE
					FROM
							file_File
					WHERE
							fileID = #Arguments.FileID#
				</cfquery>
	
				<cfreturn qryDeleteFile.RowsAffected gt 0 />
				
				<cfcatch><cfreturn False /></cfcatch>
			
			</cftry>
			
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>
	
	<!---
			CreateFolder
					
	--->
	<cffunction name="CreateFolder" access="public" returntype="boolean">
		<cfargument name="FolderPath" type="string" required="yes" default="#NullString#" />
		<cfargument name="FolderFriendlyName" type="string" required="yes" default="#NullString#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryCreateFolder">
					IF NOT EXISTS
					(
						SELECT
								folderID
						FROM
								file_Folder
						WHERE
								folderPath = '#Arguments.FolderPath#'
					)
					BEGIN
					
						INSERT
								file_Folder
								(
									folderPath,
									folderFriendlyName
								)
						VALUES
								(
									'#Arguments.FolderPath#',
									'#Arguments.FolderFriendlyName#'
								)
								
						SELECT SCOPE_IDENTITY() AS folderID
					END
				</cfquery>
				
				<cfreturn qryCreateFolder.RecordCount gt 0 />
				
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
			
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>
	
	<!---
			EditFolder
					
	--->
	<cffunction name="EditFolder" access="public" returntype="boolean">
		<cfargument name="FolderID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="FolderPath" type="string" required="yes" default="#NullString#" />
		<cfargument name="FolderFriendlyName" type="string" required="yes" default="#NullString#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryEditFolder">
					UPDATE
							file_Folder
					SET
							folderPath = '#Arguments.folderPath#',
							folderFriendlyName = '#Arguments.FolderFriendlyName#'
					WHERE
							folderID = #Arguments.FolderID#
				</cfquery>
				
				<cfreturn qryEditFolder.RowsAffected gt 0 />
				
				<cfcatch><cfreturn False /></cfcatch>
			
			</cftry>
			
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>
	
	<!---
			DeleteFolder
					
	--->
	<cffunction name="DeleteFolder" access="public" returntype="boolean">
		<cfargument name="FolderID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryDeleteFolder">
					UPDATE
							file_Folder
					SET
							isDeleted = 0
					WHERE
							folderID = #Arguments.FolderID#
				</cfquery>
				
				<cfreturn qryDeleteFolder.RowsAffected gt 0 />
				
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
			
		<cfelse>
			
			<cfreturn False />
			
		</cfif>
	
	</cffunction>
	
	<!---
			GetFileType
					Gets the Mime type of a file.
	--->
	<cffunction name="GetFileType" access="private" returntype="string">
		<cfargument name="ServerFilePath" type="string" required="yes" default="#NullString#" />
		
		<cfreturn getPageContext().getServletContext().getMimeType(ExpandPath(Arguments.ServerFilePath)) />
		
	</cffunction>
	
	<!---
			ajaxGetFileInfo
					AJAX function to return a JSON object containing the information about a file.
	--->
	<cffunction name="ajaxGetFileInfo" access="remote" returntype="struct" returnFormat="json">
		<cfargument name="FileID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfset retStruct = StructNew() />
		
		<cftry>
		
			<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
			
				<cfset qryFileInfo = GetFiles(FileID=Arguments.FileID) />
				
				<cfif qryFileInfo.RecordCount>
				
					<cfscript>
					
						StructInsert(retStruct, "FileName", qryFileInfo.fileName);
						StructInsert(retStruct, "Title", qryFileInfo.title);
						StructInsert(retStruct, "FileSize", qryFileInfo.fileSize);
						StructInsert(retStruct, "Keywords", qryFileInfo.keywords);
						StructInsert(retStruct, "MimeType", qryFileInfo.mimeType);
						StructInsert(retStruct, "FolderPath", qryFileInfo.folderPath);
						if(qryFileInfo.mimeType contains "image")
						{
							StructInsert(retStruct, "Width", qryFileInfo.width);
							StructInsert(retStruct, "Height", qryFileInfo.height);
						}
					
					</cfscript>
					
				<cfelse>
				
					<cfset StructInsert(retStruct, "Message", "No file info found") />
					
				</cfif>
				
			<cfelse>
			
				<cfset StructInsert(retStruct, "Message", "Invalid Session") />
					
			</cfif>
		
			<cfcatch>
				<cfset StructInsert(retStruct, "Message", cfcatch.Message) />
			</cfcatch>
			
		</cftry>
				
		<cfreturn retStruct />
	
	</cffunction>

</cfcomponent>