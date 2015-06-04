<!--- Define the PageTemplate variable --->
<cfparam name="url.PageTemplateID" default="#NullInt#" />

<cfset SectionID = 2 />

<cfset MinimumRank = 9 />
<cfinclude template="#Application.HelperPath#/admin/verifyAccess.cfm" />

<cfobject component="ArchimedesCFC.PageTemplate" name="PageTemplate" />
<cfset PageTemplate.Init(url.PageTemplateID) />

<cfobject component="ArchimedesCFC.Page" name="Page" />

<cfif isPostback>

	<!--- Validate the form --->
	<cfobject component="ArchimedesCFC.validate" name="Validate" />
	
	<cfscript>
	
		// Trim the form fields
		Validate.TrimStruct(form);
		
		If(Len(form.txtPageTitle) eq 0) Validate.ErrorMsg('Page Title is required', 'txtPageTitle');
		If(Len(form.txtMenuTitle) eq 0) Validate.ErrorMsg('Menu Title is required', 'txtMenuTitle');
		If(Len(form.txtRedirectPath) eq 0) Validate.ErrorMsg('Page URL is required', 'txtRedirectPath');
		If(Len(form.hdnLayoutID) eq 0) Validate.ErrorMsg('You must choose a layout', 'hdnLayoutID');
		If(Len(form.hdnAccessLevelID) eq 0) ValidateErrorMsg('You must choose an Access Level', 'hdnAccessLevelID');
	
	</cfscript>

	<!--- If the form is valid, create the page. --->
	<cfif Validate.IsValidForm()>
	
		<cfscript>
			// Set the properties
			Page.PageTitle = form.txtPageTitle;
			Page.MenuText = form.txtMenuTitle;
			Page.ParentID = form.ddlParentID;
			Page.SiteID = Application.SiteID;
			try
			{
				Page.DepartmentID = form.ddlDepartmentID;
			}
			catch(any excpt)
			{
				Page.DepartmentID = 16;
			}
			try
			{
				Page.RedirectPath = form.hdnDepartmentPath & form.txtRedirectPath & '.cfm';
			}
			catch(any excpt)
			{
				Page.RedirectPath = '/' & form.txtRedirectPath & '.cfm';
			}
			Page.PageKeywords = form.txtPageKeywords;
			Page.PageDescription = form.txtaPageDescription;
			Page.ShowInNavigation = form.rdoShowInNavigation;
			Page.ShowBreadcrumbs = form.rdoShowBreadcrumbs;
			Page.ShowInSiteMap = form.rdoShowInSiteMap;
			Page.LayoutID = form.hdnLayoutID;
			Page.AccessLevelID = form.hdnAccessLevelID;
			
			// Save the page
			Page.Save();
		</cfscript>
		
		
		<!--- Add default modules to the page. --->
		<cfset qryTemplateModules = PageTemplate.TemplateModules />
		
		<cfobject component="ArchimedesCFC.modules.pageModule" name="PageModule" />
		
		<cfloop query="qryTemplateModules">
			
			<cfinvoke component="#PageModule#" method="AddModuleToBucket" returnvariable="pageModuleID">
				<cfinvokeargument name="ModuleID" value="#qryTemplateModules.moduleID#" />
				<cfinvokeargument name="BucketID" value="#qryTemplateModules.bucketID#" />			
				<cfinvokeargument name="PageID" value="#Page.PageID#" />
			</cfinvoke>
			
		</cfloop>
		
		<!--- If the user is not a site admin, make them a page admin. --->
		<cfif Session.Profile.HighestRank lt 10>
			<cfset Session.Profile.GrantUserPageManagerRight(Page.PageID) />
		</cfif>
		
		<!--- Send the user back to the Page Manager. --->
		<cflocation url="#Application.URLRoot#Admin/Page/PageEditor.cfm?PageID=#Page.PageID#" addtoken="no" />
		
	</cfif>
	
</cfif>

<cfscript>

	/*
		If the user is an admin:
		
			Get all departments in a hierarchical tree.
			Get all pages in a hierarchical tree.
			
			Otherwise, get both trees based on the user's info.
	*/
	if(Session.Profile.HighestRank eq 10)
	{
		qryDepartmentInfo = AdminFunctions.GetDepartmentInfo(Application.SiteID,0,False);
		pageBasePath = qryDepartmentInfo.departmentPath;
		qryDepartmentPages = Page.GetMenuPagesForAdmin(Application.SiteID,NullInt,0,False);
	}
	else
	{
		qryDepartmentInfo = AdminFunctions.GetDepartmentInfo(Application.SiteID,Session.Profile.DepartmentID,False);
		pageBasePath = qryDepartmentInfo.departmentPath;
		qryDepartmentPages = Page.GetMenuPagesForAdmin(Application.SiteID,NullInt,0,True);
	}
	
	// Get the access levels.  If the user is the Executive Director, include the hidden access levels.
	if(Session.Profile.HasRole('Executive Director'))
	{
		qryAccessLevels = Page.GetAccessLevels(True);
	}
	else
	{
		qryAccessLevels = Page.GetAccessLevels();
	}
	
	// Get the layouts
	qryLayouts = Application.Site.GetLayouts();
	
	// Get all users who are not admins
	qryAvailableUsers = Session.Profile.GetUsersWithLowerRank(10,Application.SiteID);
	
	// Get the templates default modules
	qryTemplateModules = PageTemplate.TemplateModules;

</cfscript>

<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="Create Page Wizard" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#" HelperPath="#Application.HelperPath#" CodeBehind="CreatePageWizard.js">

	<cfoutput>
	
		<h3 class="templateName">#PageTemplate.TemplateName#</h3>
		<p class="templateDescription">#PageTemplate.Description#</p>
		<!---
		<p class="helpCallout">The page is not created until you complete the wizard. Please do not refresh the page or use your browser's back or forward buttons.</p>
	--->
		<form method="post" action="CreatePageWizard.cfm?PageTemplateID=#url.pageTemplateID#" id="frmCreatePageWizard">
		
			<input type="hidden" name="hdnPageTemplateID" value="#PageTemplate.TemplateID#" />
		
			<div id="divWizardContainer">
			
				<div id="pnlStep0" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Page Parent</h3>
					
					<p class="wizardText">How does this page relate in the structure of the site?</p>
					
					<select id="ddlParentID" name="ddlParentID">
						<cfloop query="qryDepartmentPages">
							<option value="#qryDepartmentPages.menuItemID#" menuTitle="#qryDepartmentPages.MenuText#">#qryDepartmentPages.MenuText#</option>
						</cfloop>
					</select>
					
					<span class="formWizardButton WizardNext" id="lnkStep0Next">Next</span>
				
				</div>
		
				<div id="pnlStep1" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Page Title</h3>
				
					<p class="wizardText">Please enter a title for the page.  This is the title that appears in a search result and the browser's title bar.</p>
			
					<input type="text" id="txtPageTitle" name="txtPageTitle" class="formTextbox" />
					<span id="valPageTitle" class="validationErrorMarker">Required</span>
					
					<span class="formWizardButton WizardBack" id="lnkStep1Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep1Next">Next</span>
				
				</div>
				
				<div id="pnlStep2" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Menu Title</h3>
				
					<p class="wizardText">How will this page appear in the navigation menu?</p>
				
					<input type="text" id="txtMenuTitle" name="txtMenuTitle" class="formTextbox" />
					<span id="valMenuTitle" class="validationErrorMarker">Required</span>
					
					<span class="formWizardButton WizardBack" id="lnkStep2Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep2Next">Next</span>
				
				</div>
				
				<div id="pnlStep3" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Page URL</h3>
					
					<cfif qryDepartmentInfo.RecordCount gt 1>
						<p class="wizardText">Please choose the department for this page from the dropdown list. Then enter the page name in the textbox.</p>
						
						<select id="ddlDepartmentID" name="ddlDepartmentID">
							<cfloop query="qryDepartmentInfo">
								<option value="#qryDepartmentInfo.departmentID#" departmentPath="#qryDepartmentInfo.departmentPath#">#qryDepartmentInfo.department#</option>
							</cfloop>
						</select>
						<input type="hidden" name="hdnDepartmentPath" id="hdnDepartmentPath" value="" />
						
						<div class="clearWithMargin"></div>
					<cfelse>
						<p class="wizardText">Please enter the URL for the page.</p>
					</cfif>
				
					<input type="text" id="txtRedirectPath" name="txtRedirectPath" class="formTextbox" /><span style="float: left;">.cfm</span>
					<input type="hidden" id="hdnDepartmentPath" value="#pageBasePath#" />
					<span id="valRedirectPath" class="validationErrorMarker">Required</span>
					<div class="clear"></div>
					<p class="helpNote">Do not include the extension (.cfm).</p>
					
					<p id="pURLPreview">The URL will be as follows: http://#Application.URLRoot#<span id="spnDepartmentPath">#pageBasePath#</span><span id="spnURLPreview"></span>.cfm</p>
					
					<p class="validationError" id="valDuplicateRedirectPath">A page with this URL already exists.  Please choose another.</p>
					
					<span class="formWizardButton WizardBack" id="lnkStep3Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep3Next">Next</span>
				
				</div>
				
				<div id="pnlStep4" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Keywords and Description</h3>

					<p class="wizardText">Specify keywords and a description for the page.  This is used for the search.</p>
				
					<label for="txtPageKeywords" class="wizardLabel">Page Keywords</label>
					<input type="text" id="txtPageKeywords" name="txtPageKeywords" class="formTextbox" />
					<span id="valPageKeywords" class="validationErrorMarker">Required</span>
					
					<div class="clearWithMargin"></div>
					
					<label for="txtaPageDescription" class="wizardLabel">Page Description</label>
					<textarea id="txtaPageDescription" name="txtaPageDescription" class="formTextarea"></textarea>
				
					<span class="formWizardButton WizardBack" id="lnkStep4Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep4Next">Next</span>
	
				</div>
				
				<div id="pnlStep5" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Navigation and Site Map</h3>

					<label for="rdoShowInMenu" class="wizardLabel">Show In Navigation?</label>
					<div class="divRadioContainer">
						<img src="#Application.URLRoot#admin/images/toggleButtonYes.png" width="89" height="30" border="0" id="btnShowInMenu" class="btnToggle" hiddenField="rdoShowInMenu" />
						<input type="hidden" id="rdoShowInMenu" name="rdoShowInNavigation" value="1" />
					</div>
					
					<div class="clearWithMargin"></div>
	
					<input type="hidden" id="rdoShowBreadcrumbs" name="rdoShowBreadcrumbs" value="1" />
	
					<div class="clearWithMargin"></div>
					
					<label for="rdoShowInSiteMap" class="wizardLabel">Show in Site Map?</label>
					<div class="divRadioContainer">
						<img src="#Application.URLRoot#admin/images/toggleButtonYes.png" width="89" height="30" border="0" id="btnShowInSiteMap" class="btnToggle" hiddenField="rdoShowInSiteMap" />
						<input type="hidden" id="rdoShowInSiteMap" name="rdoShowInSiteMap" value="1" />
					</div>
					
					<span class="formWizardButton WizardBack" id="lnkStep5Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep5Next">Next</span>
	
				</div>
				
				<div id="pnlStep6" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Page Layout</h3>

					<!--- If this is the blank template, allow the user to select a layout --->
					<cfif PageTemplate.TemplateName eq "Standard Page">
					
						<p>Choose the layout for this page.  <strong>This cannot be changed once the page is created.</strong></p>
						
						<p id="valLayout" class="validationError">You must choose a layout.</p>
		
						<cfloop query="qryLayouts">
							<div class="layoutItem" id="divLayout#qryLayouts.layoutID#" layoutID="#qryLayouts.layoutID#">
								<img src="#Application.URLRoot#admin/images/Layouts/layoutIconLargeLayout#qryLayouts.layoutID#.png" width="100" height="100" border="0" class="imgLayoutIcon" id="imgLayoutIcon#qryLayouts.layoutID#" />
								<p class="layoutName" id="pLayoutName#qryLayouts.layoutID#">#qryLayouts.name#</p>
								<p class="layoutDescription" id="pLayoutDescription#qryLayouts.layoutID#">#qryLayouts.description#</p>
							</div>
						</cfloop>
						
						<input type="hidden" name="hdnLayoutID" id="hdnLayoutID" value="" />
					
					<cfelse>
					
						<p class="wizardText">The page will be created with the following layout:</p>
					
						<div class="divLayoutOptions">
							<img src="#Application.URLRoot#admin/images/Layouts/layoutIconLargeLayout#PageTemplate.layoutID#.png" width="100" height="100" border="0" class="imgLayoutIconPageWizard" id="imgLayoutIcon#PageTemplate.layoutID#" />
							<div class="layoutOptionsPageWizard">
								<p class="layoutName" id="pLayoutName#PageTemplate.layoutID#">#PageTemplate.LayoutName#</p>
								<p class="layoutDescription" id="pLayoutDescription#PageTemplate.layoutID#">#PageTemplate.LayoutDescription#</p>
							</div>
						</div>
						
						<input type="hidden" name="hdnLayoutID" id="hdnLayoutID" value="#PageTemplate.layoutID#" />

					</cfif>
					
					<span class="formWizardButton WizardBack" id="lnkStep6Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep6Next">Next</span>

				</div>
				
				<div id="pnlStep7" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Access Level</h3>
					
					<p class="wizardText">Set the access level for this page.</p>
				
					<p id="valAccessLevel" class="validationError">You must choose an Access Level.</p>

					<div class="divRadioContainer">
						<cfloop query="qryAccessLevels">
							<div class="accessLevelItem" id="divAccessLevel#qryAccessLevels.accessLevelID#" accessLevelID="#qryAccessLevels.accessLevelID#">
								<img src="#Application.URLRoot#admin/images/AccessLevels/#qryAccessLevels.icon#" width="100" height="100" border="0" class="imgAccessLevelIcon" id="imgAccessLevelItemIcon#qryAccessLevels.accessLevelID#" />
								<p class="accessLevelItemName" id="pAccessLevelItemName#qryAccessLevels.accessLevelID#">#qryAccessLevels.accessLevel#</p>
								<p class="accessLevelItemDescription" id="pAccessLevelItemDescription#qryAccessLevels.accessLevelID#">#qryAccessLevels.description#</p>
							</div>
						</cfloop>
					</div>
				
					<input type="hidden" name="hdnAccessLevelID" id="hdnAccessLevelID" value="" />

					<span class="formWizardButton WizardBack" id="lnkStep7Back">Back</span>
					<span class="formWizardButton WizardNext" id="lnkStep7Next">Next</span>

				</div>
				
				<div id="pnlSummary" class="wizardPanel">
				
					<h3 class="wizardPanelHeading">Summary</h3>
					
					<p class="wizardText">Please review the settings for this page.</p>

					<div id="wizardSummaryLeft">
					
						<span class="wizardSummaryLabel">Page Parent</span>
						<span id="spnPageParent" class="formSummaryValue"></span>
						
						<div class="clearWithMargin"></div>
				
						<span class="wizardSummaryLabel">Page Title</span>
						<span id="spnPageTitle" class="formSummaryValue"></span>
						
						<div class="clearWithMargin"></div>
						
						<span class="wizardSummaryLabel">Menu Title</span>
						<span id="spnMenuTitle" class="formSummaryValue"></span>
						
						<div class="clearWithMargin"></div>
						
						<span class="wizardSummaryLabel">Page URL</span>
						<span id="spnPageURL" class="formSummaryValue"></span>
						
						<div class="clearWithMargin"></div>
						
						<span class="wizardSummaryLabel">Page Keywords</span>
						<span id="spnPageKeywords" class="formSummaryValue"></span>
						
						<div class="clearWithMargin"></div>
						
						<span class="wizardSummaryLabel">Page Description</span>
						<span id="spnPageDescription" class="formSummaryValue"></span>
						
						<div class="clearWithMargin"></div>
						
						<span class="wizardSummaryLabel">Show in navigation?</span>
						<span id="spnShowInNavigationYes" class="formSummaryValue">Yes</span>
						<span id="spnShowInNavigationNo" class="formSummaryValue">No</span>
						
						<div class="clearWithMargin"></div>
						
						<span class="wizardSummaryLabel">Show in site map?</span>
						<span id="spnShowInSiteMapYes" class="formSummaryValue">Yes</span>
						<span id="spnShowInSiteMapNo" class="formSummaryValue">No</span>
					
						<!--- Output the modules --->
						<cftry>
							<cfif qryTemplateModules.RecordCount>
							
								<div class="clearWithMargin"></div>
								
								<span class="wizardSummaryLabel">Default Modules</span>
								<p class="formSummaryValue">
									<cfloop query="qryTemplateModules">
										#qryTemplateModules.moduleName#<br />
									</cfloop>
								</p>
							</cfif>
							<cfcatch></cfcatch>
						</cftry>

					</div>
					
					<div id="wizardSummaryRight">
					
						<div id="divSummaryLayout">
							<img id="imgSummaryLayout" />
							<p class="layoutName" id="pSummaryLayoutName"></p>
							<p class="layoutDescription" id="pSummaryLayoutDescription"></p>
						</div>
						
						<div id="divSummaryAccessLevel">
							<img id="imgSummaryAccessLevel" />
							<p class="accessLevelItemName" id="pSummaryAccessLevelItemName"></p>
							<p class="accessLevelItemDescription" id="pSummaryAccessLevelItemDescription"></p>
						</div>
					
					</div>
					
					<span class="formWizardButton WizardBack" id="lnkSummaryBack">Back</span>
					<span class="formWizardButton WizardFinish" id="lnkFinish">Finish</span>
					
					<div class="clear"></div>
	
				</div>
				
				<div id="pnlError" class="wizardPanel">
				
				</div>
								
				<cfif isDefined("Validate") AND Validate.IsValidForm()>
					<script type="text/javascript">
						var showErrorPanel = true;
					</script>
				<cfelse>
					<script type="text/javascript">
						var showErrorPanel = false;
					</script>
				</cfif>
			
			</div>
		
		</form>
	
	</cfoutput>

</cf_AdminMasterPage>