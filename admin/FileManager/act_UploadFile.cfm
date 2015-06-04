<cfquery datasource="#DSN#" name="qryGetFolderPath" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			folderPath
	FROM
			file_Folder
	WHERE
			folderID = #form.ddlFolder#
</cfquery>

<cfset serverPath = expandpath(qryGetFolderPath.folderPath) />

<cffile action="upload" destination="#serverPath#" filefield="form.uploadFile" nameconflict="makeunique" />
<cfset extension = cffile.serverFileExt />

<cfquery datasource="#dsn#" name="qryGetFileType" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			fileTypeID,
			mimeType
	FROM
			file_FileType
	WHERE
			extension = '#extension#'
</cfquery>

<cfset FilePath = serverPath & cffile.serverFileName & "." & extension />

<!--- <cfif LEFT(qryGetFileType.mimeType, 5) eq "image" AND isDefined("form.chkAutoResize")>

	<cfinvoke component="image" method="getImageInfo" returnvariable="imageStructOriginal">
		<cfinvokeargument name="objImage" value="" />
		<cfinvokeargument name="inputFile" value="#FilePath#" />
	</cfinvoke>

	<cfsetting requesttimeout="5000" />
	
	 Create a small, medium and large version of the file 
	<cfif imageStructOriginal.width gt 250>
	
		<cfset largeFileName = cffile.serverFileName & "_Large." & extension />
		
		<cffile action="upload" destination="#serverPath#" filefield="form.uploadFile" result="serverFileLarge" nameconflict="makeunique" />
		<cffile action="rename" source="#serverPath##serverFileLarge.serverFileName#.#extension#" destination="#serverPath##largeFileName#" />
		
		<cfset largeHeight = (imageStructOriginal.height * 250) / 640 />
		
		<cfinvoke component="image" method="resize" returnvariable="imgInfo">
			<cfinvokeargument name="objImage" value="" />
			<cfinvokeargument name="inputFile" value="#serverPath##largeFileName#" />
			<cfinvokeargument name="outputFile" value="#serverPath##largeFileName#" />
			<cfinvokeargument name="newWidth" value="250" />
			<cfinvokeargument name="newHeight" value="#largeHeight#" />
			<cfinvokeargument name="preserveAspect" value="true" />
		</cfinvoke>
		
		<cfquery datasource="#dsn#" name="qryAddLargeFile" username="#sqlUser#" password="#sqlPassword#">
			INSERT
					file_File
					(
						folderID,
						fileName,
						fileTypeID,
						fileSize,
						dateLastModified,
						keywords,
						title,
						width,
						height
					)
			VALUES
					(
						#form.ddlFolder#,
						#largeFileName#',
						#qryGetFileType.fileTypeID#,
						#serverFileLarge.fileSize#,
						#DateFormat(now(), "yyyy-mm-dd")#',
						#form.txtKeywords#',
						#form.txtTitle# - Large',
						250,
						#largeHeight#
					)
		</cfquery>
		
	</cfif>
	
	<cfif imageStructOriginal.width gt 200>
	
		<cfset mediumFileName = cffile.serverFileName & "_Medium." & extension />
		
		<cffile action="upload" destination="#serverPath#" filefield="form.uploadFile" result="serverFileMedium" nameconflict="makeunique" />
		<cffile action="rename" source="#serverPath##serverFileMedium.serverFileName#.#extension#" destination="#serverPath##mediumFileName#" />
		
		<cfset mediumHeight = (imageStructOriginal.height * 200) / 640 />
		
		<cfinvoke component="image" method="resize" returnvariable="imgInfo">
			<cfinvokeargument name="objImage" value="" />
			<cfinvokeargument name="inputFile" value="#serverPath##mediumFileName#" />
			<cfinvokeargument name="outputFile" value="#serverPath##mediumFileName#" />
			<cfinvokeargument name="newWidth" value="200" />
			<cfinvokeargument name="newHeight" value="#mediumHeight#" />
			<cfinvokeargument name="preserveAspect" value="true" />
		</cfinvoke>
		
		<cfquery datasource="#dsn#" name="qryAddMediumFile" username="#sqlUser#" password="#sqlPassword#">
			INSERT
					file_File
					(
						folderID,
						fileName,
						fileTypeID,
						fileSize,
						dateLastModified,
						keywords,
						title,
						width,
						height
					)
			VALUES
					(
						#form.ddlFolder#,
						#mediumFileName#',
						#qryGetFileType.fileTypeID#,
						#serverFileMedium.fileSize#,
						#DateFormat(now(), "yyyy-mm-dd")#',
						#form.txtKeywords#',
						#form.txtTitle# - Medium',
						200,
						#mediumHeight#
					)
		</cfquery>
		
	</cfif>

	<cfif imageStructOriginal.width gt 175>
	
		<cfset smallFileName = cffile.serverFileName & "_Small." & extension />
		
		<cffile action="upload" destination="#serverPath#" filefield="form.uploadFile" result="serverFileSmall" nameconflict="makeunique" />
		<cffile action="rename" source="#serverPath##serverFileSmall.serverFileName#.#extension#" destination="#serverPath##smallFileName#" />
		
		<cfset smallHeight = (imageStructOriginal.height * 175) / 640 />
		
		<cfinvoke component="image" method="resize" returnvariable="imgInfo">
			<cfinvokeargument name="objImage" value="" />
			<cfinvokeargument name="inputFile" value="#serverPath##smallFileName#" />
			<cfinvokeargument name="outputFile" value="#serverPath##smallFileName#" />
			<cfinvokeargument name="newWidth" value="175" />
			<cfinvokeargument name="newHeight" value="#smallHeight#" />
			<cfinvokeargument name="preserveAspect" value="true" />
		</cfinvoke>
		
		<cfquery datasource="#dsn#" name="qryAddSmallFile" username="#sqlUser#" password="#sqlPassword#">
			INSERT
					file_File
					(
						folderID,
						fileName,
						fileTypeID,
						fileSize,
						dateLastModified,
						keywords,
						title,
						width,
						height
					)
			VALUES
					(
						#form.ddlFolder#,
						#smallFileName#',
						#qryGetFileType.fileTypeID#,
						#serverFileSmall.fileSize#,
						#DateFormat(now(), "yyyy-mm-dd")#',
						#form.txtKeywords#',
						#form.txtTitle# - Small',
						175,
						#smallHeight#
					)
		</cfquery>
		
		<!--- Delete the original --->
		<cffile action="delete" file="#filePath#" />
		
	</cfif>

<cfelse> --->

	<!--- <cfif LEFT(qryGetFileType.mimeType, 5) eq "image">
		<cfinvoke component="image" method="getImageInfo" returnvariable="imageStructOriginal">
			<cfinvokeargument name="objImage" value="" />
			<cfinvokeargument name="inputFile" value="#FilePath#" />
		</cfinvoke>
	</cfif> --->


	<cfquery datasource="#dsn#" name="qryAddFile" username="#sqlUser#" password="#sqlPassword#">
		INSERT
				file_File
				(
					folderID,
					fileName,
					fileTypeID,
					fileSize,
					dateLastModified,
					keywords,
					title
					<!--- <cfif LEFT(qryGetFileType.mimeType, 5) eq "image">
						,height
						,width
					</cfif> --->
				)
		VALUES
				(
					#form.ddlFolder#,
					'#cffile.serverFileName#.#extension#',
					#qryGetFileType.fileTypeID#,
					#cffile.fileSize#,
					'#DateFormat(now(), "yyyy-mm-dd")#',
					'#form.txtKeywords#',
					'#form.txtTitle#'
					<!--- <cfif LEFT(qryGetFileType.mimeType, 5) eq "image">
						,#imageStructOriginal.height#
						,#imageStructOriginal.width#
					</cfif> --->
				)
	</cfquery>
	
<!--- </cfif> --->

<cflocation url="index.cfm" addtoken="no" />