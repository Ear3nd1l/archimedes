<!---
	File: common.cfc
	Author: Chris Hampton
	Email: chris.hampton@gmx.com
--->
<cfcomponent output="yes" displayname="Common" hint="This is the CFC all other CFCs should inherit from">

	<cfinclude template="cfcConfigLoader.cfm" />
	<cfinclude template="#Application.HelperPath#/common/cfscript.common.cfm" />
	
	<!---
			Init
					Inherited Constructor method
	--->
	<cffunction name="Init" access="public" returntype="void" hint="Inherited Constructor">
	</cffunction>
	
	<!---
			GetModuleByName
					Gets the CFCPath for a module and returns an object created from it.
	--->
	<cffunction name="GetModuleByName" access="public" returntype="any">
		<cfargument name="ModuleName" type="string" required="yes" default="#NullString#" />
	
		<cfquery datasource="#DSN#" name="qryGetModuleByName">
			SELECT
					CFCPath
			FROM
					mod_Module
			WHERE
				moduleName = '#Arguments.ModuleName#'
		</cfquery>
	
		<cfobject component="#qryGetModuleByName.CFCPath#" name="retObj" />
	
		<cfreturn retObj />
		
	</cffunction>

	<!---
			Sanitize
					Sanitizes the string properties of the object.
	--->
	<cffunction name="Sanitize" access="private" hint="Sanitizes the string properties of the object." output="yes">
	
		<!--- Get the keys from the THIS structure --->
		<cfset keys = StructKeyArray(THIS) />
		<cfset keyList = StructKeyList(THIS, ',') />

		<!--- Get the injection types. --->
		<cfstoredproc datasource="#DSN#" procedure="com_InjectionType_GetAll">
			<cfprocresult name="qryGetInjectionTypes" />
		</cfstoredproc>
		
		<!--- Loop through the injection types. --->
		<cfloop query="qryGetInjectionTypes"> 
		
			<!--- Loop through the keys. --->
			<cfloop from="1" to="#arrayLen(keys)#" index="i">
			
				<!--- Get the value of the key. --->
				<cfset keyValue = THIS[keys[i]] />
			
				<!--- Wrap this in a try/catch because not all of the keys are strings. --->
				<cftry>
				
					<!--- Make sure this is not an XML property, and then check to see if the string property contains an injection type. --->
					<cfif NOT IsXMLDoc(keyValue) AND keyValue contains Trim(qryGetInjectionTypes.value)>
					
						<!--- Clean it and re-assign the value to the property. --->
						<cfset keyValue = ReplaceNoCase(keyValue, Trim(qryGetInjectionTypes.value), '', 'all') />
						<cfset THIS[keys[i]] = keyValue />
						
					</cfif> 
					
					<cfcatch></cfcatch>
				
				</cftry>
			
			</cfloop>
			
		 </cfloop> 
		
	</cffunction>
	
	<!---
			SanitizeArguments
					Sanitizes the string values of an argument structure. This method does not work correctly.
	--->
	<cffunction name="SanitizeArguments" access="private" returntype="struct">
		 <cfargument name="argumentStruct" type="struct" required="yes" />
		
		<!--- Get the keys from the THIS structure --->
		<cfset keys = StructKeyArray(Arguments.argumentStruct) />
		<cfset keyList = StructKeyList(Arguments.argumentStruct, ',') />

		<!--- Get the injection types. --->
		<cfstoredproc datasource="#DSN#" procedure="com_InjectionType_GetAll">
			<cfprocresult name="qryGetInjectionTypes" />
		</cfstoredproc>
		
		<!--- Loop through the injection types. --->
		<cfloop query="qryGetInjectionTypes"> 
		
			<!--- Loop through the keys. --->
			<cfloop from="1" to="#arrayLen(keys)#" index="i">
			
				<!--- Get the value of the key. --->
				<cfset keyValue = Arguments.argumentStruct[keys[i]] />
			
				<!--- Wrap this in a try/catch because not all of the keys are strings. --->
				<cftry>
				
					<!--- Make sure this is not an XML property, and then check to see if the string property contains an injection type. --->
					<cfif NOT IsXMLDoc(keyValue) AND keyValue contains Trim(qryGetInjectionTypes.value)>
					
						<!--- Clean it and re-assign the value to the property. --->
						<cfset keyValue = ReplaceNoCase(keyValue, Trim(qryGetInjectionTypes.value), '', 'all') />
						<cfset Arguments.argumentStruct[keys[i]] = keyValue />
						
					</cfif> 
					
					<cfcatch></cfcatch>
				
				</cftry>
			
			</cfloop>
			
		</cfloop> 

		<cfreturn Arguments.argumentStruct /> 
		
	</cffunction>

</cfcomponent>