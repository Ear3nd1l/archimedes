<cfcomponent extends="archimedesCFC.common" displayname="Module" hint="Base CFC for modules">

	<cfparam name="THIS.ModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.ModuleName" default="#NullString#" type="string" />
	<cfparam name="THIS.ControlPath" default="#NullString#" type="string" />
	<cfparam name="THIS.CFCPath" default="#NullString#" type="string" />
	<cfparam name="THIS.AdminControl" default="#NullString#" type="string" />
	<cfparam name="THIS.ModuleType" default="#NullString#" type="string" />
	<cfparam name="THIS.ModuleTypeID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.RowGuid" default="#NullGuid#" type="guid" />
	
	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and loads the settings.">
		<cfargument name="value" type="numeric" required="no" default="#NullInt#" />
		
		<cfif THIS.ModuleID eq NullInt>
		
			<cfset MapData(GetByModuleID(Arguments.value)) />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void" hint="Maps data from a query to the object's properties.">
		<cfargument name="qryData" type="query" required="yes" default="" />
		
		<cfif IsQuery(qryData) AND qryData.RecordCount>
		
			<cfscript>
			
				THIS.ModuleID = GetInt(Arguments.qryData.moduleID);
				THIS.ModuleName = GetString(Arguments.qryData.moduleName);
				THIS.ControlPath = GetString(Arguments.qryData.controlPath);
				THIS.CFCPath = GetString(Arguments.qryData.cfcPath);
				THIS.AdminControl = GetString(Arguments.qryData.adminControl);
				THIS.ModuleType = GetString(Arguments.qryData.moduleType);
				THIS.ModuleTypeID = GetInt(Arguments.qryData.moduleTypeID);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
				THIS.RowGuid = GetGuid(Arguments.qryData.rowguid);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetByModuleID" access="private" returntype="query">
		<cfargument name="ModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="mod_Module_GetByModuleID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="ModuleID" value="#Arguments.ModuleID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetModuleData" />
		</cfstoredproc>
		
		<cfreturn qryGetModuleData />
		
	</cffunction>
	
	<cffunction name="GetModules" access="public" returntype="query">
		<cfargument name="ShowPageEditorModules" type="Numeric" required="no" default="-1" />
		<cfargument name="ShowOnlyActiveModules" type="Boolean" required="no" default="True" />
		<cfargument name="OrderBy" type="String" required="no" default="mt.moduleTypeID,m.moduleName" />
		
		<cfquery datasource="#DSN#" name="qryGetModules">
			SELECT
					m.moduleID,
					m.moduleName,
					m.cfcPath,
					m.adminControl,
					m.moduleTypeID,
					mt.moduleType,
					mt.FriendlyName
			FROM
					mod_Module m INNER JOIN
					mod_ModuleType mt ON m.moduleTypeID = mt.moduleTypeID
			WHERE
					1 = 1
					<cfif arguments.ShowPageEditorModules gte 0>
						AND mt.ShowInPageEditor = #Arguments.ShowPageEditorModules#
					</cfif>
					<cfif arguments.ShowOnlyActiveModules>
						AND m.isActive = 1
						AND mt.isActive = 1
					</cfif>
			ORDER BY
					#Arguments.OrderBy#
		</cfquery>
		
		<cfreturn qryGetModules />
		
	</cffunction>

</cfcomponent>