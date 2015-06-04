<cfparam name="form.fileID" default="188" />
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

<cfquery datasource="#DSN#" name="qryGetFolderPath" username="#sqlUser#" password="#sqlPassword#">
	SELECT
			folderPath
	FROM
			file_Folder
	WHERE
			folderID = #qryGetFileDetails.folderID#
</cfquery>

<cfoutput query="qryGetFileDetails">
	Title: #qryGetFileDetails.title#<br />
	Keywords: #qryGetFileDetails.keywords#<br />
	File Name: #qryGetFileDetails.fileName#<br />
	Size: #qryGetFileDetails.fileSize#KB<br />
	Type: #qryGetFileDetails.mimeType#<br />
	<span id="spnEditFile" style="text-decoration: underline; cursor: pointer;" title="#qryGetFileDetails.fileID#">Edit</span>
	<span id="spnDeleteFile" style="text-decoration: underline; cursor: pointer;" title="#qryGetFileDetails.fileID#">Delete</span>
	<br />
	Path: <input id="txtImagePath" style="width: 80%; margin: 5px 0; display: inline; border: 1px solid ##ccc;;" value="#qryGetFolderPath.folderPath##qryGetFileDetails.fileName#" />
	<!--- <cfif Left(qryGetFileDetails.mimeType, 5) eq "image">
		<cfinvoke component="image" method="getImageInfo" returnvariable="imageStructOriginal">
			<cfinvokeargument name="objImage" value="" />
			<cfinvokeargument name="inputFile" value="#ExpandPath(qryGetFolderPath.folderPath)##qryGetFileDetails.fileName#" />
		</cfinvoke>
		Width: #imageStructOriginal.width#px<br />
		Height: #imageStructOriginal.height#px<br />
		<cfif imageStructOriginal.width LTE 200 AND imageStructOriginal.width neq 0>
			<img src="#qryGetFolderPath.folderPath##qryGetFileDetails.filename#" border="0" />
		</cfif>
	</cfif> --->
</cfoutput>

<script type="text/javascript">
	$(function() {
		$('#spnEditFile').click(function() {
			$('#divEditFileControls').load('ajax_EditFile.cfm', { fileID : $(this).attr('title') });
			$.jqLightbox('#divEditFile','fast');
		});
		$('#spnDeleteFile').click(function() {
			var answer = confirm('Are you sure you want to delete this file? This does not delete the file from the server, but only deletes it from the File Manager.');
			
			if(answer)
			{
				window.location = 'act_DeleteFile.cfm?fileID=' + $(this).attr('title');
			}
			else
			{
			}
			
		});
		$('#txtImagePath').focus(function()   {
		   $(this).select();
		});
	});
	
</script>