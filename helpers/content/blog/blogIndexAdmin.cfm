<cfparam name="url.fuseaction" default="" />

<!--- Create the object --->
<cfobject component="#PageModule.cfcPath#" name="BlogIndex" />
<cfset BlogIndex.Init(PageModule.PageModuleID) />
<cfset qryBlogs = BlogIndex.GetBlogs() />
<cfset qryBlogEntries = BlogIndex.BlogEntries() />

<cfif IsPostback>

	<cfif url.fuseaction eq "CreateBlogEntry">

		<cfinclude template="blogEntryCreate.cfm" />

	<cfelseif isDefined("url.BlogEntryID")>
	
		<cfinclude template="blogEntryEditor.cfm" />

	<cfelse>

		<cfscript>
		
			BlogIndex.BlogID = form.ddlBlogID;
			BlogIndex.ShowSummary = form.rdoShowSummary;
			
			BlogIndex.Save();
		
		</cfscript>
		
		<p>Your changes have been saved.</p>
		
		<img id="btnClose" src="#Application.URLRoot#admin/images/closeButton.png" alt="Close" title="Close" width="89" border="0" />
	
	</cfif>

<cfelse>

	<!--- If we are creating a new blog, include the editor. --->
	<cfif url.fuseaction eq "CreateBlogEntry">
	
		<cfinclude template="blogEntryCreate.cfm" />

	<cfelseif isDefined("url.BlogEntryID")>
	
		<cfinclude template="blogEntryEditor.cfm" />
	
	<cfelse>

		<cfoutput>
		
			<form method="post" action="adminPageConfigEditor.cfm?pageModuleID=#PageModule.PageModuleID#" name="frmEditBlogIndex" id="frmEditBlogIndex">
		
				<span class="moduleOptionsLabel">Which Blog?</span>
				<select id="ddlBlogID" name="ddlBlogID">
					<cfloop query="qryBlogs">
						<option value="#qryBlogs.blogID#" <cfif BlogIndex.BlogID eq qryBlogs.blogID>selected</cfif>>#qryBlogs.BlogTitle#</option>
					</cfloop>
				</select>
				
				<div class="clearWithMargin"></div>
				
				<span class="moduleOptionsLabel">Show Summaries?</span>
				<div class="divRadioContainer">
					
					<img src="<cfif BlogIndex.ShowSummary>#Application.URLRoot#admin/images/toggleButtonYes.png<cfelse>#Application.URLRoot#admin/images/toggleButtonNo.png</cfif>" width="89" height="30" border="0" id="btnShowSummary" class="btnToggle" hiddenField="rdoShowSummary" />
					
					<cfif BlogIndex.ShowSummary gt 0>
						<input type="hidden" id="rdoShowSummary" name="rdoShowSummary" value="1" />
					<cfelse>
						<input type="hidden" id="rdoShowSummary" name="rdoShowSummary" value="0" />
					</cfif>
					
				</div>
			
				<div class="clearWithMargin">&nbsp;</div>
				
				<img name="btnSave" id="btnSave" src="#Application.URLRoot#admin/images/saveButton.png" border="0" width="89" alt="Save" title="Save" class="imgButton" />
				<img name="btnCancel" id="btnCancel" src="#Application.URLRoot#admin/images/cancelButton.png" border="0" width="89" alt="Cancel" title="Cancel" class="imgButton" />
				
			</form>
				
			<p>
				<a href="adminPageConfigEditor.cfm?pageModuleID=#PageModule.PageModuleID#&fuseaction=CreateBlogEntry" class="lnkCreateNewBlogEntry">Create New Entry</a>
			</p>
		</cfoutput>
		
		<cfif qryBlogEntries.RecordCount>
		
			<cfoutput query="qryBlogEntries">
			
				<h3 class="lnkBlogEntryTitle"><a href="adminPageConfigEditor.cfm?pageModuleID=#PageModule.PageModuleID#&BlogEntryID=#qryBlogEntries.blogEntryID#">#qryBlogEntries.title#</a></h3>
			
				<!--- Get the first paragraph --->
				<cfset abstract = ListGetAt(qryBlogEntries.content, 1, "#chr(13)#") />
				
				<div class="blogAbstract">
					#abstract#
				</div>
			
			</cfoutput>
		
		<cfelse>
		
			<p>This blog has no entries.</p>
		
		</cfif>

	</cfif>
	
</cfif>

<cfoutput>
	<script>
		PageModuleID = #PageModule.PageModuleID#;
	</script>
	<script type="text/javascript" src="#Application.URLRoot#helpers/content/blog/blogIndexAdmin.js"></script>
</cfoutput>