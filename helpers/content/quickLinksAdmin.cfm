<cfobject component="#PageModule.cfcPath#" name="QuickLinksAdmin" />
<cfset QuickLinksAdmin.Init(PageModule.PageModuleID) />
<cfset qryQuickLinksItems = QuickLinksAdmin.QuickLinksItems />

<h3>Quick Links:</h3>

<cfoutput>

	<input type="hidden" id="hdnQuickLinksID" value="#QuickLinksAdmin.QuickLinksID#" />

	<span id="spnAddNewLink">Add New Link</span>
	<span id="spnSortLinks">Sort Links</span>
	<span id="spnSaveSort">Save Sort Order</span>
	<span id="spnCancelSort">Cancel Sorting</span>
	
	<table border="0" cellpadding="2" cellspacing="1" width="100%" class="tblData">
		<tr class="adminEditorRow" id="trLinkEditorNew">
			<td>
				<table border="0" cellpadding="2" cellspacing="1" width="100%">
					<tr>
						<td width="50%">
							<span class="iFrameFormLabel">Title</span>
							<input type="text" id="txtLinkTextNew" name="txtLinkTextNew" value="" class="iFrameFormInput" />
							<span id="valLinkTextNew" class="validationError">Required</span>
						</td>
						<td width="50%">
							<span class="iFrameFormLabel">Open in new window?</span>
							<div class="divRadioContainer">
								<img src="#Application.URLRoot#admin/images/toggleButtonNo.png" width="89" height="30" border="0" id="btnIsNewWindowNew" class="btnToggle" hiddenField="rdoIsNewWindowNew" />
								<input type="hidden" id="rdoIsNewWindowNew" name="rdoIsNewWindowNew" value="0" />
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<span class="iFrameFormLabel">URL</span>
							<input type="text" id="txtURLNew" name="txtURLNew" value="" class="iFrameFormInput" />
							<span id="valURLNew" class="validationError">Required</span>
						</td>
					</tr>
					<tr>
						<td align="left">
							<span class="iFrameFormButton Save" id="SaveButtonNew">Save</span>
							<span id="valSummaryNew" class="validationError" style="float: right;">There are errors in your submission.</span>
						</td>
						<td align="right">
							<span class="iFrameFormButton Cancel" id="CancelButtonNew">Cancel</span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</cfoutput>

<cfif qryQuickLinksItems.RecordCount>

	<table border="0" cellpadding="2" cellspacing="1" width="100%" class="tblData">
		<thead>
			<th width="25%">Title</th>
			<th width="35%">URL</th>
			<th width="10%">New Window?</th>
			<th width="10%"></th>
			<th width="10%"></th>
		</thead>
		<cfoutput query="qryQuickLinksItems">

			<tr class="tblDataRow">
				<td valign="top" align="left">#qryQuickLinksItems.linkText#</td>
				<td valign="top" align="left">#qryQuickLinksItems.url#</td>
				<td valign="top" align="center">#YesNoFormat(qryQuickLinksItems.isNewWindow)#</td>
				<td valign="top" align="center"><span class="spnEditLink" linkID="#qryQuickLinksItems.linkID#">Edit</span>
				<td valign="top" align="center"><span class="spnDeleteLink" linkID="#qryQuickLinksItems.linkID#">Delete</span>
			</tr>
			<tr class="adminEditorRow" id="trLinkEditor#qryQuickLinksItems.linkID#">
				<td colspan="5">
					<table border="0" cellpadding="2" cellspacing="1" width="100%">
						<tr>
							<td width="50%">
								<span class="iFrameFormLabel">Title</span>
								<input type="text" id="txtLinkText#qryQuickLinksItems.linkID#" name="txtLinkText#qryQuickLinksItems.linkID#" value="#qryQuickLinksItems.linkText#" class="iFrameFormInput" />
								<span id="valLinkText#qryQuickLinksItems.linkID#" class="validationError">Required</span>
							</td>
							<td width="50%">
								<span class="iFrameFormLabel">Open in new window?</span>
								<div class="divRadioContainer">
									<img src="<cfif qryQuickLinksItems.isNewWindow eq 1>#Application.URLRoot#admin/images/toggleButtonYes.png<cfelse>#Application.URLRoot#admin/images/toggleButtonNo.png</cfif>" width="89" height="30" border="0" id="btnIsNewWindow#qryQuickLinksItems.linkID#" class="btnToggle" hiddenField="rdoIsNewWindow#qryQuickLinksItems.linkID#" />
									<input type="hidden" id="rdoIsNewWindow#qryQuickLinksItems.linkID#" name="rdoIsNewWindow#qryQuickLinksItems.linkID#" value="#qryQuickLinksItems.isNewWindow#" />
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<span class="iFrameFormLabel">URL</span>
								<input type="text" id="txtURL#qryQuickLinksItems.linkID#" name="txtURL#qryQuickLinksItems.linkID#" value="#qryQuickLinksItems.url#" class="iFrameFormInput" />
								<span id="valURL#qryQuickLinksItems.linkID#" class="validationError">Required</span>
							</td>
						</tr>
						<tr>
							<td align="left">
								<span class="iFrameFormButton SaveButton" linkID="#qryQuickLinksItems.linkID#">Save</span>
								<span id="valSummary#qryQuickLinksItems.linkID#" class="validationError" style="float: right;">There are errors in your submission.</span>
							</td>
							<td align="right">
								<span class="iFrameFormButton CancelButton" linkID="#qryQuickLinksItems.linkID#">Cancel</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>

		</cfoutput>
		
	</table>
	
	<!--- Create a UL list of the links for sorting. --->
	<ul id="ulSortableLinks" class="ulSortableList">
		<cfoutput query="qryQuickLinksItems">
			<li id="linkItem#qryQuickLinksItems.linkID#" linkID="#qryQuickLinksItems.linkID#" class="liSortableItem">#qryQuickLinksItems.linkText#</li>
		</cfoutput>
	</ul>
	
</cfif>

<cfoutput>
	<script src="#Application.URLRoot#helpers/content/quickLinksAdmin.js"></script>
</cfoutput>