<cfset qryGetBreadcrumbs = Page.GetBreadcrumbPath() />

	<div id="divBreadcrumbs" class="">
	
		<cfif qryGetBreadcrumbs.RecordCount>
		
			<cfset titles = "" />
			<cfloop query="qryGetBreadcrumbs">
				<cfset titles = Trim(titles) & " " & qryGetBreadcrumbs.pageTitle />
			</cfloop>
		
			
				<!--- If the recordcount is 1, that means this is a level 0 item.  We need to manually include a link to the home page. --->
				<cfif qryGetBreadcrumbs.RecordCount eq 1 OR qryGetBreadcrumbs["redirectPath"][0] neq "/Home.cfm">
					<a href="/Home.cfm" class="lnkBreadcrumbHome">Home</a> &raquo;
				</cfif>
				
				<!--- If total number of combined characters in the titles of the breadcrumb items is greater than 70, it can break the breadcrumb list. Show the first item and then the last. --->
				<cfif Len(Trim(titles)) gt 70>
					<cfoutput>
						<span class="lnkBreadcrumb">...</span>
						<a href="#qryGetBreadcrumbs["redirectPath"][qryGetBreadcrumbs.RecordCount -1]#" class="lnkBreadcrumb">#qryGetBreadcrumbs["pageTitle"][qryGetBreadcrumbs.RecordCount - 1]#</a> &raquo;
						<span class="spnBreadcrumb">#Page.PageTitle#</span>
					</cfoutput>
				
				<!--- Otherwise, output the full list. --->
				<cfelse>
				
					<cfoutput query="qryGetBreadcrumbs">
					
						<cfif qryGetBreadcrumbs.redirectPath eq "/Home.cfm">
							<!---<a href="/Index.cfm" class="lnkBreadcrumbHome">Home</a>--->
						<cfelse>
							<a href="#qryGetBreadcrumbs.redirectPath#" class="lnkBreadcrumb">#qryGetBreadcrumbs.pageTitle#</a> &raquo;
						</cfif>
								
					</cfoutput>
					
					<cfoutput>
						
						<span class="spnBreadcrumb">#Page.PageTitle#</span>
						
					</cfoutput>
					
				</cfif>
			
		
		<cfelse>
			
			<cfoutput>
				<a href="/Home.cfm" class="lnkBreadcrumbHome">Home</a> &raquo; <span class="spnBreadcrumb">#Page.PageTitle#</span>
			</cfoutput>
			
		</cfif>
		
	</div>
	
	<div class="clear"></div>
