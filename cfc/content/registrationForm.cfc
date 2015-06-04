<cfcomponent extends="archimedesCFC.content.formCore" displayname="Registration Form" hint="">

	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfset MapData(GetByQuestionnaireID(GetQuestionnaireID(Arguments.value))) />
		
	</cffunction>
	
</cfcomponent>