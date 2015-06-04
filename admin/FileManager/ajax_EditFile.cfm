<cfsetting showdebugoutput="no" />
<cfquery datasource="#dsn#" name="qryGetFileDetails" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			*
	FROM
			file_File f INNER JOIN
			file_FileType ft ON f.fileTypeID = ft.fileTypeID
	WHERE
			fileID = #form.fileID#
</cfquery>

<cfoutput>

	<input type="hidden" name="hdnFileID" value="#form.fileID#" />

	<label for="txtTitle" title="Title:">Title:</label><br />
	<input type="text" name="txtTitle" maxlength="100" style="width: 250px;" value="<cfif Len(Trim(qryGetFileDetails.title)) gt 0>#qryGetFileDetails.title#<cfelse>No title</cfif>" /><br />
	
	<br />
	<label for="txtKeywords">Keywords:</label><br />
	<input type="text" name="txtKeywords" maxlength="100" style="width: 250px;" value="<cfif Len(Trim(qryGetFileDetails.keywords)) gt 0>#qryGetFileDetails.keywords#<cfelse>No keywords</cfif>" /><br />
	
</cfoutput>