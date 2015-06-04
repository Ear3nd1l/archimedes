<!--- <cfquery datasource="#dsn#" name="qryFolders">
	SELECT
			folderID,
			folderPath,
			folderFriendlyName
	FROM
			file_Folder
	WHERE
			isActive = 1
			AND isDeleted = 0
</cfquery>

<cfoutput query="qryFolders">

	<cfset serverPath = ExpandPath(qryFolders.folderPath) />
	
	<cfdirectory action="list" directory="#serverPath#" name="dirFiles" />
	
		<cfloop query="dirFiles">
			
			<cfif dirFiles.type eq "File">
		
				Loading file: #dirFiles.name#...
				
				<cftry>
				
					<cfset extension = ListGetAt(dirFiles.name, ListLen(name, "."), ".") />
					
					<cfquery datasource="#dsn#" name="qryGetFileType">
						SELECT
								fileTypeID
						FROM
								file_FileType
						WHERE
								extension = '#extension#'
					</cfquery>
					
					<cfif qryGetFileType.RecordCount>
						<cfset fileTypeID = qryGetFileType.fileTypeID />
					<cfelse>
						<cfset fileTypeID = 0 />
					</cfif>
					
					<cfquery datasource="#dsn#" name="qryAddFile">
						IF NOT EXISTS
						(
							SELECT
									fileID
							FROM
									file_File
							WHERE
									filename = '#dirFiles.name#'
						)
						BEGIN
							INSERT
									file_File
									(
										fileName,
										folderID,
										fileTypeID,
										fileSize,
										dateLastModified
									)
							VALUES
									(
										'#dirFiles.name#',
										#qryFolders.folderID#,
										#fileTypeID#,
										#dirFiles.size#,
										'#DateFormat(dirFiles.dateLastModified, "yyyy-mm-dd")#'
									)
							SELECT SCOPE_IDENTITY() AS fileID
						END
						ELSE
							SELECT 0 AS fileID
					</cfquery>

					<cfif qryAddFile.fileID gt 0>
						done!
					<cfelse>
						<span style="color: blue;">duplicate!</span>
					</cfif>
					<br />
					
					<cfcatch><span style="color: red;">FAILED!</span><br />#cfcatch.Detail#<br /></cfcatch>
				
				</cftry>
				
			</cfif>
		
		</cfloop>

</cfoutput> --->