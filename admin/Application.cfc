<cfcomponent displayname="ArchimedesCMS" output="true" hint="Handle the application.">

	<cfset THIS.SessionManagement = True />
	
	<cfset THIS.xmlArchimedesConfiguration = XmlParse("../archimedes.config", "yes") />
 
	<!--- Load the Application settings from the archimedes.config file --->
	<cfinclude template="configApplication.cfm" />

	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="true" hint="Fires when the application is first created.">
	 
		<cflock scope="application" timeout="10">
		
			<!--- Load the settings from the archimedes.config file --->
			<cfinclude template="configLoader.cfm" />
	
			<!--- Initialize the Site object --->
			<cfobject component="ArchimedesCFC.site" name="Application.Site" />
			<cfset Application.Site.Init(Application.SiteID) />
			<cfset Application.Initialized = True />
			
		</cflock>

		<cfreturn true />
		
	</cffunction>
 
	<cffunction name="OnSessionStart" access="public" returntype="void" output="yes" hint="Fires when the session is first created.">
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="yes" hint="Fires at first part of page processing.">
		<cfargument name="TargetPage" type="string" required="true" />
		

		<!--- TODO:  Load the cookie sniffer and determine if the user has the correct permissions to access the admin. --->
		<cfreturn true />

	</cffunction>
	
	<cffunction name="OnRequest" access="public" returntype="boolean" output="yes" hint="">
		<cfargument name="TargetPage" type="String" required="true" />
		
		<cfinclude template="commonSettingsLoader.cfm" />
		
		<cfinclude template="#Arguments.TargetPage#">
		<cfreturn true />
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

		 <!--- <cfinclude template="#Application.Site.SiteHelpers.RequestErrorHandler.controlPath#" /> --->
		 
		 <cfdump var="#Exception#" />
		
		<cfreturn />

	</cffunction>
 
	<cffunction name="onMissingTemplate" returnType="boolean" output="true" hint="Fires when a template is missing.  This is currently used for the URL Rewriter.">
	   <cfargument name="thePage" type="string" required="true">
	
		<cfreturn true />
		
	</cffunction>

</cfcomponent>