<!--- Create the Admin Functions object. --->
<cfobject component="ArchimedesCFC.adminFunctions" name="AdminFunctions" />

<!--- Get the provinces --->
<cfset qryProvinces = AdminFunctions.GetProvinces() />
<cfset qryDepartments = AdminFunctions.GetDepartmentInfo(Application.SiteID, 0) />
<cfset qryRoles = Adminfunctions.GetRoles() />

<!--- Create a blank user object. --->
<cfobject component="#Application.Site.SiteHelpers.UserManager.cfcPath#" name="userDetails" />

<cfif isPostback>

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
		
		userDetails.Save();
	
	</cfscript>
	
	<cfif  userDetails.ProfileID gt NullInt>
		<cflocation url="userDetails.cfm?ProfileID=#userDetails.ProfileID#" addtoken="no" />
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
			
				<form action="createUser.cfm" method="post">
				
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
						
		</div>
		
	</cfoutput>

</body>
</html>