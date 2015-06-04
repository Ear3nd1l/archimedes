<cfcomponent extends="ArchimedesCFC.modules.pageModule" displayname="HTMLContent" hint="CFC for the HTML Content module">

	<cfparam name="THIS.Title" default="#NullString#" type="string" />
	<cfparam name="THIS.Content" default="#NullString#" type="string" />
	
	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and loads the settings.">
		<cfargument name="value" type="numeric" default="#NullInt#" />
		
		<cfset MapData(GetPageModuleByID(Arguments.value)) />

	</cffunction>

	<cffunction name="MapData" access="private" returntype="void" hint="Maps data from a query to the object's properties.">
		<cfargument name="qryData" type="query" required="yes" default="" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.PageID = GetInt(Arguments.qryData.pageID);
				THIS.BucketID = GetInt(Arguments.qryData.bucketID);
				THIS.ModuleName = GetString(Arguments.qryData.ModuleName);
				THIS.ModuleID = GetString(Arguments.qryData.moduleID);
				THIS.ControlPath = GetString(Arguments.qryData.controlPath);
				THIS.cfcPath = GetString(Arguments.qryData.cfcPath);
				THIS.Title = GetString(Arguments.qryData.title);
				THIS.Content = GetString(Arguments.qryData.content);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
				THIS.IsDeleted = GetBool(Arguments.qryData.isDeleted);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetPageModuleByID" access="private" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="mod_htmlContent_GetByPageModuleID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="PageModuleID" value="#Arguments.PageModuleID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryContent" />
		</cfstoredproc>
		
		<cfreturn qryContent />
		
	</cffunction>
	
	<cffunction name="Save" access="public" returntype="void">
	
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
		
			<cfquery datasource="#DSN#" name="qrySaveContent">
				UPDATE
						mod_htmlContent
				SET
						title = '#THIS.Title#',
						content = '#THIS.Content#'
				WHERE
						pageModuleID = #THIS.PageModuleID#
			</cfquery>
		
		</cfif>
	
	</cffunction>

	<cffunction name="CreateDefaultPageModule" access="public" returntype="boolean">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateDefaultPageModule">
				INSERT
						mod_htmlContent
						(
							pageModuleID,
							content
						)
				VALUES
						(
							#Arguments.PageModuleID#,
							''
						)
				SELECT SCOPE_IDENTITY() AS activityID
			</cfquery>
			
			<cfreturn qryCreateDefaultPageModule.RecordCount eq 1 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
	</cffunction>

</cfcomponent>