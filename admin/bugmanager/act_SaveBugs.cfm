<!---
page purpose:  Deletes bug records 
variables to run page:  DeleteErrorID, SaveAction, DeleteBugsOption
optional vars:  startdate, enddate, ReceivedViaBugReport 
other notes:  none
cfcs: /globals/cfc/error.cfc
custom tags: none
stored procedures: none
--->

<cfif StartDate IS "">
	<cfset StartDate = "1/1/1900">
</cfif>
<cfif EndDate IS "">
	<cfset EndDate = "1/1/2050">
</cfif>

<cfif SaveAction IS "DeleteGroup">

	<!--- if selected to delete all records in table --->
	<cfif DeleteBugsOption IS "3" OR DeleteErrorID IS "">
		<cfset DeleteErrorID = "0">
	</cfif>
	
	<!--- call the cfc to delete the bugs --->
	<cfinvoke component="#objError#" method="DeleteErrors" returnvariable="DeleteErrors">
		<!--- pass in a list of ErrorID values to delete (0 if chose to delete all bugs) --->
		<cfinvokeargument name="DeleteErrorID" value="#DeleteErrorID#">
		
			<cfinvokeargument name="StartDate" value="#startdate#">
			<cfinvokeargument name="EndDate" value="#enddate#">
		
		<!--- if DeleteBugsOption is 1 or 0, then pass the value through as ReceivedViaBugReport --->
		<cfif DeleteBugsOption IS "1" OR DeleteBugsOption IS "0">
			<cfinvokeargument name="ReceivedViaBugReport" value="#DeleteBugsOption#">
		</cfif>
		
	</cfinvoke>
	
	<!--- Send them back to the List Page with confirm message --->
	<CFLOCATION URL="index.cfm?action=ListOptions&DisplayMessage=Success">
	
<cfelseif SaveAction IS "DeleteSelected">

	<!--- call the cfc to delete the bugs --->
	<cfinvoke component="#objError#" method="DeletethisError" returnvariable="DeletethisError">
		<cfinvokeargument name="DeleteErrorID" value="#DeleteErrorID#">
	</cfinvoke>
	
	<!--- Send them back to the List Page with confirm message --->
	<CFLOCATION URL="index.cfm?action=ListOptions&DisplayMessage=Success">
	
</cfif>
