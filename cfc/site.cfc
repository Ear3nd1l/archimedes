<cfcomponent extends="archimedesCFC.common" displayname="Site" hint="CFC for the site" output="yes">

	<cfparam name="VARIABLES.SiteID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.SiteHelpers" default="#StructNew()#" type="struct" />
	<cfparam name="THIS.SiteSettings" default="#StructNew()#" type="struct" />
	<cfparam name="THIS.SiteName" default="#NullString#" type="string" />
	<cfparam name="THIS.SiteKeywords" default="#NullString#" type="string" />
	<cfparam name="THIS.SkinPath" default="#NullString#" type="string" />

	<cffunction name="Init"	 access="public" returntype="void" hint="Init function for the site object.  It initializes the object and loads the settings.">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			VARIABLES.SiteID = Arguments.value;
			GetSiteHelpers();
			GetSiteSettings();
			GetSkinPath();
			THIS.SiteName = THIS.SiteSettings.SiteName;
			THIS.SiteKeywords = THIS.SiteSettings.SiteKeywords;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="GetSiteHelpersAsQuery" access="public" returntype="query" hint="Returns the site helper modules as a query.">
		<cfargument name="SiteID" type="numeric" required="no" default="#NullInt#" />

		<!--- Get the settings --->
		<cfstoredproc datasource="#DSN#" procedure="com_Site_SiteSettings_GetHelpersBySiteID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="SiteID" value="#Arguments.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qrySiteHelpers" />
		</cfstoredproc>
		
		<cfreturn qrySiteHelpers />

	</cffunction>
	
	<cffunction name="GetSiteHelpers" access="public" returntype="struct" hint="Returns the site helper modules as a structure.">
		<cfargument name="SiteID" type="numeric" required="no" default="#NullInt#" />
		<!--- Create the struct --->
		<cfset var structTemp = StructNew() />
	
		<cfif SiteID gt 0>
			<cfset VARIABLES.SiteID = Arguments.SiteID />
		</cfif>
	
		<!--- Get the settings --->
		<cfinvoke method="GetSiteHelpersAsQuery" returnvariable="qrySiteHelpers">
			<cfinvokeargument name="SiteID" value="#VARIABLES.SiteID#" />
		</cfinvoke>
		
		<!--- Loop through and set the values --->
		<cfloop query="qrySiteHelpers">

			<cfscript>
				// Create the base structure. It contains another structure so we can hold all the settings for the site helper 
				StructInsert(structTemp, Trim(ReplaceNoCase(qrySiteHelpers.siteSetting, ' ', '')), StructNew());
				
				// Load each of the site helper settings into the new struct 
				StructInsert(Evaluate("structTemp." & qrySiteHelpers.siteSetting), "moduleID", qrySiteHelpers.moduleID);
				StructInsert(Evaluate("structTemp." & qrySiteHelpers.siteSetting), "siteSetting", qrySiteHelpers.siteSetting);
				StructInsert(Evaluate("structTemp." & qrySiteHelpers.siteSetting), "controlPath", qrySiteHelpers.controlPath);
				StructInsert(Evaluate("structTemp." & qrySiteHelpers.siteSetting), "cfcPath", qrySiteHelpers.cfcPath);
			
			</cfscript>
		
		</cfloop>
		
		<cfset THIS.SiteHelpers = structTemp />
		
		<cfreturn THIS.SiteHelpers />
	
	</cffunction>
	
	<cffunction name="GetSiteID" access="public" returntype="numeric" hint="Getter for the read-only SiteID variable.">
		<cfreturn VARIABLES.SiteID />
	</cffunction>
	
	<cffunction name="GetSiteSettings" access="public" returntype="struct" hint="Returns the site settings as a structure.">
		<!--- Create the struct --->
		<cfset var structTemp = StructNew() />
	
		<cfstoredproc datasource="#DSN#" procedure="com_Site_SiteSettings_GetBySiteID" cachedwithin="#cachedWithin#">
			<cfprocparam dbvarname="SiteID" value="#VARIABLES.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qrySiteSettings" />
		</cfstoredproc>

		
		<!--- loop through and set the values --->
		<cfloop query="qrySiteSettings">
		
			<cfscript>
				StructInsert(structTemp, Trim(qrySiteSettings.siteSetting), Trim(qrySiteSettings.value));
			</cfscript>
			
		</cfloop>
		
		<cfset THIS.SiteSettings = structTemp />
			
		<cfreturn THIS.SiteSettings />

	</cffunction>
	
	<cffunction name="GetSkinPath" access="private" returntype="void" hint="Sets the SkinPath variable">
	
		<cfif Len(THIS.SkinPath) eq 0>

			<cfif StructIsEmpty(THIS.SiteSettings)>
			
				<cfinvoke method="GetSiteSettings" />
				
			</cfif>
			
			<!--- TODO: Move this into it's own cfc --->
			<cfstoredproc datasource="#DSN#" procedure="com_Skin_GetByID" cachedwithin="#cachedWithin#">
				<cfprocparam dbvarname="SkinID" value="#THIS.SiteSettings.Skin#" cfsqltype="cf_sql_integer" />
				<cfprocresult name="qryGetSkinDetails" />
			</cfstoredproc>
			
			<cfset THIS.SkinPath = qryGetSkinDetails.skinPath />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetLayouts" access="public" returntype="query" hint="Gets all the active page layouts for the site">
	
		<cfstoredproc datasource="#DSN#" procedure="page_Layout_GetAll" cachedwithin="#cachedwithin#">
			<cfprocresult name="qryGetLayouts" />
		</cfstoredproc>
		
		<cfreturn qryGetLayouts />
	
	</cffunction>
	
	<cffunction name="MenuItems" access="public" returntype="query" output="no" hint="Gets menu items for the site">
	
		<cfstoredproc datasource="#DSN#" procedure="site_MenuItem_GetBySiteID" cachedwithin="#CreateTimeSpan(0,0,1,0)#">
			<cfprocparam dbvarname="SiteID" value="#VARIABLES.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryMenuItems" />
		</cfstoredproc>
		
		<cfreturn qryMenuItems />
	
	</cffunction>

</cfcomponent>