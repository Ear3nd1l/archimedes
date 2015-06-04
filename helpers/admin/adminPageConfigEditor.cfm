<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR) eq False>
	<h1>Access Denied</h1>
	<cfabort />
</cfif>

<cfparam name="url.pageModuleID" default="0" />

<cfinclude template="#Application.URLRoot#Admin/commonSettingsLoader.cfm" />

<cfobject component="ArchimedesCFC.modules.pageModule" name="PageModule" />

<cfset PageModule.Init(url.pageModuleID) />

<cfoutput>
	<link rel="stylesheet" href="#Application.URLRoot#skins/jquery-ui.custom.css" />
	<link rel="stylesheet" href="#Application.URLRoot#skins/admin.css" />
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery-ui-1.7.2.custom.min.js"></script>
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery.common.js"></script>

	<!--- Output the values for the URLRoot and Helper Path into javascript. --->
	<script type="text/javascript">
	
		var URLRoot = '#Application.URLRoot#';
		var HelperPath = '#Application.HelperPath#';
	
	</script>

</cfoutput>

<div id="divPageEditor">

<cftry>

	<cfinclude template="#PageModule.AdminControl#" />
	
	<cfcatch><!-- <cfoutput>#cfcatch.Message#</cfoutput> --></cfcatch>

</cftry>

</div>