<!---
	File Name:		PageModule.cfc
	Author:			Chris Hampton
	Created:		
	Last Modified:	
	History:		Reset history for Alpha 2
	Purpose:		CFC object for pages

--->

<cfcomponent extends="ArchimedesCFC.modules.module" displayname="PageModule" hint="CFC for Page Modules">

	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.BucketID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DSN" default="#DSN#" type="string" />

	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfset MapData(GetByPageModuleID(Arguments.value)) />
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void" hint="Maps data from a query to the object's properties.">
		<cfargument name="qryData" type="query" required="yes" default="" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.PageID = GetInt(Arguments.qryData.pageID);
				THIS.ModuleName = GetString(Arguments.qryData.ModuleName);
				THIS.ModuleID = GetString(Arguments.qryData.moduleID);
				THIS.BucketID = GetInt(Arguments.qryData.bucketID);
				THIS.ControlPath = GetString(Arguments.qryData.controlPath);
				THIS.AdminControl = GetString(Arguments.qryData.adminControl);
				THIS.cfcPath = GetString(Arguments.qryData.cfcPath);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
				THIS.IsDeleted = GetBool(Arguments.qryData.isDeleted);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetByPageModuleID" access="private" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
	
		<!--- Get the data --->
		<cfstoredproc datasource="#DSN#" procedure="page_PageModule_GetByPageModuleID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="PageModuleID" value="#Arguments.PageModuleID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetPageModuleData" />
		</cfstoredproc>
		
		<cfreturn qryGetPageModuleData />
		
	</cffunction>
	
	<cffunction name="GetByRowGuid" access="public" returntype="void">
		<cfargument name="RowGuid" default="#NullGuid#" type="string" required="yes" />
		
		<cfif isGuid(Arguments.RowGuid)>
		
			<cfquery datasource="#DSN#" name="qryGetByRowGuid">
				SELECT
						pm.pageModuleID,
						pm.pageID,
						m.moduleName,
						m.moduleID,
						pm.bucketID,
						m.controlPath,
						m.adminControl,
						m.cfcPath,
						pm.isActive,
						pm.isDeleted
				FROM
						page_PageModule pm INNER JOIN
						mod_Module m ON pm.moduleID = m.moduleID 
				WHERE
						pm.rowguid = '#Arguments.RowGuid#'
			</cfquery>
			
			<cfset MapData(qryGetByRowGuid) />
		
		</cfif>
		
	</cffunction>

	<!---
			AddModuleToBucket
					AJAX method to add a module to a bucket
	--->

	<cffunction name="ajaxAddModuleToBucket" access="remote" returntype="any" returnformat="JSON" hint="AJAX method to add a module to a bucket">
		<cfargument name="ModuleID" type="Numeric" required="yes" default="#NullInt#" />
		<cfargument name="BucketID" type="Numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="Numeric" required="yes" default="#NullInt#" />

		<cfinvoke method="AddModuleToBucket" returnvariable="retVal">
			<cfinvokeargument name="ModuleID" value="#Arguments.ModuleID#" />
			<cfinvokeargument name="BucketID" value="#Arguments.BucketID#" />
			<cfinvokeargument name="PageID" value="#Arguments.PageID#" />
		</cfinvoke>
		
		<cfreturn retVal />
		
	</cffunction>
	
	<cffunction name="AddModuleToBucket" access="public" returntype="any">
		<cfargument name="ModuleID" type="Numeric" required="yes" default="#NullInt#" />
		<cfargument name="BucketID" type="Numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="Numeric" required="yes" default="#NullInt#" />
		
		<!--- Call the stored proc --->
		<cfstoredproc datasource="#DSN#" procedure="page_PageModule_AddModule">
			<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="CF_SQL_INTEGER" />
			<cfprocparam dbvarname="@ModuleID" value="#Arguments.ModuleID#" cfsqltype="CF_SQL_INTEGER" />
			<cfprocparam dbvarname="@BucketID" value="#Arguments.BucketID#" cfsqltype="CF_SQL_INTEGER" />
			<cfprocparam dbvarname="@IsActive" value="1" cfsqltype="CF_SQL_BIT" />
			<cfprocresult name="qryAddModule">
		</cfstoredproc>
		
		
		<!--- If the module was successfully added, add the pageModuleID to the return structure --->
		<cfif qryAddModule.RecordCount>
		
			<cftry>
			
				<!--- The module may require additional configuration.  Create an object based on the module's CFC and call the CreateDefaultPageModule method. --->
				<cfobject component="ArchimedesCFC.modules.module" name="Module" />
				<cfset Module.Init(Arguments.ModuleID) />
				
				<cfobject component="#Module.CFCPath#" name="NewModule" />
				<cfset NewModule.CreateDefaultPageModule(qryAddModule.pageModuleID, Arguments.PageID) />
				
				<cfreturn qryAddModule.pageModuleID />
				
				<cfcatch><cfreturn qryAddModule.pageModuleID /></cfcatch>
			
			</cftry>
			
		<cfelse>
			<cfreturn NullInt />
		</cfif>
		
		<!--- Return the structure --->
		<cfreturn NullInt />
		
	</cffunction>
	
	<!---
			UpdateSortOrder
					Updates the sort order of modules in a bucket
	--->
	<cffunction name="UpdateSortOrder" access="remote" returntype="boolean" returnformat="JSON" hint="Updates the sort order of modules in a bucket">
		<cfargument name="OrderList" type="string" required="yes" default="#NullString#" />
		
		<cftry>
		
			<!--- Create the validator object so we can strip the string to numeric numbers only --->
			<cfobject component="ArchimedesCFC.validate" name="Validate" />
			
			<cfset counter = 100 />
			
			<cfloop list="#Arguments.orderList#" index="i">
	
				<cfset pageModuleID = Validate.StripToNumeric(i) />
				
				<cfquery datasource="#DSN#" name="qryUpdateSortOrder">
					UPDATE
							page_PageModule
					SET
							sortOrder = #counter#
					WHERE
							pageModuleID = #pageModuleID#
				</cfquery>
				
				<cfset counter = counter + 100 />
	
			</cfloop>
			
			<cfreturn True />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
				
	</cffunction>
	
	<!---
			CreateDefaultPageModule
					Stub function to create create a new module entry.
	--->
	<cffunction name="CreateDefaultPageModule" access="private" returntype="boolean">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfreturn False />
		
	</cffunction>

</cfcomponent>