<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />

<cfobject component="#Attributes.cfcPath#" name="QuickLinks" />
<cfset QuickLinks.Init(Attributes.PageModuleID) /> 
<cfset qryQuickLinksItems = QuickLinks.QuickLinksItems />

<cfif qryQuickLinksItems.RecordCount>

	<cfoutput>
	
		<h3 class="moduleHeading">#QuickLinks.Title#</h3>
		
		<ul class="linkList">
		
			<cfloop query="qryQuickLinksItems">
			
				<li class="liQuickLink"><a href="#qryQuickLinksItems.url#" class="lnkQuickLink" <cfif qryQuickLinksItems.isNewWindow eq 1>target="_blank"</cfif>>#qryQuickLinksItems.linkText#</a></li>
			
			</cfloop>
		
		</ul>
		
	</cfoutput>

</cfif>