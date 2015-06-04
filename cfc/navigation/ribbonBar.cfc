<cfcomponent extends="archimedesCFC.common" displayname="RibbonBar" hint="CFC for the Ribbon Bar Navigation module">

	<cffunction name="GetParentRibbon" access="public" returntype="numeric">
		<cfargument name="ParentID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetBreadcrumbPath">
			SELECT
					TOP 1
					menuItemID
			FROM
					dbo.getBreadcrumbPath(#Arguments.ParentID#)
			ORDER BY
					recursiveID DESC
		</cfquery>
		
		<cfif qryGetBreadcrumbPath.RecordCount>
			<cfreturn qryGetBreadcrumbPath.menuItemID />
		<cfelse>
			<cfreturn 1 />
		</cfif>
		
	</cffunction>

</cfcomponent>