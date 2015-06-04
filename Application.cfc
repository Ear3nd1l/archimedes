<cfcomponent displayname="ArchimedesCMS" output="true" hint="Handle the application.">

	<cfset THIS.SessionManagement = True />
	<cfset THIS.SessionTimeout = CreateTimeSpan(0, 10, 0, 0) />
	<cfparam name="Application.Initialized" default="False" />
	
	<cfset THIS.xmlArchimedesConfiguration = XmlParse("archimedes.config", "yes") />

	<!--- Load the Application settings from the archimedes.config file --->
	<cfinclude template="configApplication.cfm" />

	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="true" hint="Fires when the application is first created.">
	
		<cftry>

			<cfif Application.Initialized eq  False>

				<cflock scope="application" type="exclusive" timeout="100">
	
					<!--- Load the additional settings from the archimedes.config file --->
					<cfinclude template="configLoader.cfm" />
		
					<!--- Initialize the Site object --->
					<cfobject component="archimedesCFC.site" name="Application.Site" />
					<cfset Application.Site.Init(Application.SiteID) />
					<cfset Application.Initialized = True />
				
				</cflock>
			
			</cfif>
		
			<cfreturn true />
			
			<cfcatch></cfcatch>
			
		</cftry>
		
	</cffunction>
 
	<cffunction name="OnSessionStart" access="public" returntype="void" output="yes" hint="Fires when the session is first created.">

		<cfreturn />
	</cffunction>
 
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="yes" hint="Fires at first part of page processing.">
		<cfargument name="TargetPage" type="string" required="true" />
		
		<cfif StructKeyExists(url, "restartApplication")>
			<h3>Reinitializing the application</h3>
			<cflock name="lckReinit" timeout="#CreateTimeSpan(0,0,0,30)#"><cfset OnApplicationStart() /></cflock>
		</cfif>
		
		<cfreturn True />
		
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true" hint="Fires after the page processing is complete.">
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="Fires when the session is terminated.">
		<cfargument name="SessionScope" type="struct" required="true" />
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
 
		<cfreturn />

	</cffunction>
 
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="true" hint="Fires when the application is terminated.">
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
		<cfreturn />

	</cffunction>
 
	<cffunction name="OnError" access="public" returntype="void" output="true" hint="Fires when an exception occures that is not caught by a try/catch.">
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default="" />

		<!---<cfinclude template="#Application.Site.SiteHelpers.RequestErrorHandler.controlPath#" />
		<cfdump var="#Exception#" />--->
		<!-- #exception.Message# -->
		<!-- #exception.detail# -->
		<cfreturn />

	</cffunction>
 
	<cffunction name="onMissingTemplate" returnType="boolean" output="true" hint="Fires when a template is missing.  This is currently used for the URL Rewriter.">
	   <cfargument name="thePage" type="string" required="true">
	
		<cftry>
		
            <!--- Include the common functions library --->
            <cfinclude template="#Application.HelperPath#/common/cfscript.common.cfm" />
				
			<cfset IsPostback = SetIsPostback() />
			<cfset HasAccess = False />
			<cfset IsPageEditor = False />
			<cfset IsAdmin = False />
			
			<cflock scope="application" type="readonly" timeout="10">
			
				<!--- Include the cookie sniffer --->
				<cfinclude template="#Application.HelperPath#/auth/cookieSniffer.cfm" />
				
				<!--- Run the SQLInjection module to prevent SQL Injection attacks --->
				<cfinclude template="#Application.Site.SiteHelpers.SQLInjection.controlPath#" /> 
				
				<!--- Include the rewriter --->
				<cfinclude template="#Application.Site.SiteHelpers.Rewriter.controlPath#" />
			
			</cflock>
			
			<cfcatch>
				<!---  TODO: Pass this to the Error Handler --->
				
				<cfset Session.Exception = cfcatch />
				<cfset Session.BrokenPageURL = cgi.SCRIPT_NAME & cgi.QUERY_STRING />
				<cfif isDefined("form")>
					<cfset Session.FormData = form />
				</cfif>
				
				 <cflocation url="/error.cfm" addtoken="no" /> 
				<!--- <cfinclude template="#Application.Site.SiteHelpers.RequestErrorHandler.controlPath#" /> --->
				<cfreturn true />
			</cfcatch>
		</cftry>
		
		<cfreturn true />
		
	</cffunction>

</cfcomponent>