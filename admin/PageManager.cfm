<cfset MinimumRank = 4 />
<cfinclude template="#Application.HelperPath#/admin/verifyAccess.cfm" />

<cfset SectionID = 2 />

<cfobject component="ArchimedesCFC.Page" name="Page" />

<cfif IsAdmin>
	<cfset qryMenuPages = Page.GetMenuPagesForAdmin(Application.SiteID) />
<cfelse>
	<cfset qryMenuPages = Page.GetUserPages(User.ProfileID, Application.SiteID) />
</cfif>

<!--- <cfset qryNonMenuPages = Page.GetNonMenuPagesForAdmin(Application.SiteID) /> --->

<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="Page Manager" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#" HelperPath="#Application.HelperPath#" CodeBehind="PageManager.js">

<cfoutput>

	<cfif hasAccess>

			<div style="position: absolute; top: -45px; right: 13px; z-index: 120;"><a href="#Application.URLRoot#admin/page/CreatePage.cfm" style="color: ##fff;">Create a new page</a></div>
			
			<div id="admPagePanel" class="panel rounded shadow">
			
				<h3 class="panelHeading roundedSmall shadow">Page Manager</h3>
			
				<cfloop query="qryMenuPages">
					<div id="divPage#qryMenuPages.pageID#" class="panelItem page#qryMenuPages.depth#Item roundedSmall shadow" pageID="#qryMenuPages.pageID#">
						 <img src="#Application.URLRoot#admin/images/Layouts/layoutIconSmallLayout#qryMenuPages.layoutID#.png" class="pageMenuItemLayout" /> 
						<div class="pageMenuItemText">
							<span class="pageMenuTitle">#qryMenuPages.menuText#</span>
							<span class="pageMenuDescription"><cfif Len(qryMenuPages.pageDescription) gt 0>#Left(qryMenuPages.pageDescription, 50)#<cfelse>No Description</cfif></span>
						</div>
					</div>
				</cfloop>
				
				<div class="clear"><br /></div>
				
			</div>
	<cfelse>
		<h1>Access Denied</h1>	
	</cfif>
	
</cfoutput>
	
</cf_AdminMasterPage>