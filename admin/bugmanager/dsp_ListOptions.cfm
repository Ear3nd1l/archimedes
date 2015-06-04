<cfoutput>

	<cfparam name="viewbugsoption" default="3">
	
	<cfset qryErrorCounts = objError.GetErrorCount() />
	<cfset getDomains = objError.GetDomains() />
	
	
	<!--- Display confirmation of last action --->
	<cfif len(displaymessage) gt 0>
		<span style="color:red; font-weight:bold;">#DisplayMessage#</span><BR><BR>
	</cfif>
	
	
	<form name="myform" action="index.cfm">
	<table border="0" class="table" cellpadding="3" cellspacing="1" width="100%">
		<tr>
			<th colspan="2">Select criteria to view a list of bugs</th>
		</tr>	
		<tr>
			<td colspan="2">#qryErrorCounts.totalErrors# total / #qryErrorCounts.todaysErrors# today</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="radio" name="ViewBugsOption" value="3" id="b1" <cfif viewbugsoption eq 3>CHECKED</cfif>>
				<label for="b1">View today's bugs</label><BR />
		
				<input type="radio" name="ViewBugsOption" value="2" id="b4" <cfif viewbugsoption eq 2>CHECKED</cfif>>
				<label for="b4">View all bugs</label>
			</td>
		</tr>
		<tr>
			<th colspan="2">Options</th>
		</tr>
		<tr>
			<td width="10%" nowrap="nowrap">Site:</td>
			<td>
				<select name="siteID">
					<option value="#NullInt#">All Sites</option>
					<cfloop query="getDomains">
						<option value="#getDomains.siteID#">#getDomains.siteName#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td width="10%" nowrap="nowrap">Start Date:</td>
			<td>
				<input type="text" name="startdate" maxlength="10" size="10">
			</td>
		</tr>
		<tr>
			<td>End Date:</td>
			<td>
				<input type="text" name="enddate" maxlength="10" size="10">
			</td>
		</tr>
	</table>
	<br />
	<input type="hidden" name="action" value="ListBugs">
	<input type="submit" value="Get Bugs">
	</form>
	
</cfoutput>