<cftry>

	<!--- Include the common functions library --->
	<cfinclude template="#Application.HelperPath#/common/cfscript.common.cfm" />
	
	<cfset IsPostback = SetIsPostback() />
	<cfset HasAccess = False />
	<cfset IsAdmin = False />
	
	<!--- Include the cookie sniffer --->
	<cfinclude template="#Application.HelperPath#/auth/cookieSniffer.cfm" />
	
	<cfparam name="url.uuid" default="#NullGuid#" />
	
	<cfobject component="ArchimedesCFC.modules.pageModule" name="PageModule" />
	
	<cfset PageModule.GetByRowGuid(url.uuid) />
	
	<cfobject component="ArchimedesCFC.page" name="Page" />
	<cfset Page.Init(PageModule.PageID) />
	
	<cfinclude template="#Application.HelperPath#/common/checkUserAccess.cfm" />
	
	<cfif hasAccess eq False>
		<h4>Access Denied</h4>
		<cfabort />
	</cfif>
	
	<cfcookie name="reloadWindowOnClose" value="true" />
	
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
	
		<body class="lightBoxBody">
	
			<cfinclude template="#PageModule.AdminControl#" />
			
		</body>
	</cfoutput>
	
	<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
	
</cftry>
