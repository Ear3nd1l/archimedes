<cfcomponent extends="ArchimedesCFC.modules.pageModule">

	<cfparam name="THIS.QuickLinksID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.Title" default="#NullString#" type="string" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.QuickLinksItems" type="query" default="#GetItems()#" />
	
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			MapData(GetByPageModuleID(Arguments.Value));
			GetItems();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.QuickLinksID = GetInt(Arguments.qryData.quickLinksID);
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.Title = GetString(Arguments.qryData.title);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
			
			</cfscript>
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetByPageModuleID" access="public" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetByPageModuleID">
			SELECT
					QuickLinksID,
					pageModuleID,
					title,
					isActive
			FROM
					mod_QuickLinks
			WHERE
					pageModuleID = #Arguments.PageModuleID#
		</cfquery>
		
		<cfreturn qryGetByPageModuleID />
	
	</cffunction>
	
	<cffunction name="GetItems" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetItems">
			SELECT
					l.linkID,
					l.linkText,
					l.url,
					l.isNewWindow
			FROM
					mod_QuickLinksLink l 
			WHERE
					l.isDeleted = 0
					AND l.quickLinksID = #THIS.QuickLinksID#
			ORDER BY
					l.sortOrder
		</cfquery>
		
		<cfset THIS.QuickLinksItems = qryGetItems />
		
		<cfreturn qryGetItems />
		
	</cffunction>

	<cffunction name="CreateDefaultPageModule" access="public" returntype="boolean">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateDefaultPageModule">
				INSERT
						mod_QuickLinks
						(
							pageModuleID,
							title
						)
				VALUES
						(
							#Arguments.PageModuleID#,
							'Related Links'
						)
				SELECT SCOPE_IDENTITY() AS quickLinksID
			</cfquery>
			
			<cfreturn qryCreateDefaultPageModule.RecordCount eq 1 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
		
	</cffunction>
	
	<cffunction name="CreateLink" access="public" returntype="boolean">
		<cfargument name="QuickLinksID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="LinkText" type="string" required="yes" default="#NullString#" />
		<cfargument name="URL" type="string" required="yes" default="#NullString#" />
		<cfargument name="IsNewWindow" type="boolean" required="yes" default="#NullBool#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryCreateLink">
					IF NOT EXISTS
					(
						SELECT
								linkID
						FROM
								mod_QuickLinksLink
						WHERE
								quickLinksID = #Arguments.QuickLinksID#
								AND linkText = '#Arguments.LinkText#'
								AND url = '#Arguments.URL#'
					)
					BEGIN
					
						DECLARE @SortOrder int;
						SELECT @SortOrder = ISNULL(MAX(sortOrder), 0) + 100 FROM mod_QuickLinksLink WHERE quickLinksID = #Arguments.QuickLinksID#;
					
						INSERT
								mod_QuickLinksLink
								(
									quickLinksID,
									linkText,
									URL,
									isNewWindow,
									sortOrder
								)
						VALUES
								(
									#Arguments.QuickLinksID#,
									'#Arguments.LinkText#',
									'#Arguments.URL#',
									#BitFormat(Arguments.IsNewWindow)#,
									@SortOrder
								)
					END
				</cfquery>
				
				<cfreturn True />
			
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="EditLink" access="public" returntype="boolean">
		<cfargument name="LinkID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="LinkText" type="string" required="yes" default="#NullString#" />
		<cfargument name="URL" type="string" required="yes" default="#NullString#" />
		<cfargument name="IsNewWindow" type="boolean" required="yes" default="#NullBool#" />

		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryEditLink">
					UPDATE
							mod_QuickLinksLink
					SET
							linkText = '#Arguments.LinkText#',
							URL = '#Arguments.URL#',
							isNewWindow = #BitFormat(Arguments.IsNewWindow)#
					WHERE
							linkID = #Arguments.LinkID#
				</cfquery>
				
				<cfreturn True />
			
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>

	</cffunction>
	
	<cffunction name="DeleteLink" access="public" returntype="boolean">
		<cfargument name="LinkID" type="numeric" required="yes" default="#NullInt#" />

		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryDeleteLink">
					UPDATE
							mod_QuickLinksLink
					SET
							isDeleted = 1
					WHERE
							linkID = #Arguments.LinkID#
				</cfquery>
				
				<cfreturn True />
			
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>

	</cffunction>
	
	<cffunction name="UpdateSortOrder" access="public" returntype="any">
		<cfargument name="OrderList" type="string" required="yes" default="#NullString#" />

		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<cftry>
			
				<!--- Create the validator object so we can strip the string to numeric numbers only --->
				<cfobject component="ArchimedesCFC.validate" name="Validate" />
				
				<cfset counter = 10 />
				
				<!--- Loop through the order list --->
				<cfloop list="#Arguments.orderList#" index="i">
				
					<!--- Get the linkID. --->
					<cfset linkID = Validate.StripToNumeric(i) />
	
					<!--- Update the order. --->
					<cfquery datasource="#DSN#" name="qryUpdateSortOrder">
						UPDATE
								mod_QuickLinksLink
						SET
								sortOrder = #counter#
						WHERE
								linkID = #linkID#
					</cfquery>
					
					<cfset counter = counter + 10 />
	
				</cfloop>
	
				<cfreturn True />
					
				<cfcatch><cfreturn cfcatch.Message /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
			
		</cfif>

	</cffunction>
	
	<cffunction name="ajaxCreateLink" access="remote" returntype="any" returnformat="json">
		<cfargument name="QuickLinksID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="LinkText" type="string" required="yes" default="#NullString#" />
		<cfargument name="URL" type="string" required="yes" default="#NullString#" />
		<cfargument name="IsNewWindow" type="boolean" required="yes" default="#NullBool#" />
		
		<cfreturn CreateLink(Arguments.QuickLinksID, Arguments.LinkText, Arguments.URL, Arguments.IsNewWindow) />
	
	</cffunction>
	
	<cffunction name="ajaxEditLink" access="remote" returntype="any" returnformat="json">
		<cfargument name="LinkID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="LinkText" type="string" required="yes" default="#NullString#" />
		<cfargument name="URL" type="string" required="yes" default="#NullString#" />
		<cfargument name="IsNewWindow" type="boolean" required="yes" default="#NullBool#" />
	
		<cfreturn EditLink(Arguments.LinkID, Arguments.LinkText, Arguments.URL, Arguments.IsNewWindow) />

	</cffunction>
	
	<cffunction name="ajaxDeleteLink" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="LinkID" type="numeric" required="yes" default="#NullInt#" />
	
		<cfreturn DeleteLink(Arguments.LinkID) />
	
	</cffunction>

	<cffunction name="ajaxUpdateSortOrder" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="OrderList" type="string" required="yes" default="#NullString#" />

		<cfreturn UpdateSortOrder(Arguments.OrderList) />

	</cffunction>
	
</cfcomponent>