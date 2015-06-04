<cfscript>
	Session.Profile.DeleteSession();
	StructClear(Session);
</cfscript>

<cfcookie name="uuid" expires="now" />

<cflocation url="/Home.cfm" addtoken="no" />