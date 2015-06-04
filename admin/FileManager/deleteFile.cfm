<cfquery datasource="#dsn#" name="qryGetFileDetails" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			*
	FROM
			file_File f INNER JOIN
			file_FileType ft ON f.fileTypeID = ft.fileTypeID
	WHERE
			fileID = #url.fileID#
</cfquery>

<cfquery datasource="#DSN#" name="qryGetFolderPath" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			folderPath
	FROM
			file_Folder
	WHERE
			folderID = #qryGetFileDetails.folderID#
</cfquery>

<cfinvoke component="image" method="getImageInfo" returnvariable="imageStruct">
	<cfinvokeargument name="objImage" value="" />
	<cfinvokeargument name="inputFile" value="#ExpandPath(qryGetFolderPath.folderPath)##qryGetFileDetails.fileName#" />
</cfinvoke>

<cfif imageStruct.width gt 200>
	<cfset width = 200 />
<cfelse>
	<cfset width = imageStruct.width />
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Delete File</title>
</head>

<body>

	<cfoutput>
	
		<form action="deleteFile.cfm?fileID=#url.fileID#">
		
			Delete this file?<br />
			
			<img src="#qryGetFolderPath.folderPath##qryGetFileDetails.filename#" border="0" />
	
		</form>
		
	</cfoutput>
	
</body>
</html>
