<!---
page purpose:  Calls templates depending on the action passed in
variables to run page:  none
other notes:  none
cfcs: Mantis.cfc
custom tags: none
stored procedures: none
Original author: Kristian Ranstrom
--->

<cfinclude template="app_Locals.cfm" />

<cfparam name="action" default="ListOptions">
<cfparam name="displayMessage" default="">
<cfsetting requesttimeout="1000">

<!DOCTYPE HTML PUBLIC "-//W3C//Dtd HTML 4.01 Transitional//EN" "http://www.w3.org/tr/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Bug Manager</title>
<script src="common.js"></script>
<link href="styles.css" rel="stylesheet" rel="text/css" />
</head>

<body>

<!--- Header for all pages --->
<h3>Bug Manager</h3>

<a href="/Admin/">Back to Dashboard</a>


<cfswitch expression="#action#">

	<cfcase value="ListOptions">
		<cfinclude template="dsp_ListOptions.cfm">
	</cfcase>	

	<cfcase value="ListBugs">
		<cfinclude template="dsp_ListBugs.cfm">
	</cfcase>	

	<cfcase value="SaveBugs">
		<cfinclude template="act_SaveBugs.cfm">
	</cfcase>	
	
	<cfcase value="ViewBug">
		<cfinclude template="dsp_thisBug.cfm">
	</cfcase>	
	
	<cfdefaultcase>
		<cfinclude template="dsp_ListOptions.cfm">
	</cfdefaultcase>
	
</cfswitch>

</body>
</html>