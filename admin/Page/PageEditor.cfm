<!--- Param the pageID. --->
<cfparam name="url.pageID" default="1" type="numeric" />

<cfset SectionID = 2 />

<!--- Create the Page Object. --->
<cfobject component="archimedesCFC.page" name="Page" />

<!--- The user must have permission to edit pages. --->
<cfset MinimumRank = 4 />
<cfinclude template="#Application.HelperPath#/admin/verifyAccess.cfm" />


<!--- Initialize the page object. --->
<cfset Page.Init(url.pageID) />

<!--- If the page has been submitted, process it. --->
<cfif isPostback>

	<cfobject component="archimedesCFC.validate" name="Validate" />
	
	<!--- Validate the data --->
	<cfscript>
	
		// Trim the form values
		Validate.TrimStruct(form);
		
		// Page Title and Menu Name are the only required fields.
		if(Len(form.txtPageTitle) eq 0) Validate.ErrorMsg('Page Title is required', 'txtPageTitle');
		if(Len(form.txtMenuName) eq 0) Validate.ErrorMsg('Menu Name is required', 'txtMenuName');
	
	</cfscript>
	
	<cfif Validate.IsValidForm()>
	
		<cfscript>
			// Set the properties
			Page.PageTitle = form.txtPageTitle;
			Page.MenuText = form.txtMenuName;
			Page.PageDescription = form.txtaPageDescription;
			Page.PageKeywords = form.txtPageKeywords;
			Page.ShowBreadcrumbs = form.rdoShowBreadcrumbs;
			Page.ShowInSiteMap = form.rdoShowInSiteMap;
			Page.AccessLevelID = form.hdnAccessLevelID;
			Page.ParentID = form.ddlParent;
			
			// Save the page
			Page.Save();
			
			// If the page is marked inactive (because it was just created by the wizard), mark it active so it appears on the site.
			if(Page.isActive eq False) Page.MakePageActive();
		</cfscript>
		
		<cflocation url="#Application.URLRoot#Admin/PageManager.cfm" addtoken="no" />
		
	<cfelse>
	
		<cfscript>
		
			// Set the Page object's properties to the values from the form
			Page.PageTitle = form.txtPageTitle;
			Page.MenuText = form.txtMenuName;
			Page.PageDescription = form.txtaPageDescription;
			Page.PageKeywords = form.txtPageKeywords;
			Page.ShowBreadcrumbs = form.rdoShowBreadcrumbs;
			Page.ShowInSiteMap = form.rdoShowInSiteMap;
		
		</cfscript>
	
	</cfif>

</cfif>

<!--- Get the available modules for the page admin to add to this page. --->
<cfinvoke component="archimedesCFC.modules.module" method="GetModules" returnvariable="qryGetModules">
	<cfinvokeargument name="ShowPageEditorModules" value="1" />
	<cfinvokeargument name="OrderBy" value="mt.FriendlyName" />
</cfinvoke>

<cfscript>

	// Get all the pages for the site to select the parent
	qrySitePages = Page.GetAllPagesForAdmin(Application.SiteID);

	// Get the layouts
	qryLayouts = Application.Site.GetLayouts();
	
	// Get all users who are not admins
	qryAvailableUsers = Session.Profile.GetUsersWithLowerRank(Session.Profile.HighestRank,Application.SiteID);
	
	// Get the page managers
	qryPageManagers = Session.Profile.GetPageAdminUsers(url.pageID,'Page Manager');
	
	// Get the page editors
	qryPageEditors = Session.Profile.GetPageAdminUsers(url.pageID,'Page Editor');
	
	// Combine the two lists
	lstPageUsers = ValueList(qryPageManagers.profileID) & ',' & ValueList(qryPageEditors.profileID);
	
	// Get the access levels.  If the user is the Executive Director, include the special access level.
	if(Session.Profile.HasRole('Executive Director'))
	{
		qryAccessLevels = Page.GetAccessLevels(True);
	}
	else
	{
		qryAccessLevels = Page.GetAccessLevels();
	}

</cfscript>

<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="Page Editor - #Page.PageTitle#" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#" HelperPath="#Application.HelperPath#" CodeBehind="PageEditor.js">

	<!--- If the user has access to this page, show them the options. --->
	<cfif hasAccess>

		<cfoutput>
			<!--- Form to edit basic settings of the page --->
			<form method="post" action="PageEditor.cfm?pageID=#url.pageID#" id="frmEditPage">
		
				
				<!--- Parent level 0 items cannot have this changed. --->
				<cfif Page.ParentID neq 0>
					<div class="divFormRow">
					
						<label for="ddlParent" class="formLabel">Parent:</label>
						<select id="ddlParent" name="ddlParent" class="formSelect">
							<option value="0" selected="selected">None</option>
							<cfloop query="qrySitePages">
								<option value="#qrySitePages.menuItemID#" <cfif Page.ParentID eq qrySitePages.menuItemID>selected="selected"</cfif> />#qrySitePages.PageTitle#</option>
							</cfloop>
						</select>
						
					</div>
				<cfelse>
					<input type="hidden" name="ddlParent" value="#Page.ParentID#" />
				</cfif>
				
				<div class="divFormRow">
				
					<label for="txtPageTitle" class="formLabel">Page Title:</label>
					<input type="text" name="txtPageTitle" id="txtPageTitle" maxlength="100" class="formTextbox" value="#Page.PageTitle#">
					
				</div>
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<div class="divFormRow">
				
					<label for="txtPageName" class="formLabel">Menu Name:</label>
					<input type="text" name="txtMenuName" id="txtMenuName" maxlength="50" class="formTextbox" value="#Page.MenuText#">
				
				</div>
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<div class="divFormRow">
				
					<label for="txtPageKeywords" class="formLabel">Keywords:</label>
					<input type="text" name="txtPageKeywords" id="txtPageKeywords" class="formTextbox" value="#Page.PageKeywords#">
				
				</div>
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<div class="divFormRow">
				
					<label for="txtaPageDescription" class="formLabel">Page Description:</label>
					<textarea name="txtaPageDescription" id="txtaPageDescription" class="formTextarea">#Page.PageDescription#</textarea>
				
				</div>
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<div class="divFormRow">
				
					<label for="rdoShowInMenu" class="formLabel">Show In Navigation?</label>
					<div class="divRadioContainer">
						<img src="<cfif Page.MenuItemID gt 0>#Application.URLRoot#admin/images/toggleButtonYes.png<cfelse>#Application.URLRoot#admin/images/toggleButtonNo.png</cfif>" width="89" height="30" border="0" id="btnShowInMenu" class="btnToggle" hiddenField="rdoShowInMenu" />
						<cfif Page.MenuItemID gt 0>
							<input type="hidden" id="rdoShowInMenu" name="rdoShowInMenu" value="1" />
						<cfelse>
							<input type="hidden" id="rdoShowInMenu" name="rdoShowInMenu" value="0" />
						</cfif>
					</div>
				
				</div>
				
				<input type="hidden" id="rdoShowBreadcrumbs" name="rdoShowBreadcrumbs" value="1" />
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<div class="divFormRow">
				
					<label for="rdoShowInSiteMap" class="formLabel">Show in Site Map?</label>
					<div class="divRadioContainer">
						<img src="<cfif Page.ShowInSiteMap>#Application.URLRoot#admin/images/toggleButtonYes.png<cfelse>#Application.URLRoot#admin/images/toggleButtonNo.png</cfif>" width="89" height="30" border="0" id="btnShowInSiteMap" class="btnToggle" hiddenField="rdoShowInSiteMap" />
						<cfif Page.ShowInSiteMap>
							<input type="hidden" id="rdoShowInSiteMap" name="rdoShowInSiteMap" value="1" />
						<cfelse>
							<input type="hidden" id="rdoShowInSiteMap" name="rdoShowInSiteMap" value="0" />
						</cfif>
					</div>
				
				</div>
				
				<div class="divFormRow">
				
					<label class="formLabel">Page Access Type:</label>
					<div class="divRadioContainer">
						<cfloop query="qryAccessLevels">
							<div class="accessLevelItem <cfif Page.AccessLevelID eq qryAccessLevels.accessLevelID>accessLevelItemSelected</cfif>" id="divAccessLevel#qryAccessLevels.accessLevelID#" accessLevelID="#qryAccessLevels.accessLevelID#">
								<img src="#Application.URLRoot#admin/images/AccessLevels/#qryAccessLevels.icon#" width="100" height="100" border="0" class="imgAccessLevelIcon" />
								<p class="accessLevelItemName">#qryAccessLevels.accessLevel#</p>
								<p class="accessLevelItemDescription">#qryAccessLevels.description#</p>
							</div>
						</cfloop>
					</div>
				
					<input type="hidden" name="hdnAccessLevelID" id="hdnAccessLevelID" value="#Page.AccessLevelID#" />
	
				</div>
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<!--- <div class="divFormRow">
	
					<!--- Need to decide if we will allow the page layout to be changed after the page has been created --->
					<h4>Page Layout</h4>
					<cfloop query="qryLayouts">
						<div class="layoutItem <cfif Page.LayoutID eq qryLayouts.layoutID>layoutItemSelected</cfif>" id="divLayout#qryLayouts.layoutID#" layoutID="#qryLayouts.layoutID#">
							<img src="#Application.URLRoot#admin/images/Layouts/layoutIconLargeLayout#qryLayouts.layoutID#.png" width="100" height="100" border="0" class="imgLayoutIcon" />
							<p class="layoutName">#qryLayouts.name#</p>
							<p class="layoutDescription">#qryLayouts.description#</p>
						</div>
					</cfloop>
	
					<input type="hidden" name="hdnLayoutID" id="hdnLayoutID" value="#Page.LayoutID#" />
				</div> --->
				
				<div class="clearWithMargin">&nbsp;</div>
				
				<img name="btnSavePage" id="btnSavePage" src="#Application.URLRoot#admin/images/saveButton.png" border="0" width="89" alt="Save Page" title="Save Page" class="imgButton" />
				<img name="btnCancel" id="btnCancel" src="#Application.URLRoot#admin/images/cancelButton.png" border="0" width="89" alt="Cancel" title="Cancel" class="imgButton" />
				
				<cfif Page.IsActive eq False>
					<p class="alertCallout">This page is not currently active.  It will be marked active when the 'Save' button is clicked.  Please make sure all the information is correct before saving the page.</p>
				</cfif>
				
			</form>
			
		</cfoutput>
		
		<!--- Set individual page permissions --->
		<h4>Permissions</h4>
		
		<div id="divPermissions">
		
			<div id="divAvailableUsers" class="permissionsBox">
				<cfoutput query="qryAvailableUsers">
					<cfif ListFind(lstPageUsers, qryAvailableUsers.profileID, ',') eq 0>
						<span class="spnAvailableUserItem" id="spnAvailableUserItem#qryAvailableUsers.profileID#" profileID="#qryAvailableUsers.profileID#" lastName="#qryAvailableUsers.lastName#" firstName="#qryAvailableUsers.firstName#">#qryAvailableUsers.lastName#, #qryAvailableUsers.firstName#</span>
					</cfif>
				</cfoutput>			
			</div>
			
			<div id="divPageManagers" class="permissionsBox">
				<cfoutput query="qryPageManagers">
					<span class="spnAssignedUsersItem" id="spnPageManagerItem#qryPageManagers.profileID#" profileID="#qryPageManagers.profileID#" lastName="#qryPageManagers.lastName#" firstName="#qryPageManagers.firstName#">#qryPageManagers.lastName#, #qryPageManagers.firstName#</span>
				</cfoutput>			
			</div>
			
			<div id="divPageEditors" class="permissionsBox">
				<cfoutput query="qryPageEditors">
					<span class="spnAssignedUsersItem" id="spnPageEditorItem#qryPageEditors.profileID#" profileID="#qryPageEditors.profileID#" lastName="#qryPageEditors.lastName#" firstName="#qryPageEditors.firstName#">#qryPageEditors.lastName#, #qryPageEditors.firstName#</span>
				</cfoutput>			
			</div>
		
		</div>
		
		<div class="clear"></div>
		
		<h4>Page Content</h4>
		
		<!--- Show ribbon bar control for all the modules available to be added to this page. --->
		<h6>Available modules</h6>
		
		<div id="divModules">
		
			<!--- Create the headers --->
			<div class="ribbonHeading">
				<cfoutput query="qryGetModules" group="moduleTypeID">
					<span class="ribbonHandle" id="rbnRibbonHandle#qryGetModules.moduleTypeID#" ribbon="rbnRibbon#qryGetModules.moduleTypeID#" scrollbar="rbnScrollbar#qryGetModules.moduleTypeID#"><strong>#FriendlyName#</strong></span>
				</cfoutput>
				<div class="clear"></div>
			</div>
			
			<!--- Create the ribbons --->
			<div class="ribbonBar">
				<cfoutput query="qryGetModules" group="moduleType">
				
					<cfquery dbtype="query" name="qoqGetModuleCount">
						SELECT
								COUNT(moduleID) AS moduleCount
						FROM
								qryGetModules
						WHERE
								moduleTypeID = #qryGetModules.moduleTypeID#
					</cfquery>
				
					<div class="ribbonHolder" id="rbnRibbon#qryGetModules.moduleTypeID#">
						<ul class="ribbon contentScroll">
							<cfoutput>
								<li class="draggableRibbonItem" id="rbnRibbonItem#qryGetModules.moduleID#" moduleID="#qryGetModules.moduleID#" pageModuleID=""><span class="spnName">#moduleName#</span></li>
							</cfoutput>
							<li class="clear"></li>
						</ul>
					</div>
					
					<cfif qoqGetModuleCount.moduleCount gt 8>
						<div id="rbnScrollbar#qryGetModules.moduleTypeID#" class="ribbonScrollbar" ribbon="rbnRibbon#qryGetModules.moduleTypeID#"></div>
					</cfif>
					
				</cfoutput>
			</div>
		
		</div>
		
		<p>
			<span id="spnGetBucket2SortOrder" style="display: none;">The sort order has been updated.  Save changes?</span>
		</p>
		
		<cfset bucketList = "" />
		
		<cfoutput query="Page.PageBuckets">
		
			<!--- Create a list of buckets so we can make them sortable --->
			<cfset bucketList = bucketList & '##ulBucket' & Page.PageBuckets.bucketID & ','/>
			
			<!--- Get the modules for this bucket from the existing query of page modules. --->
			<cfquery dbtype="query" name="qoqBucketModules">
				SELECT
						pageModuleID,
						moduleName,
						controlPath,
						cfcPath
				FROM
						Page.PageModules
				WHERE
						bucketID = #Page.PageBuckets.bucketID#
				ORDER BY
						sortOrder
			</cfquery>
		
			<!--- Create the bucket --->
			<div id="#Page.PageBuckets.divName#" class="pageBucket">
				<ul id="ulBucket#Page.PageBuckets.bucketID#" class="bucketItemList droppable sortable" bucketID="#Page.PageBuckets.bucketID#">
				
					<!--- Loop through the modules and show their icons. --->
					<cfloop query="qoqBucketModules">
					
						<!--- Create module icons and make them draggable and sortable --->
						<li class="draggableBucketItem ui-state-default" id="bucketItem#qoqBucketModules.pageModuleID#" bucketID="#Page.PageBuckets.bucketID#" pageModuleID="#qoqBucketModules.pageModuleID#"><span class="spnName">#qoqBucketModules.moduleName# </span><span class="spnEditModule" pageModuleID="#qoqBucketModules.pageModuleID#">Edit Settings</span> <span class="spnDeleteModule">Delete Module</span><li>
					
					</cfloop>
				
				</ul>
				
			</div>
		
		</cfoutput>
		
		<div class="clear"></div>
		
		<div id="divModuleOptions">
			<iframe id="iModuleOptions" frameborder="0" scrolling="auto" width="830" height="580"></iframe>
		</div>
		
		<cfoutput>
		
			<script type="text/javascript">
			
				// Set local javascript variables
				var defaultRibbonHandle = 'rbnRibbonHandle#qryGetModules.moduleTypeID#'
				var defaultScrollbar = 'rbnScrollbar#qryGetModules.moduleTypeID#';
				var thisPageID = #Page.PageID#;


				<cfif isPostback>
				
					<cfloop list="#Validate.idList#" index="i">
						$('###i#').addClass('validationError');
						$('<span class="validationErrorMarker">Required</span>').insertAfter('###i#');
					</cfloop>
				
				</cfif>
	
			</script>
			
			<script type="text/javascript">
			
				<cfloop query="Page.PageBuckets">
					// Make the list of modules in each bucket sortable
					$('##ulBucket#Page.PageBuckets.bucketID#').sortable({
						cursor: 'pointer',
						opacity: 0.7,
						revert: true,
						scroll: true,
						connectWith: '.sortable'
					});
				</cfloop>
				
			</script>
		
		</cfoutput>
		
		
	<cfelse>
		<h1>Access Denied</h1>	
	</cfif>
	
</cf_AdminMasterPage>