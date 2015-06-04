<cfcomponent extends="archimedesCFC.common" displayname="Page Template" hint="CFC for page templates">

	<cfparam name="THIS.TemplateID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.TemplateName" default="#NullString#" type="string" />
	<cfparam name="THIS.Description" default="#NullString#" type="string" />
	<cfparam name="THIS.LayoutID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.LayoutName" default="#NullString#" type="string" />
	<cfparam name="THIS.LayoutDescription" default="#NullString#" type="string" />
	<cfparam name="THIS.SiteID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.RowGuid" default="#NullGuid#" type="guid" />
	<cfparam name="THIS.TemplateModules" default="#GetTemplateModules()#" type="query" />
	
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="TemplateID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="TemplateName" type="string" required="no" default="#NullString#" />

		<cfscript>
			
			// Get the template either by name or ID.
			if(IsEmpty(TemplateName) eq False)
			{
				MapData(GetTemplateByName(Arguments.TemplateName));
			}
			else
			{
				MapData(GetTemplateByID(Arguments.TemplateID));
			}
			
			// Get the default modules for the template
			GetTemplateModules();
			
		</cfscript>
		
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" default="" />

		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.TemplateID = GetInt(Arguments.qryData.templateID);
				THIS.TemplateName = GetString(Arguments.qryData.TemplateName);
				THIS.Description = GetString(Arguments.qryData.description);
				THIS.LayoutID = GetInt(Arguments.qryData.layoutID);
				THIS.LayoutName = GetString(Arguments.qryData.layoutName);
				THIS.LayoutDescription = GetString(Arguments.qryData.layoutDescription);
				THIS.SiteID = GetInt(Arguments.qryData.siteID);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
				THIS.RowGuid = GetGuid(Arguments.qryData.rowguid);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>

	</cffunction>
	
	<cffunction name="GetTemplateByID" access="private" returntype="query">
		<cfargument name="TemplateID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="page_Template_GetByTemplateID">
			<cfprocparam dbvarname="@TemplateID" value="#Arguments.TemplateID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetTemplate" />
		</cfstoredproc>
		
		<cfreturn qryGetTemplate />
		
	</cffunction>
	
	<cffunction name="GetTemplateByName" access="private" returntype="query">
		<cfargument name="TemplateName" type="string" required="yes" default="#NullString#" />
		
		<cfstoredproc datasource="#DSN#" procedure="page_Template_GetByTemplateName">
			<cfprocparam dbvarname="@TemplateName" value="#Arguments.TemplateName#" cfsqltype="cf_sql_varchar" />
			<cfprocresult name="qryGetTemplate" />
		</cfstoredproc>
		
		<cfreturn qryGetTemplate />
		
	</cffunction>

	<cffunction name="GetTemplateModules" access="public" returntype="void">
		
		<cfstoredproc datasource="#DSN#" procedure="page_TemplateModule_GetByTemplateID">
			<cfprocparam dbvarname="@TemplateID" value="#THIS.TemplateID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetTemplateModules" />
		</cfstoredproc>
		
		<cfset THIS.TemplateModules = qryGetTemplateModules />
		
	</cffunction>

</cfcomponent>