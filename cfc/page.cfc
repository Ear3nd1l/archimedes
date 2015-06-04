<cfcomponent extends="archimedesCFC.common" displayname="Page" hint="CFC for pages" output="no">
	
	<cfparam name="THIS.PageID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageTitle" default="#NullString#" type="string" />
	<cfparam name="THIS.RedirectPath" default="#NullString#" type="string" />
	<cfparam name="THIS.ShowInNavigation" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.ShowBreadcrumbs" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.LayoutID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.ShowInSiteMap" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.RowGuid" default="#NullGuid#" type="guid" />
	<cfparam name="THIS.PageKeywords" default="#NullString#" type="string" />
	<cfparam name="THIS.PageDescription" default="#NullString#" type="string" />
	<cfparam name="THIS.DepartmentID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.AccessLevelID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.IsDeleted" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.PageBuckets" default="#GetPageBuckets()#" type="query" />
	<cfparam name="THIS.PageModules" default="#GetPageModules()#" type="query" />
	<cfparam name="THIS.MenuText" default="#NullString#" type="string" />
	<cfparam name="THIS.MenuItemID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.ParentID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.SiteID" default="#NullInt#" type="numeric" />
	
	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and loads the settings.">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />

		<cfscript>
			MapData(GetPageByID(Arguments.value));
			THIS.PageBuckets = GetPageBuckets();
			THIS.PageModules = GetPageModules();
		</cfscript>

	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void" hint="Maps data from a query to the object's properties.">
		<cfargument name="qryData" type="query" required="yes" default="" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.PageID = GetInt(Arguments.qryData.pageID);
				THIS.PageTitle = GetString(Arguments.qryData.pageTitle);
				THIS.ShowInNavigation = GetInt(Arguments.qryData.showInNavigation);
				THIS.ShowBreadcrumbs = GetBool(Arguments.qryData.showBreadcrumbs);
				THIS.LayoutID = GetInt(Arguments.qryData.layoutID);
				THIS.ShowInSiteMap = GetBool(Arguments.qryData.showInSiteMap);
				THIS.RowGuid = GetGuid(Arguments.qryData.rowguid);
				THIS.PageKeywords = GetString(Arguments.qryData.pageKeywords);
				THIS.PageDescription = GetString(Arguments.qryData.pageDescription);
				THIS.DepartmentID = GetInt(Arguments.qryData.departmentID);
				THIS.AccessLevelID = GetInt(Arguments.qryData.accessLevelID);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
				THIS.IsDeleted = GetBool(Arguments.qryData.isDeleted);
				THIS.MenuText = GetString(Arguments.qryData.menuText);
				THIS.MenuItemID = GetInt(Arguments.qryData.menuItemID);
				THIS.ParentID = GetInt(Arguments.qryData.parentID);
				THIS.SiteID = GetInt(Arguments.qryData.siteID);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetPageByID" access="private" returntype="query">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="page_Page_GetByID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetPageData" />
		</cfstoredproc>
		
		<cfreturn qryGetPageData />
		
	</cffunction>
	
	<cffunction name="GetPageBuckets" access="public" returntype="query" hint="Returns a query object of all the buckets for a page.">
	
		<cfstoredproc datasource="#DSN#" procedure="page_Bucket_GetByLayoutID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="LayoutID" value="#THIS.LayoutID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryPageBuckets" />
		</cfstoredproc>
		
		<cfreturn qryPageBuckets />
	
	</cffunction>
	
	<cffunction name="GetPageModules" access="public" returntype="query" hint="Returns a query object of all the modules for a page.">
	
		<cfstoredproc datasource="#DSN#" procedure="page_PageModule_GetByPageID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="PageID" value="#THIS.PageID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryPageModules" />
		</cfstoredproc>
		
		<cfreturn qryPageModules />
		
	</cffunction>
	
	<!---------------------------------------------------------------------------------------
	
		ADMIN FUNCTIONS
	
	---------------------------------------------------------------------------------------->
	
	<cffunction name="Save" access="public" returntype="void" hint="">
		
		<!--- Sanitize the string properties --->
		<cfset Sanitize() />
	
		<!--- TODO: Move this to a stored proc --->
		<cfif THIS.pageID gt NullInt>
			
			<cfquery datasource="#DSN#" name="qrySavePage">
				UPDATE
						page_Page
				SET
						pageTitle = '#THIS.PageTitle#',
						pageDescription = '#THIS.PageDescription#',
						pageKeywords = '#THIS.PageKeywords#',
						showInNavigation = #BitFormat(THIS.ShowInNavigation)#,
						showBreadcrumbs = #BitFormat(THIS.ShowBreadcrumbs)#,
						showInSiteMap = #BitFormat(THIS.ShowInSiteMap)#,
						isActive = #BitFormat(THIS.IsActive)#,
						accessLevelID = #THIS.AccessLevelID#
				WHERE
						pageID = #THIS.PageID#
						
						
				UPDATE
						site_MenuItem
				SET
						menuText = '#THIS.MenuText#'
				WHERE
						pageID = #THIS.PageID#
			</cfquery>
			
			<cfif THIS.ParentID gt 0>
			
				<cfquery datasource="#DSN#" name="qrySavePage">
					UPDATE
							site_MenuItem
					SET
							parentID = #THIS.ParentID#
					WHERE
							pageID = #THIS.PageID#
				</cfquery>

			</cfif>
			
		<cfelse>
		
			<cfquery datasource="#DSN#" name="qrySavePage">
				INSERT
						page_Page
						(
							pageTitle,
							departmentID,
							pageKeywords,
							pageDescription,
							showInNavigation,
							showBreadcrumbs,
							showInSiteMap,
							layoutID,
							accessLevelID,
							isActive,
							siteID
						)
				VALUES
						(
							'#THIS.PageTitle#',
							#THIS.DepartmentID#,
							'#THIS.PageKeywords#',
							'#THIS.PageDescription#',
							#BitFormat(THIS.ShowInNavigation)#,
							#BitFormat(THIS.ShowBreadcrumbs)#,
							#BitFormat(THIS.ShowInSiteMap)#,
							#THIS.LayoutID#,
							#THIS.AccessLevelID#,
							#BitFormat(THIS.IsActive)#,
							#THIS.SiteID#
						)
			
				SELECT SCOPE_IDENTITY() AS pageID
				
			</cfquery>
			
			<cfset THIS.PageID = qrySavePage.pageID />
			
			<!--- Create the redirect path --->
			<cfquery datasource="#dsn#" name="qryCreateRedirect">
				INSERT
						page_PageRedirect
						(
							pageID,
							siteID,
							redirectPath,
							isActive
						)
				VALUES
						(
							#THIS.PageID#,
							#THIS.SiteID#,
							'#THIS.RedirectPath#',
							1
						)
				
				SELECT MAX(ISNULL(sortOrder, 0)) + 1 AS MaxSortOrder FROM site_MenuItem WHERE parentID = #THIS.ParentID#
			</cfquery>
			
			<!--- Create the Menu item --->
			<cfquery datasource="#DSN#" name="qryCreateMenuItem">
				INSERT
						site_MenuItem
						(
							siteID,
							pageID,
							parentID,
							sortOrder,
							menuText,
							isActive
						)
				VALUES
						(
							#THIS.SiteID#,
							#THIS.PageID#,
							#THIS.ParentID#,
							<cfif isDefined("qryCreateRedirect") AND qryCreateRedirect.MaxSortOrder neq "">#qryCreateRedirect.MaxSortOrder#<cfelse>1</cfif>,
							'#THIS.MenuText#',
							0
						)
			</cfquery>
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetMenuPagesForAdmin" access="public" returntype="query" hint="Returns a query object of pages shown in the site menu for the Page Admin.">
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Depth" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="ParentID" type="numeric" required="no" default="0" /> <!--- This defaults to zero because the parentID of all base level pages is zero. --->
		<cfargument name="IncludeParent" type="boolean" required="no" default="#NullBool#" />
		
		<cfquery datasource="#DSN#" name="qryGetPages">
			SELECT
					menuItemID,
					pageID,
					menuText,
					redirectPath,
					parentID,
					depth,
					sortOrder,
					pageIsActive,
					menuIsActive,
					pageDescription,
					layoutID
			FROM
					getMenuItems(#Arguments.SiteID#,#Arguments.ParentID#,0,#BitFormat(Arguments.IncludeParent)#)
			WHERE
					1 = 1
					<cfif Depth gt NullInt>
						AND depth <= #Depth#
					</cfif>
		</cfquery>
		
		<cfreturn qryGetPages />
	
	</cffunction>
	
	<cffunction name="GetNonMenuPagesForAdmin" access="public" returntype="query" hint="Returns a query object of pages that are not shown in the site menu for the Page Admin.">
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />

		<cfquery datasource="#DSN#"	 name="qryGetPages">
			SELECT
					p.pageID,
					p.pageTitle,
					p.isActive,
					p.pageDescription,
					p.layoutID
			FROM
					page_Page p LEFT OUTER JOIN
					site_MenuItem mi ON p.pageID = mi.pageID
			WHERE
					mi.pageID IS NULL
					AND p.siteID = #Arguments.SiteID#
		</cfquery>
		
		<cfreturn qryGetPages />
		
	</cffunction>
	
	<cffunction name="GetAllPagesForAdmin" access="public" returntype="query" hint="Returns a query object of pages that are not shown in the site menu for the Page Admin.">
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />

		<cfquery datasource="#DSN#"	 name="qryGetPages">
			SELECT
					p.pageID,
					p.pageTitle,
					p.isActive,
					p.pageDescription,
					mi.menuItemID
			FROM
					page_Page p LEFT OUTER JOIN
					site_MenuItem mi ON p.pageID = mi.pageID
			WHERE
					p.siteID = #Arguments.SiteID#
			ORDER BY
					p.pageTitle
		</cfquery>
		
		<cfreturn qryGetPages />
		
	</cffunction>
	
	<cffunction name="GetUserPages" access="public" returntype="query" hint="Gets the pages a non-Admin user has access to.">
		<cfargument name="ProfileID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />

		<!--- Create the user object --->
		<cfobject component="ArchimedesCFC.user.archon" name="User" />
		<cfset User.GetByProfileID(Arguments.ProfileID) />
		
		<!--- Get the pages the user has been granted access to. --->
		<cfquery datasource="#DSN#" name="qryGetUserPages">
			SELECT
					mi.menuItemID,
					mi.pageID,
					mi.menuText,
					mi.redirectPath,
					mi.parentID,
					mi.depth,
					mi.sortOrder,
					mi.isActive,
					mi.pageDescription,
					mi.layoutID
			FROM
					getMenuItems(#Arguments.SiteID#,0,0) mi INNER JOIN
					page_PageAdmin pa ON mi.pageID = pa.pageID
			WHERE
					pa.profileID = #User.ProfileID#
		</cfquery>
		
		<!--- If the user is a Department Content Manager, get all the pages for that department. --->
		<cfif User.HasRole('Department Content Manager')>
			<cfquery datasource="#DSN#" name="qryGetDepartmentPages">
				SELECT
						mi.menuItemID,
						mi.pageID,
						mi.menuText,
						mi.redirectPath,
						mi.parentID,
						mi.depth,
						mi.sortOrder,
						mi.isActive,
						mi.pageDescription,
						mi.layoutID
				FROM
						getMenuItems(#Arguments.SiteID#,0,0) mi INNER JOIN
						page_Page p ON mi.pageID = p.pageID
				WHERE
						p.departmentID = #User.DepartmentID#
			</cfquery>
			
			<!--- Merge the queries --->
			<cfquery dbtype="query" name="qryGetAllUserPages">
				SELECT
						*
				FROM
						qryGetUserPages
				
				UNION
				
				SELECT
						*
				FROM
						qryGetDepartmentPages
				ORDER BY
						menuText
			</cfquery>
		</cfif>
		
		<!--- If we merged queries, return the combined object. --->
		<cfif isDefined("qryGetAllUserPages")>
			<cfreturn qryGetAllUserPages />
		<cfelse>
			<cfreturn qryGetUserPages />
		</cfif>
		
	</cffunction>

	<cffunction name="GetPageMenuName" access="public" returntype="Query">
		<cfargument name="PageID" type="Numeric" required="no" default="#NullInt#" />
		
		<!--- If the pageID variable was not passed in, use the local value. --->
		<cfif arguments.pageID lt 0><cfset arguments.pageID = THIS.PageID /></cfif>
		
		<cfquery datasource="#DSN#" name="qryGetPageMenuNames">
			SELECT
					menuItemID,
					parentID,
					menuText
			FROM
					site_MenuItem
			WHERE
					pageID = #Arguments.PageID#
					AND isActive = 1
					AND isDeleted = 0
			ORDER BY
					menuText
		</cfquery>
		
		<cfreturn qryGetPageMenuNames />
		
	</cffunction>
	
	<cffunction name="GetAccessLevels" access="public" returntype="query">
		<cfargument name="GetInactives" type="boolean" required="no" default="False" />
		
		<cfquery datasource="#DSN#" name="qryGetAccessLevels">
			SELECT
					accessLevelID,
					accessLevel,
					description,
					icon
			FROM
					page_AccessLevel
			WHERE
					1 = 1
					<cfif Arguments.GetInactives eq "False">
						AND isActive = 1
					</cfif>
		</cfquery>
		
		<cfreturn qryGetAccessLevels />
		
	</cffunction>
	
	<cffunction name="IsNewRedirectPath" access="remote" returntype="boolean" returnformat="JSON">
		<cfargument name="RedirectPath" type="string" required="yes" default="#NullString#" />
		
		<cfquery datasource="#DSN#" name="qryIsNewRedirectPath">
			SELECT
					pageRedirectID
			FROM
					page_PageRedirect
			WHERE
					redirectPath = '#Arguments.RedirectPath#'
		</cfquery>
		
		<cfif qryIsNewRedirectPath.RecordCount>
			<cfreturn False />
		<cfelse>
			<cfreturn True />
		</cfif>
	
	</cffunction>
	
	<cffunction name="MakePageActive" access="public" returntype="void" hint="Makes an inactive page active">
		
		<cfquery datasource="#DSN#" name="qryMakePageActive">
			UPDATE
					page_Page
			SET
					isActive = 1
			WHERE
					pageID = #THIS.PageID#
			
			UPDATE
					site_MenuItem
			SET
					isActive = 1
			WHERE
					pageID = #THIS.PageID#
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetBreadcrumbPath" access="public" returntype="query">
	
		<cfquery datasource="#DSN#" name="qryGetBreadcrumbPath">
			SELECT
					menuItemID,
					pageTitle,
					redirectPath
			FROM
					dbo.getBreadcrumbPath(#THIS.ParentID#)
			ORDER BY
					recursiveID DESC
		</cfquery>

		<cfreturn qryGetBreadcrumbPath />
	
	</cffunction>
	
</cfcomponent>