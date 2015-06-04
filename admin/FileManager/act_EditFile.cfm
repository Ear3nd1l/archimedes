<cfif isPostback>

	<cfquery datasource="#DSN#" name="qryUpdateFile" username="#sqlUser#" password="#sqlPassword#">
		UPDATE
				file_File
		SET
				title = '#form.txtTitle#',
				keywords = '#form.txtKeywords#'
		WHERE
				fileID = #form.hdnFileID#
	</cfquery>
	
	<cflocation url="index.cfm" addtoken="no" />

</cfif>