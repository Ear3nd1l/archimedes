<!--- Include the common functions library --->
<cfinclude template="#Application.HelperPath#/common/cfscript.common.cfm" />

<cfobject component="ArchimedesCFC.AdminFunctions" name="AdminFunctions" />

<!--- Include the cookie sniffer --->
<cfinclude template="#Application.HelperPath#/auth/cookieSniffer.cfm" />

<cfif IsDefined("Session.Profile") AND Session.Profile.HasRole('Site Administrator')>
	<cfset isAdmin = True />
<cfelse>
	<cfset isAdmin = False />
</cfif>

<cfset IsPostback = SetIsPostback() />
<cfset MinimumRank = 4 />