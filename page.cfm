<cfsilent>
	
	<!--- Param the pageID. --->
	<cfparam name="pageID" default="1" type="numeric" />
	
	<!--- Create the Page Object. --->
	<cfobject component="cfc.page" name="Page" />
	
	<!--- Initialize the page object. --->
	<cfset Page.Init(pageID) />
	
	<cfinclude template="/helpers/Security/Permissions/permissionsInspector.cfm" />
	
	<cfif HasAccess eq false>
		<cflocation url="/404.cfm" addtoken="no" />
	</cfif>
	
</cfsilent>

<cfoutput>

	<!--- Load the master page. --->
	<cf_MasterPage PageTitle="#Page.PageTitle#" SiteKeywords="#Page.PageKeywords#" PageParentID="#Page.ParentID#">
	
		<cfif Page.ShowBreadcrumbs>
			<cfinclude template="/helpers/Navigation/breadcrumbs.cfm" />
		</cfif>
	
		<!--- Create the content. --->
		<cfinclude template="#Application.HelperPath#/content/createContent.cfm" />
		
	<!--- Close the master page. --->
	</cf_MasterPage>
	
</cfoutput>