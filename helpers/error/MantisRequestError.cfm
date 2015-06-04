<!--- Create the object --->
<cfobject component="#Application.Site.SiteHelpers.RequestErrorHandler.cfcPath#" name="Mantis" />
<cfset Mantis.Init(Application.Site.SiteHelpers.RequestErrorHandler.ModuleID) />

<cfset ErrorStruct = StructNew() />

<html>

	<head>
	
		<title>Sorry, Error</title>
		
		<link rel="stylesheet" href="/skins/error.css" />
		
	</head>

	<body>

		<div id="header">
			<p>
				Sorry, an error occurred when you requested this page.
			</p>
		</div>

<cfoutput>
<table cellpadding="0" cellspacing="0" border="0" width="100%" background="##ffffff">
<tr>
	<td width=25%></td>
	<td>
		<p>
			This error has been logged and our Development Team will work to correct the problem. 
			We apologize for the inconvenience.
			
			In the meantime, you can try reloading the page by clicking this link:
		</p>
		
		<p>
			<a href="#Session.BrokenPageURL#">http://#cgi.SERVER_NAME##Session.BrokenPageURL#</a>
		</p>
		<!--
			<!--- Exception: #Session.Exception.Cause.Message# --->
			
		-->
		
</cfoutput>

	</td>
	<td width=25%></td>
</tr>
</table>

<!--- If the browser is not a search engine crawler, let's log the error. --->
<cfif Mantis.isSearchEngine(cgi.HTTP_USER_AGENT) eq False>

	<!--- Input error info into database. If database is down, then email to the email contact on record --->
	<cftry>
	
		<!--- grab the sqltext if there is any --->
		<cfif isDefined("Session.Exception.Cause.sql")>
			<cfset StructInsert(ErrorStruct, "sqlText", Session.Exception.Cause.sql) />
		<cfelse>
			<cfset StructInsert(ErrorStruct, "sqlText", "") />
		</cfif>
	
		<!--- Put the TagContext values into one variable --->
		<cfif IsDefined("Session.Exception.Tagcontext")>
			<cfsavecontent variable="TheTagContext">
				<cfoutput>
					<cfloop from="1" to="#arraylen(Session.Exception.tagcontext)#" index="i">
						<br>
						<cfloop list="#structKeyList(Session.Exception.tagcontext[i])#" index="j">
							<strong>#j#:</strong> #evaluate("Session.Exception.tagcontext[i]." & j)#<br>
						</cfloop>
					</cfloop>
				</cfoutput>
			</cfsavecontent>
			<cfset StructInsert(ErrorStruct, "Tagcontext", TheTagContext, "yes") />
			<cfset StructInsert(ErrorStruct, "Template", Session.Exception.TagContext[1].template) />
		<cfelse>
			<cfset StructInsert(ErrorStruct, "TagContext", "") />
			<cfset StructInsert(ErrorStruct, "Template", "") />
		</cfif>
		
		<!--- Put the FormValues into one variable --->
		<cfif isDefined("Session.FormData") and isDefined("Session.FormData.fieldnames")>
			<cfsavecontent variable="FormValues">
				<cfoutput>
					<cfloop list="#Session.FormData.fieldnames#" index="i">
						<strong>#i#:</strong> #evaluate("Session.FormData." & i)#<br>
					</cfloop>
				</cfoutput>
			</cfsavecontent>
			<cfset StructInsert(ErrorStruct, "FormValues", FormValues) />
		<cfelse>
			<cfset StructInsert(ErrorStruct, "FormValues", "") />
		</cfif>
		
		<cfset StructInsert(ErrorStruct, "Message", Session.Exception.Message) />
		<cfset StructInsert(ErrorStruct, "Detail", Session.Exception.Detail) />
		<cfset StructInsert(ErrorStruct, "ErrorType", Session.Exception.Type) />
		<cfset StructInsert(ErrorStruct, "SiteID", Application.SiteID) />
		<cfset StructInsert(ErrorStruct, "NotificationEmail", "chris.hampton@colostate.edu") />
		
		<cfinvoke component="#Application.Site.SiteHelpers.RequestErrorHandler.cfcPath#" method="CreateError" returnvariable="retVal">
			<cfinvokeargument name="error" value="#ErrorStruct#" />
		</cfinvoke>
		
		<cfset Session.Exception = "" />
		<cfset Session.FormData = "" />
		<cfset Session.BrokenPageURL = "" />
		
		<cfif Session.Exception.Message contains "SITE.SITEHELPERS">
			<cfmail to="chris.hampton@colostate.edu" from="chris.hampton@colostate.edu" subject="Site Helpers Error" type="html">
				<cfdump var="#Application.Site.SiteHelpers#" />
			</cfmail>
		</cfif>
		
		<!--- Email if database insert fails --->
		<cfcatch>
		
			  <cfmail to="#ErrorStruct.NotificationEmail#" subject="Archimedes Web Error" from="#ErrorStruct.NotificationEmail#" type="html">
			
				Hello -- You're receiving this bug report via email because a problem occurred while adding this record to the database.
	
				<style>
					body,p,td {font-family:Arial; font-size:10px;}
				</style>
				
				<cfdump var="#error#" />
				
			</cfmail> 
			
		</cfcatch>
	
	</cftry>

</cfif>

</body>
</html>

<cfabort showerror="no" />