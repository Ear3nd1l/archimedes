<cfparam name="Attributes.PageTitle" default="Home" />
<cfparam name="Attributes.PageParentID" default="" />
<cfparam name="Attributes.SiteKeywords" default="" />

<cfif ThisTag.ExecutionMode IS 'Start'>

	<cfoutput>
	
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<title>#Attributes.PageTitle# - #Application.Site.SiteName#</title>
				<meta name="keywords" content="#Application.Site.SiteKeywords#, #Attributes.SiteKeywords#" />
				<link rel="stylesheet" href="#Application.UrlRoot#skins/layouts.css" />
				<link rel="stylesheet" href="#Application.Site.SkinPath#/base.css" />
				<!--[if lt IE 8]><link rel="stylesheet" href="#Application.Site.SkinPath#/ie.css" /><![endif]-->
				<link rel="stylesheet" href="#Application.Site.SkinPath#/print.css" media="print" />
				<link rel="stylesheet" href="#Application.URLRoot#skins/jquery-ui.custom.css" />

				<script type="text/javascript" src="#Application.UrlRoot#jQuery/jquery-1.3.2.min.js"></script>
				<script type="text/javascript" src="#Application.UrlRoot#jQuery/jquery-ui-1.7.2.custom.min.js"></script>
				<script type="text/javascript" src="#Application.URLRoot#jQuery/ifx/ifx.js"></script>
				<script type="text/javascript" src="#Application.UrlRoot#jQuery/jquery.common.js"></script>
				<script type="text/javascript" src="#Application.UrlRoot#jQuery/mbScrollable.min.js"></script>
				<script type="text/javascript" src="#Application.UrlRoot#jQuery/jquery.tablesorter.min.js"></script>

				<!--- Output the values for the URLRoot into javascript. --->
				<script type="text/javascript">
				
					var URLRoot = '#Application.UrlRoot#';
				
				</script>

			</head>
			
			<body>
			
				<div class="container"> 
				
					
					<div id="header" class="span-24 last">
					
						<h1>#Application.Site.SiteName#</h1>

						<a href="http://www.colostate.edu" id="csuLogo">Colorado State University</a>
						
					</div>
					
					<cflock scope="application" type="readonly" timeout="10">
					
						<!--- Call the navigation module. --->
						<cfmodule template="#Application.Site.SiteHelpers.Navigation.controlPath#" MenuItems="#Application.Site.MenuItems()#" ParentID="#Attributes.PageParentID#"> 
						
						
						<cftry>
						
							<hr class="space" />
							
							<!--- Include the image rotator. --->
							<cfinclude template="#Application.Site.SiteHelpers.ImageRotator.controlPath#" />
							<div class="showShadow"></div>
							
							<cfcatch></cfcatch>
							
						</cftry>
						
						<cftry>
						
							<hr class="space" />
							
							<!--- Include the global announcements. --->
							<cfinclude template="#Application.Site.SiteHelpers.GlobalAnnouncements.controlPath#" />
							<div class="showShadow"></div>
							
							<cfcatch></cfcatch>
						
						</cftry>
					
					</cflock>
					
	</cfoutput>

<cfelseif ThisTag.ExecutionMode IS 'END'>

					<hr class="space clear" />
					
					<div id="footerContent">
					
						<div id="footerImageLinks">
							<a href="http://glbtss.colostate.edu/" id="glbtIcon">GLBT Safe Zone</a>
							<a href="http://www.campaign.colostate.edu/" id="campaignIcon">The Campaign For Colorado State University</a>
							<a href="https://advancing.colostate.edu/SA/CLUBSPORTS" id="donateSportClubsIcon">Donate to Sport Clubs Online</a>
						</div>
						
						<div id="csuLinks">
							<a href="http://admissions.colostate.edu">Apply to CSU</a>
							<a href="http://www.colostate.edu/info-contact.aspx">Contact CSU</a>
							<a href="http://www.colostate.edu/info-disclaimer.aspx">Disclaimer</a>
							<a href="http://www.colostate.edu/info-equalop.aspx">Equal Opportunity</a>
							<a href="http://www.colostate.edu/info-privacy.aspx">Privacy Statement</a>
			
							&copy; <cfoutput>#DateFormat(Now(), "yyyy")#</cfoutput> CSU Campus Recreation
						</div>

						
						<cfoutput>
						
							<!--- If the user is logged in, show their control panel. --->
							<cfif isDefined("Session.Profile") AND Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
							
								<div id="divControlPanel" class="cPanelSlider">
							
									<span class="userWelcomeMessage">Welcome #Session.Profile.FirstName# #Session.Profile.LastName#.</span>
									<a href="/Intranet/InOutBoard.cfm" class="userActionLink">In/Out Board</a>
									<a href="/Admin/" class="userActionLink">Dashboard</a>
									<a href="/logout.cfm" class="userActionLink">Logout</a>
									
									<div class="cPanelTab" panel="divControlPanel">&nbsp;</div>
									
								</div>
									
							<!--- Otherwise, show the login form. --->
							<cfelse>
							
								<div id="divLoginForm" class="cPanelSlider">
									<form method="post" action="/Registration/LoginProcessor.cfm">
										<div class="loginFormRow">
											<label for="txtUserName" class="loginFormLabel">Username:</label>
											<input type="text" name="txtUserName" id="txtUserName" autocomplete="Off" />
										</div>
										<div class="loginFormRow">
											<label for="txtPassword" class="loginFormLabel">Password:</label>
											<input type="password" name="txtPassword" id="txtPassword" autocomplete="Off" />
										</div>
										<div class="loginFormRow">
											<input type="submit" value="Login" name="btnSubmit" id="btnSubmit" />
										</div>
										<input type="hidden" name="hdnReturnUrl" value="<cfoutput>#cgi.SCRIPT_NAME#</cfoutput>" />
									</form>
									
									<div class="cPanelTab" panel="divLoginForm">&nbsp;</div>
									
								</div>
								
							</cfif>
						
						</cfoutput>
						
					</div>
					
				</div>

				<!--- Google Analytics --->
				<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
				<script type="text/javascript">
					_uacct = "UA-379210-2";
					urchinTracker();
				</script>

		</body>
		
	</html> 
	
</cfif>