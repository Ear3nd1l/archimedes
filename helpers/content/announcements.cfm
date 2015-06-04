<!---
	THIS MODULE HAS BEEN REPLACED BY THE GLOBAL ANNOUNCEMENTS MODULE.
--->

<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />

<cfobject component="#Attributes.cfcPath#" name="Announcement" />
<cfset Announcement.Init(Attributes.PageModuleID) /> 
<cfset qryAnnouncementItems = Announcement.AnnouncementItems />

<cfif Announcement.IsGlobal>

	<!--- Get the items for the home page --->
	<cfset qryHomePageAnnouncements = Announcement.GetHomePageItems() />
	
	<cfquery dbtype="query" name="qoqCombinedAnnouncements">
		SELECT
				title,
				abstract,
				rowguid,
				startDate,
				endDate
		FROM
				qryAnnouncementItems
				
		UNION
		
		SELECT
				title,
				abstract,
				rowguid,
				startDate,
				endDate
		FROM
				qryHomePageAnnouncements
		
		ORDER BY
				startDate DESC,
				endDate DESC
	</cfquery>
	
	<cfset qryAnnouncementItems = qoqCombinedAnnouncements />

</cfif>

<cfif qryAnnouncementItems.RecordCount>

	<cfoutput>
	
		<div class="divAnnouncements">
		
			<h3 class="moduleHeading">Announcements</h3>
			
			<div id="announcementContainer">
			
				<ul id="ulAnnouncementList">
				
					<cfloop query="qryAnnouncementItems">
						<li title="#qryAnnouncementItems.title#" text="#qryAnnouncementItems.abstract#" announcementID="#qryAnnouncementItems.rowguid#" />
					</cfloop>
				
				</ul>
		
				<div id="divAnnouncements#Attributes.PageModuleID#" class="myScroll">
					<h5 id="announcementTitle" class="announcementTitle">#qryAnnouncementItems.title#</h5>
					<p id="announcementText" class="announcementText">#qryAnnouncementItems.abstract#</p>
					<p id="announcementMore" class="announcementMore" announcementID="#qryAnnouncementItems.rowguid#">Read More...</p>
				</div>
				
			</div>
			
		</div>
		
		<div id="controls">
			<div id="spnPreviousAnnouncement" class="prev">&lt;</div>
			<div id="spnNextAnnouncement" class="next">&gt;</div>
		</div>
	
		<script src="/helpers/content/announcements.js"></script>
		
	</cfoutput>
	
	<div id="divAnnouncementDetails" class="lightBox">
		<div class="scrollOverflow">
			<h5 class="announcementTitle" id="announcementDetailTitle"></h5>
			<p class="announcementDetailText" id="announcmentDetailText"></p>
		</div>
	</div>

</cfif>