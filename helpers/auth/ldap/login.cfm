<cfset Request.isLoggedIn = False />

<cfif isDefined("form")>

	<!--- Create the object --->
	<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
	<cfparam name="Attributes.cfcPath" default="" type="string" />
	
	<cfobject component="#Attributes.cfcPath#" name="objLDAP" />
	
	<cfset objLDAP.Init(Application.SiteID) />

	<cftry>
	
		<!--- Send the auth info to the LDAP server --->
		<cfldap username="#objLDAP.LDAPSettings.Domain#\#form.txtUserName#" password="#form.txtPassword#" action="query" name="qryAuthenticate" server="#objLDAP.LDAPSettings.Server#" port="#objLDAP.LDAPSettings.Port#" attributes="#objLDAP.LDAPSettings.Attributes#" maxrows="100" start="#objLDAP.LDAPSettings.Start#" scope="#objLDAP.LDAPSettings.Scope#" filter="cn=*#UCase(getToken(form.txtUsername, 1, ' '))#*" timeout="#objLDAP.LDAPSettings.Timeout#" />
		
		<cfset ldapSuccess = True />
		
		<cfcatch>
			<cfset ldapSuccess = False />
		</cfcatch>
		
	</cftry>
	
	<cfif ldapSuccess>
	
		<cfif NOT isDefined("Session.Profile")>
		
			<cfobject component="#Application.Site.SiteHelpers.UserManager.cfcPath#" name="Session.Profile" />
			<cfset Session.Profile.Init('00000000-0000-0000-0000-000000000000') />
			
			<cfset Application.isLoggedIn = False />
	
		</cfif>

		<cfscript>
			Session.Profile.UserAgent = cgi.HTTP_USER_AGENT;
			Session.Profile.RemoteAddress = cgi.REMOTE_ADDR;
			isValid = Session.Profile.Login(form.txtUserName, '', Application.SiteID);
		</cfscript>
		
	<cfelse>
	
		<cfset isValid = False />
		<cftry>
		
			<cfset Session.Profile.LogFailedAttempt(form.txtUserName) />
			
			<cfcatch>

				<cfobject component="#Application.Site.SiteHelpers.UserManager.cfcPath#" name="Session.Profile" />
				<cfset Session.Profile.Init('00000000-0000-0000-0000-000000000000') />
				<cfset Session.Profile.LogFailedAttempt(form.txtUserName) />

			</cfcatch>
		</cftry>
	
	</cfif>
	
	<cfif isValid>
	
		<!--- Create the session guid cookie --->
		<cfcookie name="uuid" value="#Session.Profile.SessionGuid#" />
	
		<!--- If the login is valid, send them to their home page. --->
		<!--- <cflocation url="#Session.Profile.HomePage#" addtoken="no" /> --->
		<cflocation url="/Intranet/InOutBoard.cfm" addtoken="no" />
		
		<!--- 
				TODO: Allow the user to specify which page they go to after signing in.  
		--->
	
	<cfelse>
	
		<p>Your login information was incorrect.  Please try again.</p>
	
	</cfif>

</cfif>