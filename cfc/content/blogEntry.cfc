<cfcomponent extends="ArchimedesCFC.modules.pageModule">

	<cfparam name="THIS.BlogEntryID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.Title" default="#NullString#" type="string" />
	<cfparam name="THIS.Content" default="#NullString#" type="string" />
	<cfparam name="THIS.AuthorID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.AuthorFirstName" default="#NullString#" type="string" />
	<cfparam name="THIS.AuthorLastName" default="#NullString#" type="string" />
	<cfparam name="THIS.AuthorEmail" default="#NullString#" type="string" />
	<cfparam name="THIS.DateCreated" default="#NullString#" type="string" />
	<cfparam name="THIS.DateModfied" default="#NullString#" type="string" />
	<cfparam name="THIS.BlogDate" default="#NullString#" type="string" />
	<cfparam name="THIS.BlogID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.BlogTitle" default="#NullString#" type="string" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />

	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="PageModuleID" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="BlogEntryID" type="numeric" required="no" default="#NullInt#" />
		
		<cfif Arguments.BlogEntryID gt NullInt>
			<cfset MapData(GetByBlogEntryID(Arguments.BlogEntryID)) />
		<cfelse>
			<cfset MapData(GetByPageModuleID(Arguments.PageModuleID)) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>

				THIS.BlogEntryID = GetInt(Arguments.qryData.blogEntryID);
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.Title = GetString(Arguments.qryData.title);
				THIS.Content = GetString(Arguments.qryData.content);
				THIS.AuthorID = GetInt(Arguments.qryData.authorID);
				//THIS.AuthorFirstName = GetString(Arguments.qryData.authorFirstName);
				//THIS.AuthorLastName = GetString(Arguments.qryData.authorLastName);
				//THIS.AuthorEmail = GetString(Arguments.qryData.authorEmail);
				THIS.DateCreated = GetDate(Arguments.qryData.dateCreated);
				THIS.DateModified = GetDate(Arguments.qryData.dateModified);
				THIS.BlogDate = GetString(Arguments.qryData.blogDate);
				THIS.BlogID = GetInt(Arguments.qryData.blogID);
				THIS.BlogTitle = GetString(Arguments.qryData.blogTitle);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);

			</cfscript>
			
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>
		
	</cffunction>

	<!---
			GetByPageModuleID
					This function gets info for a blog entry by its ID.
	--->
	<cffunction name="GetByPageModuleID" access="public" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<!--- Get the blog entry's info --->
		<cfquery datasource="#DSN#" name="qryGetBlogEntry">
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
						be.blogID,
						b.blogTitle,
						be.isActive
				FROM
						mod_BlogEntry be INNER JOIN
						mod_Blog b ON be.blogID = b.blogID LEFT OUTER JOIN
						pro_Profile a ON be.authorID = a.profileID
				WHERE
						be.pageModuleID = #Arguments.PageModuleID#
		</cfquery>
		
		<cfreturn qryGetBlogEntry />

	</cffunction>

	<!---
			GetByBlogEntryID
					This function gets info for a blog entry by its ID.
	--->
	<cffunction name="GetByBlogEntryID" access="public" returntype="query">
		<cfargument name="BlogEntryID" type="numeric" required="yes" default="#NullInt#" />
		
		<!--- Get the blog entry's info --->
		<cfquery datasource="#DSN#" name="qryGetBlogEntry">
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
						be.blogID,
						b.blogTitle,
						be.isActive
				FROM
						mod_BlogEntry be INNER JOIN
						mod_Blog b ON be.blogID = b.blogID LEFT OUTER JOIN
						pro_Profile a ON be.authorID = a.profileID
				WHERE
						be.blogEntryID = #Arguments.BlogEntryID#
		</cfquery>
		
		<cfreturn qryGetBlogEntry />

	</cffunction>

	<!---
			Save
					This function saves the private variables values to the blog entry, either updating an existing entry, or creating a new one.
	--->
	<cffunction name="Save" access="public" returntype="void">
	
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
		
			<cfif THIS.BlogEntryID gt 0>
			
				<!--- Update the blog --->
				<cfquery datasource="#DSN#" name="qryUpdateBlog">
					UPDATE
							mod_BlogEntry
					SET
							title = '#THIS.Title#',
							content = '#THIS.Content#',
							authorID = #THIS.AuthorID#,
							blogDate = '#THIS.BlogDate#',
							isActive = #BitFormat(THIS.IsActive)#,
							dateModified = getDate()
					WHERE
							blogEntryID = #THIS.BlogEntryID#
				</cfquery>
			
			<cfelse>
			
				<!--- Create a new blog --->
				<cfquery datasource="#DSN#" name="qryCreateBlog">
					INSERT
							mod_BlogEntry
							(
								pageModuleID,
								title,
								content,
								authorID,
								blogDate,
								blogID,
								isActive
							)
					VALUES
							(
								#THIS.PageModuleID#,
								'#THIS.Title#',
								'#THIS.Content#',
								#THIS.AuthorID#,
								'#THIS.BlogDate#',
								#THIS.BlogID#,
								#BitFormat(THIS.IsActive)#
							)
							
					SELECT SCOPE_IDENTITY() AS blogEntryID
				</cfquery>
				
				<!--- return the ID of the new entry --->
				<cfset THIS.BlogEntryID = qryCreateBlog.blogEntryID />
			
			</cfif>
		
		</cfif>
		
	</cffunction>
	
</cfcomponent>