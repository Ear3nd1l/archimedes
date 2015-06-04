<cfobject component="#PageModule.cfcPath#" name="AnnouncementAdmin" />
<cfset AnnouncementAdmin.Init(PageModule.PageModuleID) />
<cfset qryAnnouncementItems = AnnouncementAdmin.AdminGetItems() />

<h3>Announcements:</h3>

<cfoutput>

	<input type="hidden" id="hdnAnnouncementBannerID" value="#AnnouncementAdmin.AnnouncementBannerID#" />

	<span id="spnAddNewAnnouncement">Add New Announcement</span>
	<table border="0" cellpadding="2" cellspacing="1" width="100%" class="tblData">
		<tr class="adminEditorRow" id="trAnnouncementEditorNew">
			<td colspan="4">
				<table border="0" cellpadding="2" cellspacing="1" width="100%">
					<tr>
						<td width="50%">
							<span class="iFrameFormLabel">Title</span>
							<input type="text" id="txtTitleNew" name="txtTitleNew" value="" class="iFrameFormInput" />
							<span id="valTitleNew" class="validationError">Required</span>
						</td>
						<td>
							<span class="iFrameFormLabel">Show On Home Page?</span>
							<div class="divRadioContainer">
								<img src="#Application.URLRoot#admin/images/toggleButtonNo.png" width="89" height="30" border="0" id="btnShowOnHomePageNew" class="btnToggle" hiddenField="rdoShowOnHomePageNew" />
								<input type="hidden" id="rdoShowOnHomePageNew" name="rdoShowOnHomePageNew" value="0" />
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<span class="iFrameFormLabel">Start Date</span>
							<input type="text" id="txtStartDateNew" name="txtStartDateNew" class="datePicker" value="" />
							<span id="valStartDateNew" class="validationError">Required</span>
						</td>
						<td>
							<span class="iFrameFormLabel">End Date</span>
							<input type="text" id="txtEndDateNew" name="txtEndDateNew" class="datePicker" value="" />
							<span id="valEndDateNew" class="validationError">Required</span>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<span class="iFrameFormLabel">Icon</span>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<span class="iFrameFormLabel">Abstract</span> <span id="valAbstractNew" class="validationError">Required</span>
							<textarea id="txtaAbstractNew" name="txtaAbstractNew" rows="4" class="iFrameFormInput"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<span class="iFrameFormLabel">Text</span> <span id="valTextNew" class="validationError">Required</span>
							<textarea id="txtaTextNew" name="txtaTextNew" rows="4" class="iFrameFormInput"></textarea>
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

<cfif qryAnnouncementItems.RecordCount>

	<table border="0" cellpadding="2" cellspacing="1" width="100%" class="tblData">
		<thead>
			<th width="60%">Title/Abstract</th>
			<th width="10%">Start Date</th>
			<th width="10%">End Date</th>
			<th></th>
			<th></th>
		</thead>
		<cfoutput query="qryAnnouncementItems">
			<tr class="tblDataRow">
				<td valign="top" align="left">
					<h5 class="h5AnnouncementTitle">#qryAnnouncementItems.title#</h5>
					<p class="pAnnouncementAbstract">#qryAnnouncementItems.abstract#</p>
				</td>
				<td valign="top" align="center">#DateFormat(qryAnnouncementItems.startDate, "mm/dd/yyyy")#</td>
				<td valign="top" align="center">#DateFormat(qryAnnouncementItems.endDate, "mm/dd/yyyy")#</td>
				<td valign="top" align="center"><span class="spnEditAnnouncement" announcementID="#qryAnnouncementItems.announcementID#">Edit</span>
				<td valign="top" align="center"><span class="spnDeleteAnnouncement" announcementID="#qryAnnouncementItems.announcementID#">Delete</span>
			</tr>
			<tr class="adminEditorRow" id="trAnnouncementEditor#qryAnnouncementItems.announcementID#">
				<td colspan="5">
					<table border="0" cellpadding="2" cellspacing="1" width="100%">
						<tr>
							<td width="50%">
								<span class="iFrameFormLabel">Title</span>
								<input type="text" id="txtTitle#qryAnnouncementItems.announcementID#" name="txtTitle#qryAnnouncementItems.announcementID#" value="#qryAnnouncementItems.title#" class="iFrameFormInput" />
								<span id="valTitle#qryAnnouncementItems.announcementID#" class="validationError">Required</span>
							</td>
							<td>
								<span class="iFrameFormLabel">Show On Home Page?</span>
								<div class="divRadioContainer">
									<img src="<cfif qryAnnouncementItems.showOnHomePage gt 0>#Application.URLRoot#admin/images/toggleButtonYes.png<cfelse>#Application.URLRoot#admin/images/toggleButtonNo.png</cfif>" width="89" height="30" border="0" id="btnShowOnHomePage#qryAnnouncementItems.announcementID#" class="btnToggle" hiddenField="rdoShowOnHomePage#qryAnnouncementItems.announcementID#" />
									<cfif qryAnnouncementItems.showOnHomePage gt 0>
										<input type="hidden" id="rdoShowOnHomePage#qryAnnouncementItems.announcementID#" name="rdoShowOnHomePage#qryAnnouncementItems.announcementID#" value="1" />
									<cfelse>
										<input type="hidden" id="rdoShowOnHomePage#qryAnnouncementItems.announcementID#" name="rdoShowOnHomePage#qryAnnouncementItems.announcementID#" value="0" />
									</cfif>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<span class="iFrameFormLabel">Start Date</span>
								<input type="text" id="txtStartDate#qryAnnouncementItems.announcementID#" name="txtStartDate#qryAnnouncementItems.announcementID#" class="datePicker" value="#DateFormat(qryAnnouncementItems.startDate, 'mm/dd/yyyy')#" />
								<span id="valStartDate#qryAnnouncementItems.announcementID#" class="validationError">Required</span>
							</td>
							<td>
								<span class="iFrameFormLabel">End Date</span>
								<input type="text" id="txtEndDate#qryAnnouncementItems.announcementID#" name="txtEndDate#qryAnnouncementItems.announcementID#" class="datePicker" value="#DateFormat(qryAnnouncementItems.endDate, 'mm/dd/yyyy')#" />
								<span id="valEndDate#qryAnnouncementItems.announcementID#" class="validationError">Required</span>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<span class="iFrameFormLabel">Icon</span>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<span class="iFrameFormLabel">Abstract</span> <span id="valAbstract#qryAnnouncementItems.announcementID#" class="validationError">Required</span>
								<textarea id="txtaAbstract#qryAnnouncementItems.announcementID#" name="txtaAbstract#qryAnnouncementItems.announcementID#" rows="4" class="iFrameFormInput">#qryAnnouncementItems.abstract#</textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<span class="iFrameFormLabel">Text</span> <span id="valText#qryAnnouncementItems.announcementID#" class="validationError">Required</span>
								<textarea id="txtaText#qryAnnouncementItems.announcementID#" name="txtaText#qryAnnouncementItems.announcementID#" rows="4" class="iFrameFormInput">#qryAnnouncementItems.text#</textarea>
							</td>
						</tr>
						<tr>
							<td align="left">
								<span class="iFrameFormButton SaveButton" announcementID="#qryAnnouncementItems.announcementID#">Save</span>
								<span id="valSummary#qryAnnouncementItems.announcementID#" class="validationError" style="float: right;">There are errors in your submission.</span>
							</td>
							<td align="right">
								<span class="iFrameFormButton CancelButton" announcementID="#qryAnnouncementItems.announcementID#">Cancel</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfoutput>
	</table>

<cfelse>
	<h4>There are currently no announcements.</h4>
</cfif>

<cfoutput>
	<script src="#Application.URLRoot#helpers/content/announcementsAdmin.js"></script>
</cfoutput>