<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />

<cfobject component="#Attributes.cfcPath#" name="BlogEntry" />
<cfset BlogEntry.Init(Attributes.PageModuleID) /> 

<cfoutput>

	<h3 class="blogTitle">#BlogEntry.BlogTitle#</h3>
	
	<h4 class="blogEntryTitle">#BlogEntry.Title#</h4>
	
	<h5 class="blogEntryDate">#DateFormat(BlogEntry.BlogDate, "mmmm dd, yyyy")#</h5>
	
	<div class="blogContent">
		
		#BlogEntry.content#
		
	</div>

</cfoutput>