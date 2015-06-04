<!--- Get folders --->
<cfquery datasource="#dsn#" name="qryFolders" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			folderID,
			folderFriendlyName
	FROM
			file_Folder
	WHERE
			isActive = 1
			AND isDeleted = 0
</cfquery>

<div id="divUploadFile" class="hidden">
	
	<div class="divLightboxHeader"><span class="spnLightboxHeader">Upload File</span></div>
	
	<form action="act_UploadFile.cfm" method="post" enctype="multipart/form-data" class="frmAjaxForm">
	
		<select name="ddlFolder">
			<cfoutput query="qryFolders">
				<option value="#qryFolders.folderID#">#qryFolders.folderFriendlyName#</option>
			</cfoutput>
		</select>
		<br /><br />
		
		<label for="uploadFile">Choose File:</label><br />
		<input type="file" name="uploadFile" />
		
		<br /><br />
		<label for="txtTitle" title="Title:">Title:</label><br />
		<input type="text" name="txtTitle" maxlength="100" style="width: 250px;" /><br />
		
		<br />
		<label for="txtKeywords">Keywords:</label><br />
		<input type="text" name="txtKeywords" maxlength="100" style="width: 250px;" /><br />
	
		<!---<br />
		<input type="checkbox" name="chkAutoResize" value="1" />
		<label for="chkAutoResize">Automatically resize?</label><br />--->
	
		<br />
		<input type="submit" value="Upload" />
		<input type="button" value="Cancel" class="CloseWindow" />
	</form>
	
	
	<div class="divLightboxFooter"></div>
</div>