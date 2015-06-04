<cfcomponent extends="archimedesCFC.common" displayname="LDAP" hint="CFC for authenticating via an LDAP provider">

	<cfparam name="THIS.ModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.LDAPSettings" default="#GetLDAPSettings()#" />

	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and loads the settings.">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			THIS.ModuleID = Arguments.value;
			GetLDAPSettings();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="GetLDAPSettings" access="public" returntype="struct" hint="Gets the settings for the LDAP module">
		<!--- Create the struct --->
		<cfset var structTemp = StructNew() />
	
		<cfstoredproc datasource="#DSN#" procedure="mod_Module_ModuleSettings_GetByModuleID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="@ModuleID" value="#THIS.ModuleID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryModuleSettings" />
		</cfstoredproc>

		
		<!--- loop through and set the values --->
		<cfloop query="qryModuleSettings">
		
			<cfscript>
				StructInsert(structTemp, Trim(qryModuleSettings.ModuleSetting), Trim(qryModuleSettings.value));
			</cfscript>
			
		</cfloop>
		
		<cfset THIS.LDAPSettings = structTemp />
		
		<cfreturn structTemp />

	</cffunction>
	
</cfcomponent>