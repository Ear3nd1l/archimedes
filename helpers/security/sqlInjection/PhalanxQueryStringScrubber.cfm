<cfsilent>

	<!--- Loop through the injection types --->	
	<cfloop query="qryGetInjectionTypes">
	
		<!--- If the query string contains one of the injection types, this is a hack attempt. --->
		<cfif cgi.QUERY_STRING contains Trim(qryGetInjectionTypes.value)>
			<cfset isHackAttempt = True />
		</cfif>
	
	</cfloop>

</cfsilent>

<!--- If this is a hack attempt, end processing and send a 400 error. --->
<cfif isHackAttempt>
	<cfheader statuscode="400" statustext="Bad Request">
	<h1>Bad Request</h1>
	<cfabort>
</cfif>