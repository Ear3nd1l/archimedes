<cfparam name="url.profileID" default="-1" type="numeric" />

<!--- Create the Admin Functions object. --->
<cfobject component="ArchimedesCFC.adminFunctions" name="AdminFunctions" />

<!--- Get the provinces --->
<cfset qryProvinces = AdminFunctions.GetProvinces() />
<cfset qryDepartments = AdminFunctions.GetDepartmentInfo(Application.SiteID, 0) />
<cfset qryRoles = Adminfunctions.GetRoles() />

<!--- Create the user object and initialize it with the user's profileID. --->
<cfobject component="#Application.Site.SiteHelpers.UserManager.cfcPath#" name="userDetails" />
<cfset userDetails.Clear() />
<cfset userDetails.GetByProfileID(url.profileID) />
<cfset qryUserRoles = userDetails.GetUsersRoles() />
<cfset userRoles = ValueList(qryUserRoles.roleName, ',') />
<cfset userRoleIDs = ValueList(qryUserRoles.roleID, ',') />

<cfif isPostback>

	<!--- If the General Info form was submitted... --->
	<cfif IsDefined('form.btnSaveGeneralInfo')>
	
		<cfparam name="form.chkIsLocked" default="False" type="boolean" />
	
		<cfscript>
		
			userDetails.UserName = form.txtUserName;
			userDetails.FirstName = form.txtFirstName;
			userDetails.LastName = form.txtLastName;
			userDetails.Address1 = form.txtAddress1;
			userDetails.Address2 = form.txtAddress2;
			userDetails.Address3 = form.txtAddress3;
			userDetails.City = form.txtCity;
			userDetails.ProvinceID = form.ddlProvince;
			userDetails.PostalCode = form.txtPostalCode;
			userDetails.EmailAddress = form.txtEmailAddress;
			userDetails.Phone1 = form.txtPhone1;
			userDetails.Phone2 = form.txtPhone2;
			userDetails.Phone3 = form.txtPhone3;
			userDetails.Fax1 = form.txtFax1;
			userDetails.Fax2 = form.txtFax2;
			userDetails.DepartmentID = form.ddlDepartmentID;
			userDetails.IsLocked = form.chkIsLocked;
			
			userDetails.Save();
		
		</cfscript>
	
	<!--- If the Roles form was submitted... --->
	<cfelseif IsDefined('form.btnSaveRoles')>
	
		<cfparam name="form.chkRoleID" default="" type="string" />
		
		<cfoutput>
		
		<!--- See if there were any new roles added to the user. --->
		<cfloop list="#form.chkRoleID#" index="i">
		
			<!--- If the selected role was not found in the user's currently assigned roles, add it. --->
			<cfif ListFind(userRoles, i, ',') eq 0>
			
				<cfset retVal = userDetails.GiveUserRole(i) />
				
			</cfif>
		
		</cfloop>
		
		<!--- Check to see if any roles were removed from the user. --->
		<cfloop list="#userRoleIDs#" index="x">
		
			<!--- If this role was not found in the form, remove it from the user. --->
			<cfif ListFind(form.chkRoleID, x, ',') eq 0>
			
				<cfset retVal = userDetails.RemoveUserRole(x) />
			
			</cfif>
		
		</cfloop>	
		
		</cfoutput>	

		<cfset qryUserRoles = userDetails.GetUsersRoles() />
		<cfset userRoles = ValueList(qryUserRoles.roleName, ',') />
		
	</cfif>

</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Edit User</title>

<cfoutput>
	<link rel="stylesheet" href="#Application.URLRoot#skins/admin.css" />
	<link rel="stylesheet" href="#Application.URLRoot#skins/adminLayouts.css" />
	<link rel="stylesheet" href="#Application.URLRoot#skins/jquery-ui.custom.css" />

	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery-ui-1.7.2.custom.min.js"></script>
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jScrollPane-1.2.3.min.js"></script>
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery.common.js"></script>
	<script type="text/javascript" src="#Application.URLRoot#jQuery/jquery.corners.min.js"></script>
	<script type="text/javascript" src="#Application.UrlRoot#jQuery/jquery.tablesorter.min.js"></script>
	
	<!--- Output the values for the URLRoot and Helper Path into javascript. --->
	<script type="text/javascript">
	
		var URLRoot = '#Application.URLRoot#';
		var HelperPath = '#Application.HelperPath#';
	
	</script>

</cfoutput>

</head>

<body>

	<cfoutput>
	
		<div id="divEditUserWizard">
		
			<div class="divEditUserPanel" id="pnlGeneralInfo">
			
				<form action="userDetails.cfm?profileID=#url.profileID#" method="post">
				
					<div class="frmFrameFull">
				
						<div class="frmFrameInnerLeft tall">
						
							<label for="txtUserName" class="frmLabel">User Name</label>
							<input type="text" name="txtUserName" id="txtUserName" value="#userDetails.UserName#" class="frmInput" />
					
							<label for="txtFirstName" class="frmLabel">First Name</label>
							<input type="text" name="txtFirstName" id="txtFirstName" value="#userDetails.FirstName#" class="frmInput" />
					
							<label for="txtLastName" class="frmLabel">Last Name</label>
							<input type="text" name="txtLastName" id="txtLastName" value="#userDetails.LastName#" class="frmInput" />
						
							<label for="ddlDepartmentID" class="frmLabel">Department</label>
							<select name="ddlDepartmentID" id="ddlDepartmentID" class="frmSelect">
								<cfloop query="qryDepartments">
									<option value="#qryDepartments.departmentID#" <cfif qryDepartments.departmentID eq userDetails.DepartmentID>selected="selected"</cfif>>#qryDepartments.department#</option>
								</cfloop>
							</select>
							
							<div class="clear"></div>
							
							<input type="checkbox" name="chkIsLocked" id="chkIsLocked" value="True" <cfif userDetails.IsLocked>checked</cfif> />
							<label for="chkIsLocked" class="frmLabel inline">Lock User?</label>
							
						</div>
						
						<div class="frmFrameInnerRight tall">
				
							<label for="txtAddress1" class="frmLabel">Address 1</label>
							<input type="text" name="txtAddress1" id="txtAddress1" value="#userDetails.Address1#" class="frmInput" />
					
							<label for="txtAddress2" class="frmLabel">Address 2</label>
							<input type="text" name="txtAddress2" id="txtAddress2" value="#userDetails.Address2#" class="frmInput" />
					
							<!--- <label for="txtAddress3" class="frmLabel">Address 3</label> --->
							<input type="hidden" name="txtAddress3" id="txtAddress3" value="#userDetails.Address3#" class="frmInput" />
					
							<label for="txtCity" class="frmLabel">City</label>
							<input type="text" name="txtCity" id="txtCity" value="#userDetails.City#" class="frmInput" />
							
							<label for="ddlProvince" class="frmLabel">Province</label>
							<select name="ddlProvince" id="ddlProvince" class="frmSelect">
								<cfloop query="qryProvinces">
									<option value="#qryProvinces.provinceID#" <cfif qryProvinces.provinceID eq userDetails.ProvinceID>selected="selected"</cfif>>#qryProvinces.name#</option>
								</cfloop>
							</select>
					
							<label for="txtPostalCode" class="frmLabel">Postal Code</label>
							<input type="text" name="txtPostalCode" id="txtPostalCode" value="#userDetails.PostalCode#" class="frmInput" />
							
							<label for="txtEmailAddress" class="frmLabel">Email Address</label>
							<input type="text" name="txtEmailAddress" id="txtEmailAddress" value="#userDetails.EmailAddress#" class="frmInput" />
							
						
						</div>
						
						<div class="clear"></div>
					
					</div>
					
					<div class="clear"></div>
					
					<div class="frmFrameFull">
					
						<div class="frmFrameInnerLeft">
			
							<label for="txtPhone1" class="frmLabel">Phone 1</label>
							<input type="text" name="txtPhone1" id="txtPhone1" value="#userDetails.Phone1#" class="frmInput" />
							
							<label for="txtPhone2" class="frmLabel">Phone 2</label>
							<input type="text" name="txtPhone2" id="txtPhone2" value="#userDetails.Phone2#" class="frmInput" />
					
							<label for="txtPhone3" class="frmLabel">Phone 3</label>
							<input type="text" name="txtPhone3" id="txtPhone3" value="#userDetails.Phone3#" class="frmInput" />
							
						</div>
						
						<div class="frmFrameInnerRight">
			
							<label for="txtFax1" class="frmLabel">Fax 1</label>
							<input type="text" name="txtFax1" id="txtFax1" value="#userDetails.Fax1#" class="frmInput" />
							
							<label for="txtFax2" class="frmLabel">Fax 2</label>
							<input type="text" name="txtFax2" id="txtFax2" value="#userDetails.Fax2#" class="frmInput" />
							
							<input type="submit" value="Save" id="btnSaveGeneralInfo" name="btnSaveGeneralInfo" class="btnSave" />
					
						</div>
						
						<div class="clear"></div>
						
					</div>
					
				</form>
				
			</div>
			
			<div id="divNextPanelRoles" class="divWizardNext">Roles</div>
			
			<div id="divPreviousPanelGeneral" class="divWizardPrevious">General Info</div>
			
			<div class="divEditUserPanel" id="pnlRoles">
			
				<div class="frmFrameFull taller">
				
					<cfset numPerColumn = Round((qryRoles.RecordCount / 2)) />
					
					<div class="frmFrameInnerLeft">
					
						<form action="userDetails.cfm?profileID=#url.profileID#" method="post">
					
							<cfloop query="qryRoles">
							
								<input type="checkbox" name="chkRoleID" id="chkRoleID#qryRoles.roleID#" value="#qryRoles.roleID#" <cfif ListFind(userRoles, qryRoles.roleName, ',')>checked</cfif> />
								<label for="chkRoleID#qryRoles.roleID#" class="frmLabel inline">#qryRoles.roleName#</label> (#qryRoles.roleRanking#)
								<p class="roleDescription">#qryRoles.description#</p>
							
								<cfif qryRoles.CurrentRow eq numPerColumn>
								
									</div>
									
									<div class="frmFrameInnerRight">
								
								</cfif>
							
							</cfloop>
							
							<input type="submit" name="btnSaveRoles" value="Save" />
						
						</form>
					
					</div>
				
				</div>
			
			</div>

			<div id="divNextPanelInOutBoard" class="divWizardNext">In/Out Board Options</div>
			
			<div id="divPreviousPanelRoles" class="divWizardPrevious">Roles</div>
			
			<div class="divEditUserPanel" id="pnlInOutBoard">
			
				<div class="frmFrameFull tall">
				
				</div>
			
			</div>
			
		</div>
		
	</cfoutput>

	<script>
		
		$(function() {
			
			$('#divNextPanelRoles').click(function() {

				$('.divEditUserPanel').animate({'top': '-477px'}, 1000);
				$('.divWizardNext').animate({'top': '-477px'}, 1000);
				$('.divWizardPrevious').animate({'top': '-477px'}, 1000);

			});

			$('#divPreviousPanelGeneral').click(function() {

				$('.divEditUserPanel').animate({'top': '0px'}, 1000);
				$('.divWizardNext').animate({'top': '0px'}, 1000);
				$('.divWizardPrevious').animate({'top': '0px'}, 1000);

			});

			$('#divNextPanelInOutBoard').click(function() {

				$('.divEditUserPanel').animate({'top': '-954px'}, 1000);
				$('.divWizardNext').animate({'top': '-954px'}, 1000);
				$('.divWizardPrevious').animate({'top': '-954px'}, 1000);

			});

			$('#divPreviousPanelRoles').click(function() {

				$('.divEditUserPanel').animate({'top': '-477px'}, 1000);
				$('.divWizardNext').animate({'top': '-477px'}, 1000);
				$('.divWizardPrevious').animate({'top': '-477px'}, 1000);

			});

		});
		
	</script>

</body>
</html>