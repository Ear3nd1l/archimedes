<cfcomponent extends="ArchimedesCFC.baseCollection">

	<!---
			Init
				Initializes the object
	--->
	<cffunction name="Init" access="public" output="no">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			MapObjects(GetTemplatesBySiteID(Arguments.value));
		</cfscript>
		
	</cffunction>
	
	<cffunction name="MapObjects" access="public" returntype="void" output="yes">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfloop query="Arguments.qryData">
			
			<cfscript>
				
				Template = CreateObject('component', 'ArchimedesCFC.PageTemplate');
				
				Template.TemplateID = GetInt(Arguments.qryData.templateID);
				Template.TemplateName = GetString(Arguments.qryData.TemplateName);
				Template.Description = GetString(Arguments.qryData.description);
				Template.LayoutID = GetInt(Arguments.qryData.layoutID);
				Template.LayoutName = GetString(Arguments.qryData.layoutName);
				Template.LayoutDescription = GetString(Arguments.qryData.layoutDescription);
				Template.SiteID = GetInt(Arguments.qryData.siteID);
				Template.IsActive = GetBool(Arguments.qryData.isActive);
				Template.RowGuid = GetGuid(Arguments.qryData.rowguid);
				Template.GetTemplateModules();
				Template.Sanitize();
				
				Add(Template);
			</cfscript>
		
		</cfloop>
		
	</cffunction>


	<cffunction name="GetTemplatesBySiteID" access="private" returntype="query">
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="page_Template_GetBySiteID">
			<cfprocparam dbvarname="@SiteID" value="#Arguments.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetTemplates" />
		</cfstoredproc>
		
		<cfreturn qryGetTemplates />
		
	</cffunction>

</cfcomponent>