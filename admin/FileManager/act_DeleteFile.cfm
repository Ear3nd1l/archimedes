<cfparam name="url.fileID" default="0" />

<cfquery datasource="#dsn#" name="qryDeleteFile" username="#sqlUser#" password="#sqlPassword#">
	DELETE
	FROM
			file_File
	WHERE
			fileID = #url.fileID#
</cfquery>

<cflocation url="index.cfm" addtoken="no" />