<cfcomponent extends="archimedesCFC.common" displayname="Phalanx" hint="CFC for the Phalanx SQL Injection module">

	<cffunction name="GetInjectionTypes" access="public" returntype="query" hint="Gets string values for possible SQL injection attempts">
	
		<cfstoredproc datasource="#DSN#" procedure="com_InjectionType_GetAll">
			<cfprocresult name="qryGetInjectionTypes" />
		</cfstoredproc>
		
		<cfreturn qryGetInjectionTypes />
	
	</cffunction>

</cfcomponent>