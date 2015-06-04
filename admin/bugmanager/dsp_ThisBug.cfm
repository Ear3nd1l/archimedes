<!---
created by: Lillian
page purpose:  This page displays all the detail for a specific bug
variables to run page:  ErrorID
other notes:  none
cfcs: /globals/cfc/error.cfc
custom tags: none
stored procedures: none
--->

<cfoutput>

<!--- call the cfc to get the bug information --->
<cfinvoke component="#objError#" method="GetErrors" returnvariable="GetthisError">
	<cfinvokeargument name="ErrorReportID" value="#errorReportID#">
</cfinvoke>

</cfoutput>

<form><input type="button" value="close" onclick="self.close()" /></form>

<cfoutput query="GetThisError">

	<table cellpadding="2" CELLSPACING="2" border="0" width="100%" class="table">	
		<tr>
			<td valign="top" class="stripe2"> When Error Occurred </td>
			<td valign="top" class="stripe"> #DateFormat(DateInserted, 'mm/dd/yy')# #TimeFormat(DateInserted, 'hh:mm:ss')# </td>
		</tr>
		<tr>
			<td valign="top" class="stripe2"> Message: </td>
			<td valign="top" class="stripe"> #Message# </td>
		</tr>
		<tr> 
			<td valign="top" class="stripe2"> Diagnostics: </td>
			<td valign="top" class="stripe"> #TheDiagnostics# </td>
  		</tr>
		<tr>
			<td valign="top" class="stripe2"> Site: </td>
			<td valign="top" class="stripe" > #SiteName# </td>
		</tr>
		<tr>
			<td valign="top" class="stripe2">Template:  </td>
			<td valign="top" class="stripe"> #Template#  </td>
		</tr>
		<tr>
			<td valign="top" class="stripe2"> HTTP Referer: </td>
			<td valign="top" class="stripe"> #HTTPReferer# </td>
		</tr>		
		<tr>
			<td valign="top" class="stripe2">Browser: </td>
			<td valign="top" class="stripe"> #Browser# </td>
		</tr>		
		<tr>
			<td valign="top" class="stripe2"> Query String: </td>
			<td valign="top" class="stripe"> #QueryString# </td>
		</tr>	
		<tr>
			<td valign="top" class="stripe2"> Remote Address : </td>
			<td valign="top" class="stripe"> #RemoteAddress# </td>
		</tr>
			
		<cfif len(sqltext) gt 0>
			<tr>
				<td valign="top" class="stripe2"> SQL Text: </td>
				<td valign="top" class="stripe"> #sqltext# </td>
			</tr>
		</cfif>			
		
		<tr>
			<td valign="top" class="stripe2"> Root Cause : </td>
			<td valign="top" class="stripe"> #RootCause# </td>
		</tr>			
		<tr>
			<td valign="top" class="stripe2"> Tag Context: </td>
			<td valign="top" class="stripe"> #TagContext# </td>
		</tr>			
		<tr>
			<td valign="top" class="stripe2">Error Type: </td>
			<td valign="top" class="stripe"> #ErrorType# </td>
		</tr>			
		<tr>
			<td valign="top" class="stripe2">Form Values: </td>
			<td valign="top" class="stripe"> #FormValues# </td>
		</tr>
	</table>
</cfoutput>
	

