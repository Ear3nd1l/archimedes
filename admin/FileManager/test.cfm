<cfinclude template="#includePath#/header.cfm">

<h3>File Manager:</h3>

<cfsilent>
	<cfquery datasource="#dsn#" name="qryFolders" username="#sqlUser#" password="#sqlPassword#">
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
</cfsilent>

<script type="text/javascript" src="/js/jQuery/jquery-1.2.6.min.js"></script>
<script type="text/javascript" src="/js/jQuery/fileManager.js"></script>

<style type="text/css">
	@import url("/css/admin.css");
	@import url("/css/boxy.css");
	@import url("/css/prettyPhoto.css");
	
	.lightboxOverlay
	{
		opacity: .80;
		filter: alpha(opacity=80);
		background-color: #000;
		position: absolute;
		top: 0;
		left: 0;
		z-index: 99;
		height: 0;
		width: 0;
		zoom: 1;
	}
	
	#divUploadFile
	{
		z-index: 100;
		position: absolute;
		padding: 0px;
		width: 840px;
	}

	#divEditFile
	{
		z-index: 100;
		position: absolute;
		padding: 0px;
		width: 840px;
		min-height: 230px;
	}

	#divLightbox
	{
		z-index: 100;
		position: absolute;
		padding: 10px;
		min-height: 100px;
		min-width: 100px;
		background-color: #fff;
		text-align: center;
		margin: 0;
	}
	
	.divLightboxHeader
	{
		margin: 0;
		text-align: center;
		background-image: url('/images/jqLightboxHeader.png');
		height: 26px;
		padding-top: 4px;
	}
	
	.spnLightboxHeader
	{
		color: #fff;
		font-size: 12px;
		font-family: Tahoma, Arial, Helvetica, sans-serif;
		font-weight: bold;
	}
	
	.frmAjaxForm
	{
		width: 100%;
		padding: 10px;
		background-image: url('/images/jqLightboxBackground.png');
		background-repeat: repeat-y;
		margin: 0;
	}
	
	.divLightboxFooter
	{
		margin: 0;
		text-align: center;
		background-image: url('/images/jqLightboxFooter.png');
		height: 36px;
	}

	.hidden
	{
		display: none;
	}
	
	#lnkUploadFile
	{
		font-weight: bold;
		cursor: pointer;
	}
	
	#spnCloseImageLightbox
	{
		/*clear: both;
		float: right;*/
		cursor: pointer;
	}
	
	#spnImagePath
	{
		white-space: nowrap;
	}
	
	.lnkPreview
	{
		cursor: pointer;
		text-decoration: underline;
	}
	
	.selectedRow
	{
		background-color: #999;
		color: fff;
	}
	.selectedRow td
	{
		color: #fff;
	}
</style>

<span id="lnkUploadFile">Upload New File</span><br /><br />

<div id="divTabber" style="width: 790px;">

	<cfoutput query="qryFolders"><h4 class="tab normal" id="tab#Replace(qryFolders.folderFriendlyName, ' ', '', 'all')#" title="div#Replace(qryFolders.folderFriendlyName, ' ', '', 'all')#">#qryFolders.folderFriendlyName#</h4></cfoutput>
	
	<cfoutput query="qryFolders">
	
		<cfset serverPath = ExpandPath(qryFolders.folderPath) />
		
		<cfquery datasource="#DSN#" name="qryFiles" username="#sqlUser#" password="#sqlPassword#">
			SELECT
					f.fileID,
					f.fileName,
					ft.mimetype,
					CASE
						WHEN f.title IS NULL THEN f.fileName
						ELSE f.title
					END AS title
			FROM
					file_File f INNER JOIN
					file_FileType ft ON f.fileTypeID = ft.fileTypeID
			WHERE
					folderID = #qryFolders.folderID#
			ORDER BY
					title
		</cfquery>
		
		<div style="overflow: scroll; height: 400px; width: 510px; margin-top: 2px; border: 1px solid ##555; float: left;" id="div#Replace(qryFolders.folderFriendlyName, ' ', '', 'all')#" class="tabPanel">
			<table border="0" cellpadding="2" cellspacing="1" width="493">
			
				<cfloop query="qryFiles">
					<tr class="fileRow" fileID="#qryFiles.fileID#">
						<td width="485">
							<cfif Len(qryFiles.title) gt 0>#qryFiles.title#<cfelse>#qryFiles.fileName#</cfif>
						</td>
						<cfif Left(qryFiles.mimeType, 5) eq "image">
							<td>
								<span class="lnkPreview" title="/images/#fileName#" href="/images/#fileName#" fileID="#qryFiles.fileID#">Preview</span>
							</td>
						</cfif>
					</tr>
				</cfloop>
				
			</table>
		</div>
	
	</cfoutput>
	
	<div id="divInfo" style="height: 380px; width: 250px; margin-top: 2px; border: 1px solid #555; float: right; overflow: scroll; padding: 10px;">
	</div>
	
	<div style="clear: both;"></div>
	
</div>

<cfinclude template="inc_UploadFile.cfm" />

<cfinclude template="inc_EditFile.cfm" />

<cfinclude template="inc_Lightbox.cfm" />

<div class="lightboxOverlay"></div>


<cfoutput>
	<script type="text/javascript">
	
		$(function () {
		
			$.makeTabs('divTabber','div#Replace(qryFolders.folderFriendlyName, ' ', '', 'all')#');
			
			$('.fileRow').click(function() {
				var fileID = $(this).attr('fileID');
				$('##divInfo').load('infoBox.cfm', { fileID : $(this).attr('fileID')});
				$('.selectedRow').removeClass('selectedRow').addClass('fileRow');
				$(this).addClass('selectedRow').removeClass('fileRow');
			});
			
			$('.lnkPreview').click(function() {
				var fileID = $(this).attr("fileID");
				$('##jqLightboxImage').attr('src', $(this).attr('title'));
			});
			
			$('##jqLightboxImage').load(function() {
				$('##divLightbox').height(this.height + 40).width(this.width + 20);
				$('##divLightbox').Lightbox('fast');
			});

			$('##lnkUploadFile').click(function() {
				$('##divUploadFile').Lightbox('fast');
			});

		});
		
	</script>
</cfoutput>

<cfinclude template="#includePath#/footer.cfm" />