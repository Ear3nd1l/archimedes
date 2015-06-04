<!--- If the user is an admin, give them access. --->
<cfif isAdmin>

	<cfset hasAccess = True />

<cfelseif NOT isDefined("Session.Profile") OR Session.Profile.HighestRank lt MinimumRank>
	
	<h1>Access Denied</h1>
	<cfabort />
	
<cfelse>

	<!--- If this is the page editor, check the user's access. --->
	<cfif isDefined("url.pageID") AND url.pageID gt NullInt>
	
		<!--- If the user is a department content manager and this page is part of the user's department, give them access. --->
		<cfif Session.Profile.HasRole('Department Content Manager') AND Page.DepartmentID eq Session.Profile.DepartmentID>

			<cfset hasAccess = True />

		<!--- Otherwise, check to see if the user has been given permission by a DCM or Admin. --->
		<cfelseif Session.Profile.HasAdminAccess(Page.PageID)>
		
			<cfset hasAccess = True />
		
		<!--- Otherwise, deny access. --->
		<cfelse>
			
			<cfset hasAccess = False />
			
		</cfif>
		
	<!--- Save this area for other admin security inspections. --->
	<cfelse>
	
		<cfset hasAccess = false />
	
	</cfif>

</cfif>