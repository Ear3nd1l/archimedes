<cfcomponent extends="archimedesCFC.common" displayname="Mantis" hint="CFC for the Mantis Error Handling module">

	<cfparam name="THIS.ModuleID"  default="#NullInt#" type="numeric" />
	<cfparam name="THIS.SearchEngines" default="#QueryNew('searchEngineID,name', 'integer,varchar')#" type="query" />
	<cfparam name="THIS.MantisSettings" default="#StructNew()#" type="struct" />

	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and loads the settings.">
		<cfargument name="value" required="true" type="numeric" default="#NullInt#" />
		
		<cfset THIS.ModuleID = Arguments.value />
		<cfinvoke method="GetSearchEngines" />
		<cfinvoke method="GetMantisSettings" />
		
	</cffunction>
	
	<cffunction name="GetMantisSettings" access="private" hint="Loads the module settings.">
	
		<cfif StructIsEmpty(THIS.MantisSettings)>

			<cfstoredproc datasource="#DSN#" procedure="mod_Module_ModuleSettings_GetByModuleID" cachedwithin="#cachedWithin#">
				<cfprocparam dbvarname="ModuleID" value="#THIS.ModuleID#" cfsqltype="cf_sql_integer" />
				<cfprocresult name="qryModuleSettings" />
			</cfstoredproc>
	
			<!--- Create the struct --->
			<cfscript>
				structTemp = StructNew();
			</cfscript>
			
			<!--- loop through and set the values --->
			<cfloop query="qryModuleSettings">
			
				<cfscript>
					StructInsert(structTemp, Trim(qryModuleSettings.ModuleSetting), Trim(qryModuleSettings.value));
				</cfscript>
				
			</cfloop>
			
			<cfset THIS.MantisSettings = structTemp />
			
		</cfif>
		
		<cfreturn THIS.MantisSettings />

	</cffunction>

	<cffunction name="GetSearchEngines" access="public" returntype="query" hint="Gets the registered search engines from the database.">
	
		<cfif IsQuery(THIS.SearchEngines) eq False>
		
			<cfstoredproc datasource="#DSN#" procedure="mod_MantisSearchEngine_GetSearchEngines" result="qrySearchEngines" cachedwithin="#cachedwithin#" />
			
			<cfset THIS.SearchEngines = qrySearchEngines />
			
		</cfif>
		
		<cfreturn THIS.SearchEngines />
		
	</cffunction>
	
	<cffunction name="IsSearchEngine" access="public" returntype="boolean" hint="Determines whether a user is a search engine spider or not.">
		<cfargument name="userAgent" type="string" required="yes" default="#NullString#" />
		
		<cfset retVal = NullBool />
		
		<cfif IsQuery(THIS.SearchEngines) eq False>
			<cfinvoke method="SearchEngines" />
		</cfif>
		
		<cfloop query="THIS.SearchEngines">
			
			<cfif Arguments.userAgent contains THIS.SearchEngines.name>
				<cfset retVal = True />
			</cfif>
			
		</cfloop>
		
		<cfreturn retVal />
		
	</cffunction>
	
	<cffunction name="GetErrors" access="public" returntype="query">
		<cfargument name="SiteID" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="StartDate" type="date" required="no" default="#NullDate#" />
		<cfargument name="EndDate" type="date" required="no" default="#Now()#" />
		<cfargument name="ErrorReportID" type="numeric" required="no" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetErrors">
			SELECT
					mer.errorReportID,
					mer.message,
					mer.theDiagnostics,
					mer.template,
					mer.whenErrorOccurred,
					mer.httpReferer,
					mer.browser,
					mer.queryString,
					mer.remoteAddress,
					mer.tagContext,
					mer.rootCause,
					mer.errorType,
					mer.sqlText,
					mer.formValues,
					mer.siteID,
					s.siteName,
					mer.userEmail,
					mer.dateInserted
			FROM 
					mod_MantisErrorReport mer INNER JOIN
					com_Site s ON mer.siteID = s.siteID
			WHERE
					1 = 1
					
					<cfif Arguments.SiteID gt NullInt>
						AND mer.siteID = #Arguments.SiteID#
					</cfif>
					
					<cfif Arguments.StartDate neq NullDate>
						AND mer.whenErrorOccurred > '#DateFormat(Arguments.StartDate, "yyyy-mm-dd")# 00:00:00'
						AND mer.whenErrorOccurred < '#DateFormat(Arguments.EndDate, "yyyy-mm-dd")# 23:59:59'
					</cfif>
					
					<cfif Arguments.ErrorReportID gt NullInt>
						AND mer.errorReportID = #Arguments.ErrorReportID#
					</cfif>
					
		</cfquery>
		
		<cfreturn qryGetErrors />
		
	</cffunction>
	
	<cffunction name="GetDomains" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetDomains">
			SELECT
					siteID,
					siteName,
					siteURL
			FROM
					com_Site
			WHERE
					isActive = 1
		</cfquery>
		
		<cfreturn qryGetDomains />
		
	</cffunction>
	
	<cffunction name="GetErrorCount" access="public" returntype="query">
	
		<cfquery datasource="#DSN#" name="qryGetErrorCount">
			SELECT
					COUNT(errorReportID) AS totalErrors,
					(SELECT COUNT(errorReportID) FROM mod_MantisErrorReport WHERE whenErrorOccurred >= '#DateFormat(Now(), "yyyy-mm-dd")# 00:00:00') AS todaysErrors
			FROM 
					mod_MantisErrorReport
		</cfquery>
		
		<cfreturn qryGetErrorCount />
	
	</cffunction>
	
	<cffunction name="CreateError" access="public" returntype="boolean" output="yes" hint="Logs an error into the database.">
		<cfargument name="Error" type="any" required="yes" />
		
		<cftry>
		
			<cfquery name="InsertErrorInfo" datasource="#DSN#">
				INSERT mod_MantisErrorReport
						( 
							Message, 
							TheDiagnostics, 
							Template, 
							WhenErrorOccurred, 
							HTTPReferer, 
							Browser, 
							QueryString, 
							RemoteAddress, 
							RootCause, 
							TagContext, 
							ErrorType, 
							sqltext,
							FormValues,
							SiteID, 
							UserEmail
						)
				VALUES
						( 
							'#Arguments.Error.Message#', 
							'#Arguments.Error.Detail#', 
							'#Arguments.Error.Template#', 
							#now()#,
							'#cgi.HTTP_REFERER#', 
							'#cgi.HTTP_USER_AGENT#', 
							'#cgi.QUERY_STRING#', 
							'#cgi.REMOTE_ADDR#', 
							'#Arguments.Error.Message#', 
							'#Arguments.Error.TagContext#', 
							'#Arguments.Error.ErrorType#', 
							'#Arguments.Error.sqlText#',
							'#Arguments.Error.FormValues#',
							#Arguments.Error.SiteID#,
							'#Arguments.Error.NotificationEmail#'
						)
			
			</cfquery>
			
			<cfreturn True />
			
			<cfcatch>
				<cfreturn False />
			</cfcatch>
		
		</cftry>
	
	</cffunction>

</cfcomponent>