<cfset BlogEntry = BlogIndex.GetModuleByName("Blog Entry Viewer") />

<cfif isPostback>


	<cfscript>
	
		// Create the object
		Validate = CreateObject("component", "ArchimedesCFC.validate");
		
		// Trim the form fields
		Validate.TrimStruct(form);
		
		if(IsEmpty(form.txtTitle)) Validate.ErrorMsg(Message="Title is required.", FormField="txtTitle");
		if(IsEmpty(form.txtBlogDate)) Validate.ErrorMsg(Message="Blog Date is required.", FormField="txtBlogDate");
		if(NOT IsDate(form.txtBlogDate)) Validate.ErrorMsg(Message="Blog Date is invalid.", FormField="txtBlogDate");
		if(IsEmpty(form.txtaContent)) Validate.ErrorMsg(Message="Content is required.", FormField="txtaContent");
		
		/* 
			Save the form values to the object.
			If there are validation errors, this will preserve the entered content for the form.
		*/
		BlogEntry.Title = form.txtTitle;
		BlogEntry.BlogDate = form.txtBlogDate;
		BlogEntry.Content = form.txtaContent;
		
		// If the form is valid, save the object.
		if(Validate.IsValidForm())
		{
		
			// Create the page for this entry.
			Page = CreateObject("component", "ArchimedesCFC.Page");
			Page.PageTitle = BlogEntry.Title;
			Page.MenuText = BlogEntry.Title;
			Page.DepartmentID = BlogIndex.DepartmentID;
			Page.ShowInNavigation = False;
			Page.ShowInSiteMap = False;
			Page.ShowBreadcrumbs = True;
			Page.AccessLevelID = 1; // TODO: Get the access level by name instead of ID.
			Page.LayoutID = 1; // TODO: Use layout manager to get the layout by name instead of ID.
			Page.SiteID = Application.SiteID;
			Page.ParentID = PageModule.PageID;
			Page.IsActive = True;
			
			// Get the department info so we can get the path for the page URL.
			qryDepartmentInfo = AdminFunctions.GetDepartmentInfo(Application.SiteID,BlogIndex.DepartmentID,True);
			pageBasePath = qryDepartmentInfo.departmentPath;
			Page.RedirectPath = pageBasePath & "Blog/" & StripToAlphaNumeric(BlogEntry.Title) & ".cfm";
			
			Page.Save();
			
			// Add the blog index module to the page.
			NewBlogIndex = BlogEntry.GetModuleByName("Blog Index");
			NewBlogIndex.PageModuleID = PageModule.AddModuleToBucket(17, 1, Page.PageID);
			NewBlogIndex.BlogID = BlogIndex.BlogID;
			NewBlogIndex.ShowSummary = False;
			NewBlogIndex.Save();
			
			// Add the blog entry viewer to the page.
			BlogEntry.PageModuleID = PageModule.AddModuleToBucket(16, 2, Page.PageID);
			BlogEntry.BlogID = BlogIndex.BlogID;
			BlogEntry.IsActive = True;
			BlogEntry.AuthorID = Session.Profile.ProfileID;
			
			// Save the entry.
			BlogEntry.Save();/**/
		}
	
	</cfscript>
	
</cfif>

<cfoutput>

	<cfif isDefined("Validate")>
	
		<cfif Validate.IsValidForm()>
	
			<p>Your blog entry has been saved. <a href="adminPageConfigEditor.cfm?pageModuleID=#PageModule.PageModuleID#">Return to the blog index</a>.</p>
		
		<cfelse>
		
			<p>#Validate.GetErrors()#</p>
		
		</cfif>
	
	</cfif>

	<cfform action="#cgi.SCRIPT_NAME#?pageModuleID=#PageModule.PageModuleID#&fuseaction=CreateBlogEntry" method="post" name="frmCreateBlogEntry" id="frmCreateBlogEntry">
	
		<span class="moduleOptionsLabel">Title:</span>
		<input type="text" id="txtTitle" name="txtTitle" style="width: 800px;" maxlength="100" value="#BlogEntry.Title#" />
		<br />
		<span class="moduleOptionsLabel">Blog Date:</span>
		<input type="text" id="txtBlogDate" name="txtBlogDate"  style="width: 100px;" maxlength="100" value="#BlogEntry.BlogDate#" /> MM/DD/YYYY
		<br />
		<cftextarea height="325" width="800" id="txtaContent" name="txtaContent" richtext="true" toolbar="ArchimedesBasic"><cfoutput>#BlogEntry.Content#</cfoutput></cftextarea>
		<br />
		<img name="btnSaveNewEntry" id="btnSaveNewEntry" src="#Application.URLRoot#admin/images/saveButton.png" border="0" width="89" alt="Save" title="Save" class="imgButton" />
		<img name="btnCancelCreate" id="btnCancelCreate" src="#Application.URLRoot#admin/images/cancelButton.png" border="0" width="89" alt="Cancel" title="Cancel" class="imgButton" />
	
	</cfform>

</cfoutput>
