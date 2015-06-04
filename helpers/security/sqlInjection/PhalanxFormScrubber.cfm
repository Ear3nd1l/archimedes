<cfsilent>

	<!--- Pull the keys from the form --->
	<cfset keys = StructKeyArray(form)>
	
	<!--- Loop through the injection types --->	
	<cfloop query="qryGetInjectionTypes">
	
		<!--- Loop through the keys and inspect them for hack attempts --->
		<cfloop from="1" to="#arrayLen(keys)#" index="i">

			<!--- If the form key contains one of the injection types, this is a hack attempt. --->
			<cfif form[keys[i]] contains Trim(qryGetInjectionTypes.value)>
				<cfset isHackAttempt = True />
			</cfif>
		
		</cfloop>
		
	</cfloop>

</cfsilent>

<!--- If this is a hack attempt, end processing and send a 400 error. --->
<cfif isHackAttempt>
	<cfheader statuscode="400" statustext="Bad Request">
	<h1>Bad Request</h1>
	<cfabort>
</cfif>