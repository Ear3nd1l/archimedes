<cfcomponent extends="ArchimedesCFC.common">

	<cfparam name="THIS.BlogID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.BlogIndexID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.BlogTitle" default="#NullString#" type="string" />
	<cfparam name="THIS.DepartmentID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.ShowSummary" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfset MapData(GetByPageModuleID(Arguments.value)) />
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.BlogID = GetInt(Arguments.qryData.blogID);
				THIS.BlogIndexID = GetInt(Arguments.qryData.blogIndexID);
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.BlogTitle = GetString(Arguments.qryData.blogTitle);
				THIS.DepartmentID = GetInt(Arguments.qryData.departmentID);
				THIS.ShowSummary = GetBool(Arguments.qryData.showSummary);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>
		
	</cffunction>

	<cffunction name="GetByPageModuleID" access="public" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetByBlogID">
			SELECT
					b.blogID,
					bi.blogIndexID,
					bi.pageModuleID,
					b.blogTitle,
					b.departmentID,
					bi.showSummary,
					bi.isActive
			FROM
					mod_Blog b INNER JOIN
					mod_BlogIndex bi ON b.blogID = bi.blogID
			WHERE
					bi.pageModuleID = #Arguments.PageModuleID#
		</cfquery>
		
		<cfreturn qryGetByBlogID />
		
	</cffunction>
	
	<cffunction name="GetByBlogID" access="public" returntype="query">
		<cfargument name="BlogID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetByBlogID">
			SELECT
					b.blogID,
					bi.blogIndexID,
					bi.pageModuleID,
					b.blogTitle,
					b.departmentID,
					bi.showSummary,
					bi.isActive
			FROM
					mod_Blog b INNER JOIN
					mod_BlogIndex bi ON b.blogID = bi.blogID
			WHERE
					b.blogID = #Arguments.BlogID#
		</cfquery>
		
		<cfreturn qryGetByBlogID />
		
	</cffunction>

	<cffunction name="BlogEntries" access="public" returntype="query">
		<cfargument name="GetInactives" type="boolean" required="no" default="#NullBool#" />
	
		<cfquery datasource="#DSN#" name="qryBlogEntries">
			SELECT
					be.blogEntryID,
					be.pageModuleID,
					be.title,
					be.content,
					be.authorID,
					a.firstName,
					a.lastName,
					be.dateCreated,
					be.dateModified,
					be.blogDate,
					be.isActive,
					pr.redirectPath
			FROM
					mod_BlogEntry be LEFT OUTER JOIN
					pro_Profile a ON be.authorID = a.profileID INNER JOIN
					page_PageModule pm ON be.pageModuleID = pm.pageModuleID INNER JOIN
					page_Page p ON pm.pageID = p.pageID INNER JOIN
					page_PageRedirect pr ON p.pageID = pr.pageID
			WHERE
					be.blogID = #THIS.BlogID#
					<cfif Arguments.GetInactives eq NullBool>
						AND be.isActive = 1
					</cfif>
			ORDER BY
					be.blogDate DESC,
					be.dateCreated DESC
		</cfquery>
		
		<cfreturn qryBlogEntries />
	
	</cffunction>

	<cffunction name="Save" access="public" returntype="void">
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
		
			<cfif THIS.BlogIndexID gt NullInt>
			
				<!--- Update the blog --->
				<cfquery datasource="#DSN#" name="qryUpdateBlogIndex">
					UPDATE
							mod_BlogIndex
					SET
							showSummary = #BitFormat(THIS.ShowSummary)#,
							isActive = #BitFormat(THIS.IsActive)#
					WHERE
							blogIndexID = #THIS.BlogIndexID#
				</cfquery>
			
			<cfelse>
			
				<!--- Create a new blog --->
				<cfquery datasource="#DSN#" name="qryCreateBlogIndex">
					INSERT
							mod_BlogIndex
							(
								pageModuleID,
								blogID,
								showSummary,
								isActive
							)
					VALUES
							(
								#THIS.PageModuleID#,
								#THIS.BlogID#,
								#BitFormat(THIS.ShowSummary)#,
								#BitFormat(THIS.IsActive)#
							)
							
					SELECT SCOPE_IDENTITY() AS blogIndexID
				</cfquery>
				
				<cfset THIS.BlogIndexID = qryCreateBlogIndex.blogIndexID />
			
			</cfif>
		
		</cfif>
		
	</cffunction>

	<cffunction name="CreateDefaultPageModule" access="public" returntype="boolean">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateDefaultPageModule">
				INSERT
						mod_BlogIndex
						(
							pageModuleID,
							blogID,
							showSummary
						)
				VALUES
						(
							#Arguments.PageModuleID#,
							0,
							0
						)
				SELECT SCOPE_IDENTITY() AS blogIndexID
			</cfquery>
			
			<cfreturn qryCreateDefaultPageModule.RecordCount eq 1 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
		
	</cffunction>
	
	<cffunction name="GetBlogs" access="public" returntype="query">
		<cfargument name="DepartmentID" type="numeric" required="no" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetBlogs">
			SELECT
					blogID,
					blogTitle
			FROM
					mod_Blog
			WHERE
					1 = 1
					<cfif Arguments.DepartmentID gt NullInt>
						AND departmentID = #Arguments.DepartmentID#
					</cfif>
			ORDER BY
					blogTitle
		</cfquery>
		
		<cfreturn qryGetBlogs />
				
	</cffunction>

</cfcomponent>