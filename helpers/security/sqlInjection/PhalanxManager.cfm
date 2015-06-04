<cfparam name="isHackAttempt" default="False" type="boolean" />

<!--- Call the cfc --->
<cfinvoke component="#Application.Site.SiteHelpers.SQLInjection.cfcPath#" method="GetInjectionTypes" returnvariable="qryGetInjectionTypes" />

<cftry>
	<!--- Check the query string --->
	<cfinclude template="PhalanxQueryStringScrubber.cfm" />
	
	<!--- If this is a posted form, check the form keys --->
	<cfif IsPostBack>
		<cfinclude template="PhalanxFormScrubber.cfm" />
	</cfif>
	<cfcatch>
		<!--- Do something here to process an error and prevent exploitation of this module --->
	</cfcatch>
</cftry>