<cfcomponent extends="ArchimedesCFC.modules.pageModule">

	<cfparam name="THIS.AnnouncementBannerID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.Title" default="#NullString#" type="string" />
	<cfparam name="THIS.IsGlobal" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.AnnouncementItems" type="query" default="#GetItems()#" />
	
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			MapData(GetByPageModuleID(Arguments.Value));
			GetItems();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.AnnouncementBannerID = GetInt(Arguments.qryData.announcementBannerID);
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.Title = GetString(Arguments.qryData.title);
				THIS.IsGlobal = GetBool(Arguments.qryData.isGlobal);
			
			</cfscript>
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetByPageModuleID" access="public" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetByPageModuleID">
			SELECT
					announcementBannerID,
					pageModuleID,
					title,
					isGlobal
			FROM
					mod_AnnouncementBanner
			WHERE
					pageModuleID = #Arguments.PageModuleID#
		</cfquery>
		
		<cfreturn qryGetByPageModuleID />
	
	</cffunction>
	
	<cffunction name="GetItems" access="public" returntype="query">
		<cfargument name="RowGuid" type="string" required="no" default="#NullGuid#" />
		<cfargument name="OrderBy" type="string" required="no" default="a.startDate DESC,a.endDate DESC" />
		<cfargument name="AnnouncementID" type="numeric" required="no" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetItems">
			SELECT
					a.announcementID,
					a.title,
					a.abstract,
					a.text,
					a.rowguid,
					a.startDate,
					a.endDate,
					ai.iconURL
			FROM
					mod_Announcement a LEFT OUTER JOIN
					mod_AnnouncementIcon ai ON a.announcementIconID = ai.announcementIconID
			WHERE
					1 = 1
					<cfif Arguments.RowGuid NEQ NullGuid>
						AND a.rowguid = '#Arguments.RowGuid#'
					<cfelseif Arguments.AnnouncementID gt NullInt>
						AND a.announcementID = #Arguments.AnnouncementID#
					<cfelse>
						AND a.isDeleted = 0
						AND a.announcementBannerID = #THIS.announcementBannerID#
						AND a.startDate <= getDate()
						AND a.endDate >= getDate()
					</cfif>
			ORDER BY
					#Arguments.OrderBy#
					
		</cfquery>
		
		<cfset THIS.AnnouncementItems = qryGetItems />
		
		<cfreturn qryGetItems />
		
	</cffunction>
	
	<cffunction name="AdminGetItems" access="public" returntype="query">
		<cfargument name="RowGuid" type="string" required="no" default="#NullGuid#" />
		
		<cfquery datasource="#DSN#" name="qryGetItems">
			SELECT
					a.announcementID,
					a.title,
					a.abstract,
					a.text,
					a.rowguid,
					a.startDate,
					a.endDate,
					ai.iconURL,
					a.showOnHomePage
			FROM
					mod_Announcement a LEFT OUTER JOIN
					mod_AnnouncementIcon ai ON a.announcementIconID = ai.announcementIconID
			WHERE
					1 = 1
					AND a.announcementBannerID = #THIS.announcementBannerID#
					AND a.isDeleted = 0
			ORDER BY
					a.startDate DESC,
					a.endDate DESC
		</cfquery>
		
		<cfset THIS.AnnouncementItems = qryGetItems />
		
		<cfreturn qryGetItems />
		
	</cffunction>

	<cffunction name="GetHomePageItems" access="public" returntype="query">
		<cfargument name="OrderBy" type="string" required="no" default="a.startDate DESC,a.endDate DESC" />
	
		<cfquery datasource="#DSN#" name="qryGetItems">
			SELECT
					a.announcementID,
					a.title,
					a.abstract,
					a.text,
					a.rowguid,
					a.startDate,
					a.endDate,
					ai.iconURL
			FROM
					mod_Announcement a LEFT OUTER JOIN
					mod_AnnouncementIcon ai ON a.announcementIconID = ai.announcementIconID
			WHERE
					a.isDeleted = 0
					AND a.startDate <= getDate()
					AND a.endDate >= getDate()
					AND a.showOnHomePage = 1
			ORDER BY
					#Arguments.OrderBy#
		</cfquery>
		
		<cfreturn qryGetItems />

	</cffunction>

	<cffunction name="CreateDefaultPageModule" access="public" returntype="boolean">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateDefaultPageModule">
				INSERT
						mod_AnnouncementBanner
						(
							pageModuleID,
							title
						)
				VALUES
						(
							#Arguments.PageModuleID#,
							'Announcements'
						)
				SELECT SCOPE_IDENTITY() AS announcementBannerID
			</cfquery>
			
			<cfreturn qryCreateDefaultPageModule.RecordCount eq 1 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
	</cffunction>
	
	<cffunction name="ajaxGetAnnouncement" access="remote" returntype="struct" returnformat="json">
		<cfargument name="AnnouncementID" type="string" required="yes" default="#NullGuid#" />
		
		<cfif IsGuid(Arguments.AnnouncementID)>
		
			<cfinvoke method="GetItems" returnvariable="qryGetAnnouncement">
				<cfinvokeargument name="RowGuid" value="#Arguments.AnnouncementID#" />
			</cfinvoke>
			
			<cfset retStruct = StructNew() />
			
			<cfif qryGetAnnouncement.RecordCount>
			
				<cfscript>
				
					StructInsert(retStruct, "title", qryGetAnnouncement.title);
					StructInsert(retStruct, "text", qryGetAnnouncement.text);
				
				</cfscript>
			
			</cfif>
			
			<cfreturn retStruct />
		
		<cfelse>
			<cfreturn StructNew() />
		</cfif>
		
	</cffunction>
	
	<cffunction name="CreateAnnouncement" access="public" returntype="any">
		<cfargument name="AnnouncementBannerID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Title" type="string" required="yes" default="#NullString#" />
		<cfargument name="Abstract" type="string" required="yes" default="#NullString#" />
		<cfargument name="Text" type="string" required="yes" default="#NullString#" />
		<cfargument name="StartDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="EndDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="ShowOnHomePage" type="boolean" required="yes" default="#NullBool#" />
		<cfargument name="AnnouncementIconID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
				<cfquery datasource="#DSN#" name="qryCreateAnnouncement">
					INSERT
							mod_Announcement
							(
								announcementBannerID,
								title,
								abstract,
								text,
								startDate,
								endDate,
								showOnHomePage,
								announcementIconID
							)
					VALUES
							(
								#Arguments.AnnouncementBannerID#,
								'#Arguments.Title#',
								'#Arguments.Abstract#',
								'#Arguments.Text#',
								'#DateFormat(Arguments.StartDate, "yyyy-mm-dd")#',
								'#DateFormat(Arguments.EndDate, "yyyy-mm-dd")#',
								#BitFormat(Arguments.ShowOnHomePage)#,
								#Arguments.AnnouncementIconID#
							)
				</cfquery>
				
				<cfreturn True />
			
			<cfelse>
			
				<cfreturn False />
				
			</cfif>
		
			<cfcatch><cfreturn cfcatch.Message /></cfcatch>
			
		</cftry>
		
	</cffunction>
	
	<cffunction name="EditAnnouncement" access="public" returntype="boolean">
		<cfargument name="AnnouncementID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Title" type="string" required="yes" default="#NullString#" />
		<cfargument name="Abstract" type="string" required="yes" default="#NullString#" />
		<cfargument name="Text" type="string" required="yes" default="#NullString#" />
		<cfargument name="StartDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="EndDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="ShowOnHomePage" type="boolean" required="yes" default="#NullBool#" />
		<cfargument name="AnnouncementIconID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
				<cfquery datasource="#DSN#" name="qryEditAnnouncement">
					UPDATE
							mod_Announcement
					SET
							title = '#Arguments.Title#',
							abstract = '#Arguments.Abstract#',
							text = '#Arguments.Text#',
							startDate = '#DateFormat(Arguments.StartDate, "yyyy-mm-dd")#',
							endDate = '#DateFormat(Arguments.EndDate, "yyyy-mm-dd")#',
							showOnHomePage = #BitFormat(Arguments.ShowOnHomePage)#,
							announcementIconID = #Arguments.AnnouncementIconID#
					WHERE
							announcementID = #Arguments.AnnouncementID#
				</cfquery>
				
				<cfreturn True />
			
			<cfelse>
			
				<cfreturn False />
			
			</cfif>

			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
	
	</cffunction>
	
	<cffunction name="DeleteAnnouncement" access="public" returntype="boolean">
		<cfargument name="AnnouncementID" type="numeric" required="yes" default="#NullInt#" />

		<cftry>

			<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
					
				<cfquery datasource="#DSN#" name="qryEditAnnouncement">
					UPDATE
							mod_Announcement
					SET
							isDeleted = 1
					WHERE
							announcementID = #Arguments.AnnouncementID#
				</cfquery>
				
				<cfreturn True />
			
			<cfelse>
			
				<cfreturn False />
				
			</cfif>

			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>

	</cffunction>
	
	<cffunction name="ajaxEditAnnouncement" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="AnnouncementID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Title" type="string" required="yes" default="#NullString#" />
		<cfargument name="Abstract" type="string" required="yes" default="#NullString#" />
		<cfargument name="Text" type="string" required="yes" default="#NullString#" />
		<cfargument name="StartDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="EndDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="ShowOnHomePage" type="boolean" required="yes" default="#NullBool#" />
		<cfargument name="AnnouncementIconID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfinvoke method="EditAnnouncement" returnvariable="retVal">
			<cfinvokeargument name="AnnouncementID" value="#Arguments.AnnouncementID#" />
			<cfinvokeargument name="Title" value="#Arguments.Title#" />
			<cfinvokeargument name="Abstract" value="#Arguments.Abstract#" />
			<cfinvokeargument name="Text" value="#Arguments.Text#" />
			<cfinvokeargument name="StartDate" value="#Arguments.StartDate#" />
			<cfinvokeargument name="EndDate" value="#Arguments.EndDate#" />
			<cfinvokeargument name="ShowOnHomePage" value="#Arguments.ShowOnHomePage#" />
			<cfinvokeargument name="AnnouncementIconID" value="#Arguments.AnnouncementIconID#" />
		</cfinvoke>
		
		<cfreturn retVal />
	
	</cffunction>

	<cffunction name="ajaxCreateAnnouncement" access="remote" returntype="any" returnformat="json">
		<cfargument name="AnnouncementBannerID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Title" type="string" required="yes" default="#NullString#" />
		<cfargument name="Abstract" type="string" required="yes" default="#NullString#" />
		<cfargument name="Text" type="string" required="yes" default="#NullString#" />
		<cfargument name="StartDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="EndDate" type="date" required="yes" default="#NullDate#" />
		<cfargument name="ShowOnHomePage" type="boolean" required="yes" default="#NullBool#" />
		<cfargument name="AnnouncementIconID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfinvoke method="CreateAnnouncement" returnvariable="retVal">
			<cfinvokeargument name="AnnouncementBannerID" value="#Arguments.AnnouncementBannerID#" />
			<cfinvokeargument name="Title" value="#Arguments.Title#" />
			<cfinvokeargument name="Abstract" value="#Arguments.Abstract#" />
			<cfinvokeargument name="Text" value="#Arguments.Text#" />
			<cfinvokeargument name="StartDate" value="#Arguments.StartDate#" />
			<cfinvokeargument name="EndDate" value="#Arguments.EndDate#" />
			<cfinvokeargument name="ShowOnHomePage" value="#Arguments.ShowOnHomePage#" />
			<cfinvokeargument name="AnnouncementIconID" value="#Arguments.AnnouncementIconID#" />
		</cfinvoke>
		
		<cfreturn retVal />
	
	</cffunction>
	
	<cffunction name="ajaxDeleteAnnouncement" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="AnnouncementID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfinvoke method="DeleteAnnouncement" returnvariable="retVal">
			<cfinvokeargument name="AnnouncementID" value="#Arguments.AnnouncementID#" />
		</cfinvoke>
		
		<cfreturn retVal />
		
	</cffunction>

</cfcomponent>