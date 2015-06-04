<!--- Call the cfc --->
<cfobject component="#Application.Site.SiteHelpers.Rewriter.cfcPath#" name="Rewriter" />
<cfset Rewriter.Init(Application.SiteID,cgi.SCRIPT_NAME) />

<!--- If this is a valid page, show it --->
<cfif Rewriter.PageID gt 0>
	<cfset pageID = Rewriter.PageID />
	<cfinclude template="page.cfm" />
<cfelse>

	<cfheader statuscode="404" statustext="Page Not Found" />

	<!--- Load the master page. --->
	<cf_MasterPage PageTitle="Page Not Found" SiteKeywords="" PageParentID="0">
	
		<div id="bktContent" class="pageBucket OneColContent span-21 content">

		<h2 id="lblPageName">Oops!</h2>
		
		<div id="pageNotFoundImage">
			<h4>Page Not Found - 404</h4>
		</div>
		
		</div>
		
	</cf_MasterPage>
	
</cfif>