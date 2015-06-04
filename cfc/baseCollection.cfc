<cfcomponent extends="ArchimedesCFC.common">

	<cfset VARIABLES.Container = ArrayNew(1) />
	<cfparam name="THIS.Count" default="0" type="numeric" />

	<!---
			Add
				Adds an object to the collection
	--->
	<cffunction name="Add" access="public" returntype="void" output="yes">
		<cfargument name="Object" type="any" required="yes" />

		<cfset ArrayAppend(VARIABLES.container, Arguments.Object) />
		<cfset THIS.count = ArrayLen(VARIABLES.Container) />
	</cffunction>
	
	<!---
			GetAt
					Gets an object in the collection by its index
	--->
	<cffunction name="GetAt" access="public" returntype="any" output="yes">
		<cfargument name="Index" type="numeric" required="yes" default="#NullInt#" />
		
		<!--- If this is a valid item, get it.  Otherwise, return an empty string --->
		<cfif index LTE THIS.Count>
			<cfreturn VARIABLES.Container[Arguments.Index] />
		<cfelse>
			<cfreturn NullString />
		</cfif>
		
	</cffunction>
	
	<!---
			RemoveAt
					Removes an object from the collection by its index
	--->
	<cffunction name="RemoveAt" access="public" returntype="boolean">
		<cfargument name="Index" type="numeric" required="yes" default="#NullInt#" />
		
		<!--- If this is a valid item, remove it.  Otherwise, do nothing --->
		<cfif index LTE THIS.count>
			<cfset ArrayDeleteAt(VARIABLES.Container, Arguments.Index) />
			<cfset THIS.count = ArrayLen(VARIABLES.Container) />
			<cfreturn True />
		<cfelse>
			<cfreturn False />
		</cfif>
	</cffunction>
	
	<!---
			Clear
					Clears the collection
	--->
	<cffunction name="Clear" access="public" returntype="void">
		<cfset VARIABLES.Container = ArrayNew(1) />
		<cfset THIS.Count = 0 />
	</cffunction>

</cfcomponent>