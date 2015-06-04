<!---
page purpose:  Displays a list of bugs based on criteria passed in from dsp_ListOptions.cfm
variables to run page:  none 
optional vars: startdate, enddate, ViewBugsOption
other notes:  none
custom tags: none
stored procedures: none
--->
<cfoutput>

	<cfif StartDate IS "">
		<cfset StartDate = "1/1/1900">
	</cfif>
	<cfif EndDate IS "">
		<cfset EndDate = "1/1/2050">
	</cfif>
	
	<!--- if today, then alter the dates --->
	<cfif ViewBugsOption IS "3">
		<cfset startdate = now()>
		<cfset enddate = now()>
	</cfif>

	<!--- call the cfc to get the list of bugs --->
	<cfinvoke component="#objError#" method="GetErrors" returnvariable="GetListErrors">
		<cfinvokeargument name="StartDate" value="#startdate#">
		<cfinvokeargument name="EndDate" value="#enddate#">
		<cfif isDefined("form.siteID")><cfinvokeargument name="siteID" value="#form.siteID#"></cfif>
		
		<!--- if ViewBugsOption is 1 or 0, then pass the value through as ReceivedViaBugReport --->
		<cfif ViewBugsOption IS NOT "2" AND ViewBugsOption IS NOT "3">
			<cfinvokeargument name="ReceivedViaBugReport" value="#ViewBugsOption#">
		</cfif>
	</cfinvoke>
	
	<!--- get the most important bugs on top --->
	<!--- <cfinvoke component="#objError#" method="getGroupedErrors" returnvariable="getGroupedErrors">
		<cfinvokeargument name="startdate" value="#startdate#">
		<cfinvokeargument name="enddate" value="#enddate#">
		<cfif isDefined("form.siteID")><cfinvokeargument name="siteID" value="#form.siteID#"></cfif>
	</cfinvoke> --->
	
	
	
</cfoutput>

<script>
	function checkAll() {
		var fields = document.myform2;
		var isFirst = true;
		var isChecked = true;
		
		for(i=0; i < fields.elements.length; i++) {
			if(fields.elements[i].type == "checkbox") {
				if(isFirst) {
					isFirst = false;
					isChecked = !fields.elements[i].checked;
				}
				
				fields.elements[i].checked = isChecked;
			}
		}
	}
</script>

<cfoutput>
		
	<!--- Display confirmation of last action --->
	<cfif len(displaymessage) gt 0>
		<span style="color:red; font-weight:bold;">#DisplayMessage#</span>
		<BR><BR>
	</cfif>

</cfoutput>

<!--- If no records found, give message --->
<cfif GetListErrors.RecordCount LT 1>
	
		<b>No records found that match the submitted criteria.</b>

<cfelse>

	<!--- create a list of errorid values for this result set --->
	<cfset ErrorIDList = "">
	
	<cfoutput query="GetListErrors">
		<cfset ErrorIDList = ListAppend(ErrorIDList, ErrorID)>
	</cfoutput>
	
	<cfoutput>
	<table width="100%">
		<tr>
			<td valign="top" width="50%">
			
				<form method="post" action="index.cfm">
					<input type="hidden" name="Action" value="SaveBugs">
					<input type="hidden" name="SaveAction" value="DeleteGroup">
					<input type="hidden" name="DeleteErrorID" value="#ErrorIDList#">
					<table border="0" class="table" cellpadding="3" cellspacing="1" width="100%">
						<tr>
							<th colspan="2">Select a delete option</th>
						</tr>
						<tr>
							<td colspan="2">#GetListErrors.RecordCount# Bugs match the submitted criteria.</td>
						</tr>
						<tr>
							<td valign="top" colspan="2">
								<input type="radio" name="DeleteBugsOption" value="3" id="do1"><label for="do1">Delete all bugs in database</label><br>
								<input type="radio" name="DeleteBugsOption" value="2" id="do2" checked><label for="do2">Delete all bugs in this result set</label><br>
								<input type="radio" name="DeleteBugsOption" value="1" id="do3"><label for="do3">Delete user-generated bug reports in this result set</label><br>
								<input type="radio" name="DeleteBugsOption" value="0" id="do4"><label for="do4">Delete error page bug reports in this result set</label>
							</td>
						</tr>
						<tr>
							<th colspan="2">Select a Date Range (optional)</th>
						</tr>
						<tr>
							<td width="10%" nowrap="nowrap">Start Date:</td>
							<td>
								<input type="text" name="startdate" maxlength="10" size="10">
								<a href="javascript:show_calendar('myform.startdate');" onMouseOver="window.status='Date Picker';return true;" onMouseOut="window.status='';return true;">
								<img src="../images/buttonImage.gif" width="16" height="15" border=0></a>
							</td>
						</tr>
						<tr>
							<td>End Date:</td>
							<td>
								<input type="text" name="enddate" maxlength="10" size="10">
								<a href="javascript:show_calendar('myform.enddate');" onMouseOver="window.status='Date Picker';return true;" onMouseOut="window.status='';return true;">
								<img src="../images/buttonImage.gif" width="16" height="15" border=0></a>
							</td>
						</tr>
					</table>
					<BR />
					<input type="submit" value="Delete Bugs">
				</form>
		
			</td>
			<td valign="top" width="50%">
			
				<cfinclude template="dsp_listoptions.cfm">
				
			</td>
		</tr>
	</table>
	
	<BR />
	
	<!--- <cfif getGroupedErrors.recordcount gt 0>
		<table border="0" class="table" cellpadding="3" cellspacing="1" width="100%">
			<tr>
				<th colspan="4">Top Ranking bugs</th>
			</tr>		
			<tr>
				<td>Count</td>
				<td>Error</td>
				<td>Template</td>
			</tr>
			
			<cfloop query="getGroupedErrors">
				<tr <cfif currentrow mod 2 eq 0>class="stripe"<cfelse>class="stripe2"</cfif>>
					<td>#mycount#</td>
					<td>#message#</td>
					<td>#template#</td>
				</tr>
			</cfloop>
		</table>
		<BR />
	</cfif>	 --->
	
	<form method="post" name="myform2" action="index.cfm">
		<input type="hidden" name="Action" value="SaveBugs">
		<input type="hidden" name="SaveAction" value="DeleteSelected">
		<table border="0" class="table" cellpadding="3" cellspacing="1" width="100%">
			<tr>
				<th colspan="7">Bugs that fit your query</th>
			</tr>			
			<tr>				
				<td scope="col" align="center">
					<input type="button" value="select" onclick="checkAll();">
					<input type="submit" value="delete">
				</td>
				<td align="center">Date Received</td>
				<td align="center">Diagnostics</td>
				<td align="center">Site</td>
				<td align="">Template</td>
				<td align="">Query String</td>
			</tr>
	
			<cfloop query="GetListErrors">
				<tr <cfif currentrow mod 2 eq 0>class="stripe"<cfelse>class="stripe2"</cfif>>
					
					<td align="center" valign="top"> 
						<a href="javascript:popwin('index.cfm?action=ViewBug&ErrorReportID=#errorReportID#', 700, 600)">#errorReportID#</a> 
						<input type="checkbox" name="DeleteErrorID" value="#errorReportID#">
					</td>
					<td valign="top" nowrap="nowrap">#DateFormat(DateInserted, 'mmm dd, yyyy')#<BR />#TimeFormat(DateInserted, 'hh:mm tt')#</td>
					
					<td valign="top">#TheDiagnostics#&nbsp;</td>
					<td valign="top">#siteName#&nbsp;</td>
					<td valign="top">#Template#&nbsp;</td>
					<td valign="top">#QueryString#&nbsp;</td>
				</tr>
			</cfloop>
		</table>
	</form>
	</cfoutput>
</cfif>