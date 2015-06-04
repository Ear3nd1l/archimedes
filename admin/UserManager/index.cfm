<cfset qryAllUsers = Session.Profile.GetAllUsers() />

<cfset SectionID = 5 />

<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="User Manager" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#" HelperPath="#Application.HelperPath#" CodeBehind="">

	<div id="admUserPanel" class="panel rounded shadow">
	
		<h3 class="panelHeading roundedSmall shadow">User Manager</h3>
		
		<h3 id="lnkCreateNewUser">Create New User</h3>
		
		<table border="0" cellpadding="2" cellspacing="0" width="96%" class="tblFancy" align="center">
			<thead>
				<tr>
					<th width="20%" align="left" id="tblTopLeft" valign="middle">Last Name</th>
					<th width="20%" align="left" valign="middle">First Name</th>
					<th align="left" valign="middle">Area</th>
					<th width="10%" align="left" id="tblTopRight" valign="middle">Pro Staff?</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="qryAllUsers">
					<tr class="tblFancyRow" profileID="#qryAllUsers.profileID#">
						<td>#qryAllUsers.lastName#</td>
						<td>#qryAllUsers.firstName#</td>
						<td>#qryAllUsers.department#</td>
						<td>#YesNoFormat(qryAllUsers.isProStaff)#</td>
					</tr>
				</cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<td id="tblBottomLeft"></td>
					<td colspan="2"></td>
					<td id="tblBottomRight"></td>
				</tr>
			</tfoot>
		</table>
	
	</div>

	<script src="index.js"></script>
		
</cf_AdminMasterPage>