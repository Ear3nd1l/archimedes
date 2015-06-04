<!--- If the user cookie is created and has a value, process it. --->
<cfif isDefined("cookie.uuid") AND Len(Trim(cookie.uuid)) gt 0>

	<!--- Is the Profile object already defined in the Session scope? --->
	<cfif isDefined("Session.Profile.Rowguid")>
	
		<!--- If the Profile object has not been initialized with the user's cookie value, let's do it. --->
		<cfif Session.Profile.Rowguid eq NullGuid>
	
			<!--- Set the the Browser version and IP address of the user to the session object so we can verify it. --->
			<cfscript>
			
				Session.Profile.Init(cookie.uuid);
				Application.isLoggedIn = Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR);

				// If the session has been hijacked, delete it to prevent further tampering.
				if(Application.isLoggedIn eq False) 
				{
					Session.Profile.SessionGuid = cookie.uuid;
					Session.Profile.DeleteSession();
					StructClear(Session);
				}
				else
				{
					// Check to see if the user is a site administrator.
					isAdmin = Session.Profile.HasRole('Site Administrator');
				}

			</cfscript>
			
			<cfif Application.isLoggedIn eq False>
				<cfcookie name="uuid" expires="now" />
			</cfif>
			
		<!--- If the Profile variable exists in the Session scope, verify it to make sure that the user's session hasn't been hijacked. --->
		<cfelse>
		
			<cfscript>
			
				Application.isLoggedIn = Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR);
				
				// If the session has been hijacked, delete it to prevent further tampering.
				if(Application.isLoggedIn eq False) 
				{
					Session.Profile.DeleteSession();
					StructClear(Session);
				}
				else
				{
					// Check to see if the user is a site administrator.
					isAdmin = Session.Profile.HasRole('Site Administrator');
				}
			
			</cfscript>
			
			<cfif Application.isLoggedIn eq False>
				<cfcookie name="uuid" expires="now" />
			</cfif>
			
		</cfif>
		
	<!--- Otherwise, create a blank session object. --->
	<cfelse>

		<cfobject component="#Application.Site.SiteHelpers.UserManager.cfcPath#" name="Session.Profile" />
		<cfset Session.Profile.Init(NullGuid) />
		
		<cfset Application.isLoggedIn = False />
		
	</cfif>

<cfelse>

	<cfobject component="#Application.Site.SiteHelpers.UserManager.cfcPath#" name="Session.Profile" />
	<cfset Session.Profile.Init(NullGuid) />
		
	<cfset Application.isLoggedIn = False />

</cfif>