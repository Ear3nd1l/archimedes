<cfcomponent extends="archimedesCFC.common" displayname="Palimpsest" hint="CFC for the Palimpsest URL Rewriter module">

	<cfparam name="THIS.SiteID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageID" default="#NullInt#" type="numeric" />
	
	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and checks for a configured redirect path.">
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="RedirectPath" type="string" required="yes" default="#NullString#" />
		
		<!--- Check the database and see if this is a configured redirect path --->
		<cfstoredproc datasource="#DSN#" procedure="page_PageRedirect_GetPageIDByPath">
			<cfprocparam dbvarname="@RedirectPath" value="#Arguments.RedirectPath#" cfsqltype="cf_sql_varchar" />
			<cfprocparam dbvarname="@SiteID" value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar" />
			<cfprocresult name="qryGetPage" />
		</cfstoredproc>

		<cfif qryGetPage.RecordCount>
			<cfset THIS.SiteID = SiteID />
			<cfset THIS.PageID = qryGetPage.pageID />
		</cfif>

	</cffunction>
	
</cfcomponent>