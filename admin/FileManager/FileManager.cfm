<cfset SectionID = 3 />

<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="File Manager" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#" HelperPath="#Application.HelperPath#" CodeBehind="FileManager.js">

	<cfobject component="ArchimedesCFC.FileManager.Atheneum" name="FileManager" />
	
	<cfset qryFolders = FileManager.GetFolders() />
	
	<cfoutput>
	
		<div id="divFolders">
		
			<div id="divFolderList">
				<cfloop query="qryFolders">
				
					<h3 class="folderHandle" tabPanel="pnlFolder#qryFolders.folderID#">#qryFolders.folderFriendlyName#</h3>
				
				</cfloop>
			</div>
			
			<div id="divFolderContainer">

				<cfloop query="qryFolders">
				
					<cfset qryFolderFiles = FileManager.GetFiles(qryFolders.folderID) />
					
					<div class="filePanel" id="pnlFolder#qryFolders.folderID#">
					
						<cfif qryFolderFiles.RecordCount>
					
							<table border="0" cellpadding="2" cellspacing="1" width="398" class="tblFileList">
							
								<cfloop query="qryFolderFiles">
									<tr class="fileRow" fileID="#qryFolderFiles.fileID#">
										<td width="75%" valign="middle" class="fileCell" fileID="#qryFolderFiles.fileID#">
											<cfif Len(qryFolderFiles.title) gt 0>#Left(qryFolderFiles.title, 75)#<cfelse>#Left(qryFolderFiles.fileName, 75)#</cfif>
										</td>
										<cfif qryFolderFiles.mimeType contains "image">
											<td align="center" valign="middle">
												<span class="lnkPreview" image="#qryFolders.folderPath##qryFolderFiles.fileName#" fileID="#qryFolderFiles.fileID#">Preview</span>
											</td>
										<cfelse>
											<td></td>
										</cfif>
									</tr>
								</cfloop>
							
							</table>
							
						<cfelse>
						
							<p class="lblEmptyFolder">No files found for the folder: '#qryFolders.folderFriendlyName#'</p>
						
						</cfif>
					
					</div>
				
				</cfloop>
				
			</div>
			
			<div id="divFilePreview">
				
				<div class="filePreviewRow">
					<span class="filePreviewLabel">Title</span>
					<span class="filePreviewValue" id="lblFileTitle"></span>
				</div>
				
				<div class="filePreviewRow">
					<span class="filePreviewLabel">File Name</span>
					<span class="filePreviewValue" id="lblFileName"></span>
				</div>
				
				<div class="filePreviewRow">
					<span class="filePreviewLabel">File Size</span>
					<span class="filePreviewValue" id="lblFileSize"></span>
				</div>

				<div class="filePreviewRow">
					<span class="filePreviewLabel">Keywords</span>
					<span class="filePreviewValue" id="lblFileKeywords"></span>
				</div>

				<div class="filePreviewRow">
					<span class="filePreviewLabel">File Type</span>
					<span class="filePreviewValue" id="lblMimeType"></span>
				</div>

				<div class="filePreviewRow">
					<span class="filePreviewLabel">Dimensions (WxH)</span>
					<span class="filePreviewValue" id="lblFileDimensions"></span>
				</div>
				
				<div class="filePreviewRow">
					<img src="" width="250" height="250" border="0" id="imgFilePreview" />
				</div>

			</div>
		
		</div>
		
		<div id="divImagePreviewLightbox" class="lightBox">
			<img src="" id="imgLightboxPreview" border="0" />
		</div>
		
		<script>
		
			defaultPanel = 'pnlFolder#qryFolders.folderID#';
		
		</script>
	
	</cfoutput>

</cf_AdminMasterPage>