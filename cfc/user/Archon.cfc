<cfcomponent extends="archimedesCFC.common" output="no" displayname="Archon" hint="Magistrate of User Profiles">

	<cfparam name="THIS.ProfileID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.FirstName" default="#NullString#" type="string" />
	<cfparam name="THIS.LastName" default="#NullString#" type="string" />
	<cfparam name="THIS.UserName" default="#NullString#" type="string" />
	<cfparam name="THIS.Password" default="#NullString#" type="string" />
	<cfparam name="THIS.Salt" default="#NullString#" type="string" />
	<cfparam name="THIS.DateCreated" default="#NullDate#" type="date" />
	<cfparam name="THIS.IsDeleted" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.RowGuid" default="#NullGuid#" type="guid" />
	<cfparam name="THIS.EmailAddress" default="#NullString#" type="string" />
	<cfparam name="THIS.Address1" default="#NullString#" type="string" />
	<cfparam name="THIS.Address2" default="#NullString#" type="string" />
	<cfparam name="THIS.Address3" default="#NullString#" type="string" />
	<cfparam name="THIS.City" default="#NullString#" type="string" />
	<cfparam name="THIS.ProvinceID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.Province" default="#NullString#" type="string" />
	<cfparam name="THIS.CountryID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.Country" default="#NullString#" type="string" />
	<cfparam name="THIS.PostalCode" default="#NullString#" type="string" />
	<cfparam name="THIS.Phone1" default="#NullString#" type="string" />
	<cfparam name="THIS.Phone2" default="#NullString#" type="string" />
	<cfparam name="THIS.Phone3" default="#NullString#" type="string" />
	<cfparam name="THIS.Fax1" default="#NullString#" type="string" />
	<cfparam name="THIS.Fax2" default="#NullString#" type="string" />
	<cfparam name="THIS.HighestRank" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DepartmentID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.Department" default="#NullString#" type="string" />
	<cfparam name="THIS.SessionCreated" default="#Now()#" type="date" />
	<cfparam name="THIS.SessionGuid" default="#NullGuid#" type="guid" />
	<cfparam name="THIS.UserAgent" default="#NullString#" type="string" />
	<cfparam name="THIS.RemoteAddress" default="#NullString#" type="string" />
	<cfparam name="THIS.HomePage" default="/Home.cfm" type="string" />
	<cfparam name="THIS.IsLocked" default="False" type="boolean" />

	<cffunction name="Init" access="public" returntype="void" hint="Initializes the object and loads the settings.">
		<cfargument name="value" type="string" required="yes" default="#NullGuid#" />
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />
	
		<cfif IsGuid(Arguments.value) AND IsValidSession(Arguments.value)>
	
			<cfset MapData(GetByUUID(Arguments.value,Arguments.SiteID)) />
		
		</cfif>

	</cffunction>
	
	<cffunction name="GetByUUID" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />

		<cfstoredproc datasource="#DSN#" procedure="pro_Profile_GetByUUID">
			<cfprocparam dbvarname="@Rowguid" value="#Arguments.value#" cfsqltype="cf_sql_varchar">
			<cfprocparam dbvarname="@SiteID" value="#Arguments.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetProfileData" resultset="1" />
		</cfstoredproc>

	</cffunction>

	<cffunction name="GetByProfileID" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />

		<cfstoredproc datasource="#DSN#" procedure="pro_Profile_GetByProfileID">
			<cfprocparam dbvarname="@Profile" value="#value#" cfsqltype="cf_sql_integer">
			<cfprocparam dbvarname="@SiteID" value="#siteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetProfileData" resultset="1" />
		</cfstoredproc>

		<cfset MapData(qryGetProfileData) />

	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void" hint="Maps data from a query to the object's properties.">
		<cfargument name="qryData" type="query" required="yes" default="" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.ProfileID = GetInt(Arguments.qryData.profileID);
				THIS.FirstName = GetString(Arguments.qryData.firstName);
				THIS.LastName = GetString(Arguments.qryData.lastName);
				THIS.UserName = GetString(Arguments.qryData.userName);
				THIS.Password = GetString(Arguments.qryData.password);
				THIS.Salt = GetString(Arguments.qryData.salt);
				THIS.DateCreated = GetDate(Arguments.qryData.dateCreated);
				THIS.IsDeleted = GetBool(Arguments.qryData.isDeleted);
				THIS.RowGuid = GetGuid(Arguments.qryData.rowguid);
				THIS.EmailAddress = GetString(Arguments.qryData.emailAddress);
				THIS.Address1 = GetString(Arguments.qryData.address1);
				THIS.Address2 = GetString(Arguments.qryData.address2);
				THIS.Address3 = GetString(Arguments.qryData.address3);
				THIS.City = GetString(Arguments.qryData.city);
				THIS.ProvinceID = GetInt(Arguments.qryData.provinceID);
				THIS.Province = GetString(Arguments.qryData.abbreviation);
				THIS.CountryID = GetInt(Arguments.qryData.countryID);
				THIS.Country = GetString(Arguments.qryData.country);
				THIS.PostalCode = GetString(Arguments.qryData.postalCode);
				THIS.Phone1 = GetString(Arguments.qryData.phone1);
				THIS.Phone2 = GetString(Arguments.qryData.phone2);
				THIS.Fax1 = GetString(Arguments.qryData.fax2);
				THIS.Fax2 = GetString(Arguments.qryData.fax2);
				THIS.HighestRank = GetInt(Arguments.qryData.highestRank);
				THIS.DepartmentID = GetInt(Arguments.qryData.departmentID);
				THIS.Department = GetString(Arguments.qryData.department);
				THIS.HomePage = GetString(Arguments.qryData.homePage);
				THIS.IsLocked = GetBool(Arguments.qryData.isLocked);
			
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="Login" access="public" returntype="boolean" hint="Checks a user's name and password to make sure they are a valid user.">
		<cfargument name="Username" type="string" required="yes" default="#NullString#" />
		<cfargument name="Password" type="string" required="yes" default="#NullString#" />
		<cfargument name="SiteID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="pro_Profile_GetByUsernamePassword">
			<cfprocparam dbvarname="@Username" value="#Arguments.Username#" cfsqltype="cf_sql_varchar" />
			<cfprocparam dbvarname="@Password" value="#Arguments.Password#" cfsqltype="cf_sql_varchar" />
			<cfprocparam dbvarname="@SiteID" value="#Arguments.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetProfileData" />		
		</cfstoredproc>
		
		<cfif qryGetProfileData.RecordCount>
		
			<cfscript>
			
				// Clear all old sessions.
				DeleteAllProfileSessions(qryGetProfileData.profileID);
				
				// Map the data to the object's properties.
				MapData(qryGetProfileData);
				
				// Create the new session.
				return CreateSession();
			
			</cfscript>
			
		<cfelse>
			<cfreturn False />
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetUserRole" access="public" returntype="string" hint="">
	
		<cfstoredproc datasource="#DSN#" procedure="pro_ProfileRoles_GetByProfileID">
			<cfprocparam dbvarname="@ProfileID" value="#THIS.ProfileID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetUserRoles" />
		</cfstoredproc>
		
		<cfreturn ValueList(qryGetUserRoles.roleID, ",") />
	
	</cffunction>
	
	<cffunction name="HasGuestAccess" access="public" returntype="boolean">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="page_PageGuest_CheckAccess">
			<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
			<cfprocparam dbvarname="@ProfileID" value="#THIS.ProfileID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryHasGuestAccess" />
		</cfstoredproc>
		
		<cfreturn qryHasGuestAccess.hasAccess />
		
	</cffunction>
	
	<cffunction name="HasAdminAccess" access="public" returntype="boolean">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="page_PageAdmin_CheckAccess">
			<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
			<cfprocparam dbvarname="@ProfileID" value="#THIS.ProfileID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryHasAdminAccess" />
		</cfstoredproc>
		
		<cfreturn qryHasAdminAccess.hasAccess />
		
	</cffunction>

	<cffunction name="HasRole" access="public" returntype="boolean">
		<cfargument name="RoleName" type="string" required="yes" default="#NullString#" />
		
		<cfstoredproc datasource="#DSN#" procedure="pro_Profile_UserHasRole">
			<cfprocparam dbvarname="@ProfileID" value="#THIS.ProfileID#" cfsqltype="cf_sql_integer" />
			<cfprocparam dbvarname="@RoleName" value="#Arguments.RoleName#" cfsqltype="cf_sql_varchar" />
			<cfprocresult name="qryHasRole" />
		</cfstoredproc>
		
		<cfreturn qryHasRole.hasRole />
	</cffunction>
	
	<cffunction name="GetUsersWithLowerRank" access="public" returntype="query" hint="Gets all users that have a highest rank lower than the specified value">
		<cfargument name="Rank" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="MinimumRank" type="numeric" required="no" default="1" />
		
		<cfstoredproc datasource="#DSN#" procedure="pro_ProfileRole_GetLowerRank">
			<cfprocparam dbvarname="@Rank" value="#Arguments.Rank#" cfsqltype="cf_sql_integer" />
			<cfprocparam dbvarname="@SiteID" value="#Application.SiteID#" cfsqltype="cf_sql_integer" />
			<cfprocparam dbvarname="@MinimumRank" value="#Arguments.MinimumRank#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetUsers" />
		</cfstoredproc>
		
		<cfreturn qryGetUsers />
	</cffunction>
	
	<cffunction name="GrantUserPageManagerRight" access="remote" returntype="boolean" returnformat="JSON" hint="Grants a user the 'Page Manager' role for a page.">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="ProfileID" type="numeric" required="no" default="#THIS.ProfileID#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<!--- Get the RoleID --->
			<cfstoredproc datasource="#DSN#" procedure="com_Role_GetByName">
				<cfprocparam dbvarname="@RoleName" value="Page Manager" cfsqltype="cf_sql_varchar" />
				<cfprocresult name="qryGetRoleID" />
			</cfstoredproc>
			
			<!--- If the role was found, change the access level --->
			<cfif qryGetRoleID.RecordCount>
			
				<cfstoredproc datasource="#DSN#" procedure="page_PageAdmin_ChangeUserAccessLevel">
					<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
					<cfprocparam dbvarname="@ProfileID" value="#Arguments.ProfileID#" cfsqltype="cf_sql_integer" />
					<cfprocparam dbvarname="@RoleID" value="#qryGetRoleID.roleID#" cfsqltype="cf_sql_integer" />
					<cfprocresult name="qryChangeUserAccessLevel" />
				</cfstoredproc>
				
				<!--- If the role was added, return True --->
				<cfif qryChangeUserAccessLevel.RecordCount>
					<cfreturn True />
				<!--- If not, return false --->
				<cfelse>
					<cfreturn False />
				</cfif>
				
			<!--- If the role was not found, return false. --->
			<cfelse>
			
				<cfreturn False />
			
			</cfif>
		
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>

	<cffunction name="GrantUserPageEditorRight" access="remote" returntype="boolean" returnformat="JSON" hint="Grants a user the 'Page Editor' role for a page.">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="ProfileID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<!--- Get the RoleID --->
			<cfstoredproc datasource="#DSN#" procedure="com_Role_GetByName">
				<cfprocparam dbvarname="@RoleName" value="Page Editor" cfsqltype="cf_sql_varchar" />
				<cfprocresult name="qryGetRoleID" />
			</cfstoredproc>
			
			<!--- If the role was found, change the access level --->
			<cfif qryGetRoleID.RecordCount>
			
				<cfstoredproc datasource="#DSN#" procedure="page_PageAdmin_ChangeUserAccessLevel">
					<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
					<cfprocparam dbvarname="@ProfileID" value="#Arguments.ProfileID#" cfsqltype="cf_sql_integer" />
					<cfprocparam dbvarname="@RoleID" value="#qryGetRoleID.roleID#" cfsqltype="cf_sql_integer" />
					<cfprocresult name="qryChangeUserAccessLevel" />
				</cfstoredproc>
				
				<!--- If the role was added, return True --->
				<cfif qryChangeUserAccessLevel.RecordCount>
					<cfreturn True />
				<!--- If not, return false --->
				<cfelse>
					<cfreturn False />
				</cfif>
				
			<!--- If the role was not found, return false. --->
			<cfelse>
			
				<cfreturn False />
			
			</cfif>
		
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="RemoveUserPageRights" access="remote" returntype="boolean" returnformat="JSON" hint="Removes all admin roles a user has to a page.">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="ProfileID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<cftry>
			
				<cfstoredproc datasource="#DSN#" procedure="page_PageAdmin_RemoveUserAccessLevel">
					<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
					<cfprocparam dbvarname="@ProfileID" value="#Arguments.ProfileID#" cfsqltype="cf_sql_integer" />
				</cfstoredproc>
				
				<cfreturn True />
				
				<cfcatch>
					<cfreturn False />
				</cfcatch>
			
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetPageAdminUsers" access="public" returntype="query" hint="Gets Page Admin users for a page based on the role.">
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="RoleName" type="string" required="yes" default="#NullString#" />

		<!--- Get the RoleID --->
		<cfstoredproc datasource="#DSN#" procedure="com_Role_GetByName">
			<cfprocparam dbvarname="@RoleName" value="#Arguments.RoleName#" cfsqltype="cf_sql_varchar" />
			<cfprocresult name="qryGetRoleID" />
		</cfstoredproc>
		
		<!--- If the role was found, get the users. --->
		<cfif qryGetRoleID.RecordCount>
		
			<cfstoredproc datasource="#DSN#" procedure="page_PageAdmin_GetUsersByRole">
				<cfprocparam dbvarname="@PageID" value="#Arguments.PageID#" cfsqltype="cf_sql_integer" />
				<cfprocparam dbvarname="@RoleID" value="#qryGetRoleID.roleID#" cfsqltype="cf_sql_integer" />
				<cfprocresult name="qryGetUsers" />
			</cfstoredproc>
			
			<cfreturn qryGetUsers />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="IsValidSession" access="public" returntype="boolean">
		<cfargument name="UserAgent" type="string" required="yes" default="#NullString#" />
		<cfargument name="RemoteAddress" type="string" required="yes" default="#NullString#" />
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryVerifySession">
				SELECT
						profileSessionID
				FROM
						pro_ProfileSession
				WHERE
						sessionGuid = '#THIS.SessionGuid#'
						AND userAgent = '#Arguments.UserAgent#'
						AND remoteAddress = '#Arguments.RemoteAddress#'
						AND dateCreated >= DateAdd(hh, -9, getDate())
			</cfquery>
			
			<cfreturn qryVerifySession.RecordCount gt 0 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
	
	</cffunction>
	
	<cffunction name="DeleteSession" access="public" returntype="boolean" hint="Deletes a session when it has been compromised.">
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryDeleteSession">
				DELETE
				FROM
						pro_ProfileSession
				WHERE
						sessionGuid = '#THIS.SessionGuid#'
			</cfquery>
			
			<cfreturn True />
			
			<cfcatch><cfreturn False /></cfcatch>
		
		</cftry>
	
	</cffunction>
	
	<cffunction name="DeleteAllProfileSessions" access="public" returntype="boolean" hint="Deletes all sessions for a specified profile">
		<cfargument name="ProfileID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryDeleteAllProfileSessions">
				DELETE
				FROM
						pro_ProfileSession
				WHERE
						profileID = #Arguments.ProfileID#
			</cfquery>
			
			<cfreturn True />
			
			<cfcatch><cfreturn False /></cfcatch>
		
		</cftry>
		
	</cffunction>
	
	<cffunction name="CreateSession" access="public" returntype="any">
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateSession">
				INSERT
						pro_ProfileSession
						(
							profileID,
							userAgent,
							remoteAddress
						)
				VALUES
						(
							#THIS.ProfileID#,
							'#THIS.UserAgent#',
							'#THIS.RemoteAddress#'
						)
						
				SELECT sessionGuid FROM pro_ProfileSession WHERE profileSessionID = SCOPE_IDENTITY()
			</cfquery>
			
			<cfif qryCreateSession.RecordCount>
				<cfset THIS.SessionGuid = qryCreateSession.sessionGuid />
				<cfreturn True />
			<cfelse>
				<cfreturn False />
			</cfif>
			
			<cfcatch><cfreturn False /></cfcatch>
		
		</cftry>
		
	</cffunction>
	
	<cffunction name="Clear" access="public" returntype="void">
		
		<cfscript>
			
			THIS.UserAgent = NullString;
			THIS.RemoteAddress = NullString;
			THIS.ProfileID = NullInt;
			THIS.FirstName = NullString;
			THIS.LastName = NullString;
			THIS.UserName = NullString;
			THIS.Password = NullString;
			THIS.Salt = NullString;
			THIS.DateCreated = NullDate;
			THIS.IsDeleted = NullBool;
			THIS.RowGuid = NullGuid;
			THIS.EmailAddress = NullString;
			THIS.Address1 = NullString;
			THIS.Address2 = NullString;
			THIS.Address3 = NullString;
			THIS.City = NullString;
			THIS.ProvinceID = NullInt;
			THIS.Province = NullString;
			THIS.CountryID = NullInt;
			THIS.Country = NullString;
			THIS.Phone1 = NullString;
			THIS.Phone2 = NullString;
			THIS.Phone3 = NullString;
			THIS.Fax1 = NullString;
			THIS.Fax2 = NullString;
			THIS.HighestRank = NullInt;
			THIS.DepartmentID = NullInt;
			THIS.IsLocked = False;
			
		</cfscript>
		
	</cffunction>
	
	<cffunction name="LogFailedAttempt" access="public" returntype="void" hint="Logs failed login attempts">
		<cfargument name="UserName" type="string" required="yes" default="#NullString#" />
		
		<!--- Get the profileID. --->
		<cfquery datasource="#DSN#" name="qryGetProfileID">
			SELECT
					profileID
			FROM
					pro_Profile
			WHERE
					userName = '#Arguments.UserName#'
		</cfquery>
		
		<cfif qryGetProfileID.RecordCount>
		
			<!--- Log the attempt. --->
			<cfquery datasource="#DSN#" name="qryLogFailedAttempt">
				INSERT
						pro_ProfileFailedLogin
						(
							profileID,
							remoteAddress,
							browser
						)
				VALUES
						(
							#qryGetProfileID.profileID#,
							'#cgi.REMOTE_ADDR#',
							'#cgi.HTTP_USER_AGENT#'
						)
			</cfquery>
			
			<!--- See how many failed attempts this profile has. --->
			<cfquery datasource="#DSN#" name="qryGetFailedAttemptCount">
				SELECT
						COUNT(profileFailedLoginID) AS NumFailedAttempts
				FROM
						pro_ProfileFailedLogin
				WHERE
						profileID = #qryGetProfileID.profileID#
			</cfquery>
			
			<!--- If this profile has 6 or more failed attempts, lock it. --->
			<cfif qryGetFailedAttemptCount.NumFailedAttempts gte 6>
			
				<cfquery datasource="#DSN#" name="qryLockAccount">
					UPDATE
							pro_Profile
					SET
							isLocked = 1
					WHERE
							profileID = #qryGetProfileID.profileID#
				</cfquery>
			
			</cfif>
		
		</cfif>
		
	</cffunction>

	<!--------------------------------------------------
			
					ADMIN FUNCTIONS
			
	--------------------------------------------------->
	
	<!---
			SessionCount
					Deletes expired sessions and returns the number of users currently logged in.
	--->
	<cffunction name="SessionCount" access="public" returntype="numeric">
	
		<!--- First, let's delete expired sessions. BUG: This seems to log everyone out for some reason. --->
		<!--- <cfquery datasource="#DSN#" name="qryDeleteExpiredSessions">
			DELETE
			FROM
					pro_ProfileSession
			WHERE
					dateCreated < '#DateFormat(DateAdd("h", 10, Now()), "yyyy-mm-dd")#'
		</cfquery> --->
		
		<cfquery datasource="#DSN#" name="qryCountSessions">
			SELECT
					COUNT(profileSessionID) AS numberOfSessions
			FROM
					pro_ProfileSession
		</cfquery>
		
		<cfreturn qryCountSessions.numberOfSessions />
	
	</cffunction>
	
	<cffunction name="Save" access="public" returntype="boolean">
	
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<!--- If this is an existing user, update the records. --->
				<cfif THIS.ProfileID gt NullInt>
				
					<!--- Update the profile info. --->
					<cfquery datasource="#DSN#" name="qryUpdateProfile">
						UPDATE
								pro_Profile
						SET
								userName = '#THIS.UserName#',
								firstName = '#THIS.FirstName#',
								lastName = '#THIS.LastName#',
								departmentID = #THIS.DepartmentID#,
								isLocked = #BitFormat(THIS.IsLocked)#
						WHERE
								profileID = #THIS.ProfileID#
					</cfquery>
					
					<!--- Update the address. --->
					<cfquery datasource="#DSN#" name="qryUpdateAddress">
						UPDATE
								pro_Address
						SET
								address1 = '#THIS.Address1#',
								address2 = '#THIS.Address2#',
								address3 = '#THIS.Address3#',
								city = '#THIS.City#',
								provinceID = #THIS.ProvinceID#,
								postalCode = '#THIS.PostalCode#',
								phone1 = '#THIS.Phone1#',
								phone2 = '#THIS.Phone2#',
								phone3 = '#THIS.Phone3#',
								fax1 = '#THIS.Fax1#',
								fax2 = '#THIS.Fax2#'
						WHERE
								profileID = #THIS.ProfileID#
					</cfquery>
					
					<!--- Update the email address. --->
					<cfquery datasource="#DSN#" name="qryUpdateEmailAddress">
						UPDATE
								pro_Email
						SET
								emailAddress = '#THIS.EmailAddress#'
						WHERE
								profileID = #THIS.ProfileID#
					</cfquery>
				
				<!--- Otherwise, create a new user. --->
				<cfelse>
				
					<cftransaction>
				
						<cfquery datasource="#DSN#" name="qryCreateUser">
							INSERT
									pro_Profile
									(
										firstName,
										lastName,
										userName,
										departmentID,
										homePage
									)
							VALUES
									(
										'#THIS.FirstName#',
										'#THIS.LastName#',
										'#THIS.UserName#',
										#THIS.DepartmentID#,
										70 <!--- In/Out Board --->
									)
							SELECT SCOPE_IDENTITY() AS profileID
						</cfquery>
						
						<cfset THIS.ProfileID = qryCreateUser.profileID />
						
						<cfquery datasource="#DSN#" name="qryCreateAddress">
							INSERT
									pro_Address
									(
										profileID,
										address1,
										address2,
										address3,
										city,
										provinceID,
										countryID,
										postalCode,
										phone1,
										phone2,
										phone3,
										fax1,
										fax2,
										isPrimary,
										isDeleted
									)
							VALUES
									(
										#THIS.ProfileID#,
										'#THIS.Address1#',
										'#THIS.Address2#',
										'#THIS.Address3#',
										'#THIS.City#',
										#THIS.ProvinceID#,
										1,
										'#THIS.PostalCode#',
										'#THIS.Phone1#',
										'#THIS.Phone2#',
										'#THIS.Phone3#',
										'#THIS.Fax1#',
										'#THIS.Fax2#',
										1,
										0
									)
						</cfquery>
						
						<cfquery datasource="#DSN#" name="qryCreateEmail">
							INSERT
									pro_Email
									(
										profileID,
										emailAddress,
										isPrimary,
										isActive
									)
							VALUES
									(
										#THIS.ProfileID#,
										'#THIS.EmailAddress#',
										1,
										1
									)
						</cfquery>
					
					</cftransaction>
				
				</cfif>
			
				<cfreturn True />
				
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
			
		</cfif>
	
	</cffunction>

	<cffunction name="GetAllUsers" access="public" returntype="query">
		<cfargument name="GetDeletedUsers" type="boolean" required="no" default="#NullBool#" />
		<cfargument name="DepartmentID" type="numeric" required="no" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetAllUsers">
			SELECT
					p.profileID,
					p.firstName,
					p.lastName,
					p.isLocked,
					p.departmentID,
					d.department,
					d.rowguid,
					ISNULL((SELECT userStatusID FROM mod_UserStatus WHERE profileID = p.profileID), 0) AS IsProStaff
			FROM
					pro_Profile p LEFT OUTER JOIN
					com_Department d ON p.departmentID = d.departmentID
			WHERE
					1 = 1
					AND isDeleted = #BitFormat(Arguments.GetDeletedUsers)#
					
					<cfif Arguments.DepartmentID gt NullInt>
						AND p.departmentID = #Arguments.DepartmentID#
					</cfif>
			ORDER BY
					p.lastName,
					p.firstName
		</cfquery>
		
		<cfreturn qryGetAllUsers />
		
	</cffunction>
	
	<cffunction name="GetUsersRoles" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetUserRoles">
			SELECT
					r.roleID,
					r.roleName,
					r.roleRanking,
					r.description
			FROM
					pro_ProfileRole pr INNER JOIN
					com_Role r ON pr.roleID = r.roleID
			WHERE
					pr.profileID = #THIS.ProfileID#
					AND pr.siteID = #Application.SiteID#
					AND (pr.expirationDate > getDate() OR pr.expirationDate IS NULL)
		</cfquery>
		
		<cfreturn qryGetUserRoles />
		
	</cffunction>
	
	<cffunction name="GiveUserRole" access="public" returntype="any">
		<cfargument name="RoleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
		
				<cfquery datasource="#DSN#" name="qryGiveUserRole">
					IF NOT EXISTS
					(
						SELECT
								profileRoleID
						FROM
								pro_ProfileRole
						WHERE
								profileID = #THIS.ProfileID#
								AND roleID = #Arguments.RoleID#
								AND siteID = #Application.SiteID#
								AND (expirationDate > getDate() OR expirationDate IS NULL)
					)
					BEGIN
						INSERT
								pro_ProfileRole
								(
									profileID,
									roleID,
									siteID
								)
						VALUES
								(
									#THIS.ProfileID#,
									#Arguments.RoleID#,
									#Application.SiteID#
								)
					END
				</cfquery>
				
				<cfreturn True />
				
				<cfcatch><cfreturn cfcatch.detail/></cfcatch>
			
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="RemoveUserRole" access="public" returntype="any">
		<cfargument name="RoleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryRemoveUserRole">
					DELETE
					FROM
							pro_ProfileRole
					WHERE
							profileID = #THIS.ProfileID#
							AND roleID = #Arguments.RoleID#
							AND siteID = #Application.SiteID#
				</cfquery>
				
				<cfreturn THIS.ProfileID & ' ' & Arguments.RoleID & ' ' & Application.SiteID />
			
				<cfcatch><cfreturn cfcatch.detail /></cfcatch>
			
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>
		
	</cffunction>
		
</cfcomponent>