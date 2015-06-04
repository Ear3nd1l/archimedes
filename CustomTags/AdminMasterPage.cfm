<cfparam name="Attributes.SiteName" default="" />
<cfparam name="Attributes.PageTitle" default="Home" />
<cfparam name="Attributes.SiteKeywords" default="" />
<cfparam name="Attributes.URLRoot" default="" />
<cfparam name="Attributes.SkinPath" default="" />
<cfparam name="Attributes.HelperPath" default="" />
<cfparam name="Attributes.CodeBehind" default="" />
<cfparam name="Caller.SectionID" default="1" />

<cfif ThisTag.ExecutionMode IS 'Start'>

	<cfobject component="ArchimedesCFC.error.mantis" name="BugManager" />
	<cfset qryErrorCounts = BugManager.GetErrorCount() />

	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			
			<cfoutput>
				<title>#Attributes.PageTitle# - #Attributes.SiteName#</title>
				
				<link rel="stylesheet" href="#Attributes.URLRoot#skins/admin.css" />
				<link rel="stylesheet" href="#Attributes.URLRoot#skins/adminLayouts.css" />
				<link rel="stylesheet" href="#Attributes.URLRoot#skins/jquery-ui.custom.css" />

				<script type="text/javascript" src="#Attributes.URLRoot#jQuery/jquery-1.3.2.min.js"></script>
				<script type="text/javascript" src="#Attributes.URLRoot#jQuery/jquery-ui-1.7.2.custom.min.js"></script>
				<script type="text/javascript" src="#Attributes.URLRoot#jQuery/jScrollPane-1.2.3.min.js"></script>
				<script type="text/javascript" src="#Attributes.URLRoot#jQuery/jquery.common.js"></script>
				<script type="text/javascript" src="#Attributes.URLRoot#jQuery/jquery.corners.min.js"></script>
				<script type="text/javascript" src="#Application.UrlRoot#jQuery/jquery.tablesorter.min.js"></script>
				
				<!--- Output the values for the URLRoot and Helper Path into javascript. --->
				<script type="text/javascript">
				
					var URLRoot = '#Attributes.URLRoot#';
					var HelperPath = '#Attributes.HelperPath#';
					$(function() {
						$('.roundCorners').corners('10px');
					});
				
				</script>
			</cfoutput>
		</head>
		
		<body>
			<cfoutput>
				<div id="divNavigation">
					<ul id="lstAdminNavigation">
						<li class="<cfif Caller.SectionID eq 1>liActiveNavigationItem<cfelse>liNavigationItem</cfif> textShadow"><a href="#Attributes.URLRoot#Admin/">Admin Home</a></li>
						<li class="<cfif Caller.SectionID eq 2>liActiveNavigationItem<cfelse>liNavigationItem</cfif> textShadow"><a href="#Attributes.URLRoot#Admin/PageManager.cfm">Manage Pages</a></li>
						<li class="<cfif Caller.SectionID eq 3>liActiveNavigationItem<cfelse>liNavigationItem</cfif> textShadow"><a href="#Attributes.URLRoot#Admin/FileManager/FileManager.cfm">Manage Files</a></li>
						<li class="<cfif Caller.SectionID eq 4>liActiveNavigationItem<cfelse>liNavigationItem</cfif> textShadow"><a href="#Attributes.URLRoot#Admin/SiteManager.cfm">Manage Modules</a></li>
						<li class="<cfif Caller.SectionID eq 5>liActiveNavigationItem<cfelse>liNavigationItem</cfif> textShadow"><a href="#Attributes.URLRoot#Admin/UserManager/">Manage Users</a></li>
					</ul>
					<img src="#Attributes.URLRoot#Admin/images/archimedesLogo.jpg" id="imgArchimedesLogo" />
					<div class="clear"></div>
				</div>
				<div id="divSeparatorBar"></div>
			
				<div id="divContent" style="float: left; width: 1100px; padding-left: 10px;">
				
					<div id="leftColumn">
					
						<div id="admCalendarPanel" class="sidebarPanel rounded shadow">
						
							<h3 id="timeLabel">#TimeFormat(now(), "h:mm")#</h3>
							
							<p id="dayLabel">#DateFormat(now(), "dddd mmmm dd, yyyy")#</p>
							
							<cfinclude template="/admin/includes/calendar.cfm" />
						
						</div>
						
						<div id="admEventsPanel" class="subPanel rounded shadow">
						
						</div>
						
						<div id="admStatsPanel" class="sidebarPanel rounded shadow">
						
							<h3>Statistics</h3>
						
							<p>There are currently #Session.Profile.SessionCount()# users logged in.</p>
							
							<p>Bugs Today: #qryErrorCounts.todaysErrors#</p>
							
							<p>Bugs Total: #qryErrorCounts.totalErrors#</p>
							
							<p><a href="#Attributes.URLRoot#Admin/BugManager/Index.cfm">Bug Manager</a></p>
			
						</div>
					
					</div>
					
					<div id="rightColumn">
					
				</cfoutput>


<cfelseif ThisTag.ExecutionMode IS 'END'>

			
					</div>
		
				</div>
			
			<cfif Len(Trim(Attributes.CodeBehind)) gt 0>
				<cfoutput>
					<script src="#Attributes.CodeBehind#"></script>
				</cfoutput>
			</cfif>
			
			<div style="clear:both;"></div>
			
			<script>
			
				$(function() {
					setInterval(function() {
						
						var currentTime = new Date();
						var h = currentTime.getHours();
						var m = currentTime.getMinutes();
						
						if(h > 12)
						{
							h = h - 12;
						}
						
						if(m < 10)
						{
							m = '0' + m;
						}
						
						if(h == 0)
						{
							h = '12';
						}
						
						$('#timeLabel').text(h + ':' + m);
						
					}, 1000);
				});
			
			</script>
			
		</body>
		
	</html>
	
</cfif>