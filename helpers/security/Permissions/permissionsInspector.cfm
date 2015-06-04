<!--- If the user is a site admin, grant them access.  Otherwise, check their permissions. --->
<cfif IsAdmin>

	<cfset HasAccess = True />
	<cfset IsPageEditor = True />

<cfelse>

	<!--- Check the page's access level --->
	<cfswitch expression="#Page.AccessLevelID#">
	
		<!--- If this is a public page, the user automatically has access --->
		<cfcase value="1">
			<cfset HasAccess = True />
		</cfcase>
		
		<!--- If this is an intranet page, check to see if the user has the appropriate permission rank --->
		<cfcase value="2">
			
			<cftry>
				
				<cfif Session.Profile.HighestRank gte 3>
					<cfset HasAccess = True />
				</cfif>
				
				<cfcatch><cfset HasAccess = False /></cfcatch>
				
			</cftry>
			
		</cfcase>
		
		<!--- 
			If this is a department only page, check to see if the user is in this department.  
			If they are not, check to see if they have been granted access by the department content manager. 
		--->
		<cfcase value="3">
			<cfif Session.Profile.DepartmentID eq Page.DepartmentID AND Session.Profile.HighestRank gte 3>
				<cfset HasAccess = True />
			<cfelseif Session.Profile.HasGuestAccess(Page.PageID)>
				<cfset HasAccess = True />
			</cfif>
		</cfcase>
		
		<cfcase value="4">
			<cfset HasAccess = Session.Profile.HasGuestAccess(PageID) />
		</cfcase>
		
		<cfdefaultcase>
			<cfset HasAccess = False />
		</cfdefaultcase>
		
	</cfswitch>
	
	<cftry>
	
		<!--- See if the user is a page editor --->
		<cfset IsPageEditor = Session.Profile.HasAdminAccess(PageID) />
		
		<cfcatch><cfset IsPageEditor = False /></cfcatch>
	
	</cftry>

</cfif>