<cfcomponent extends="archimedesCFC.common" displayname="AdminFunctions" hint="Handles uncategorized admin functions">

	<cffunction name="GetDepartmentInfo" access="public" returntype="query">
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="DepartmentID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="IncludeParent" type="boolean" required="no" default="#NullBool#" />
		
		<cfquery datasource="#DSN#" name="qryGetDepartmentInfo">
			SELECT
					departmentID,
					department,
					departmentPath,
					departmentPageID,
					parentID,
					isActive,
					rowguid,
					sortOrder
			FROM
					getDepartments(#Arguments.SiteID#,#Arguments.DepartmentID#,0,#BitFormat(Arguments.IncludeParent)#)
			ORDER BY
					department
		</cfquery>
		
		<cfreturn qryGetDepartmentInfo />
		
	</cffunction>

	<cffunction name="GetProvinces" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetProvinces">
			SELECT
					provinceID,
					name,
					abbreviation,
					countryID
			FROM
					com_Province
			ORDER BY
					name
		</cfquery>
		
		<cfreturn qryGetProvinces />
		
	</cffunction>
	
	<cffunction name="GetRoles" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetRoles">
			SELECT
					roleID,
					roleName,
					roleRanking,
					description
			FROM
					com_Role
			WHERE
					isActive = 1
			ORDER BY
					roleRanking DESC
		</cfquery>
		
		<cfreturn qryGetRoles />
		
	</cffunction>

</cfcomponent>