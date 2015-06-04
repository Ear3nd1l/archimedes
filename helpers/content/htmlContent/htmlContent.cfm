<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />
 
<cfobject component="#Attributes.cfcPath#" name="Content" />
<cfset Content.Init(Attributes.PageModuleID) /> 

<cfoutput>

	<cfif Len(Content.Title) gt 0>
		<p class="htmlModuleTitle">#Content.Title#</p>
	</cfif>
	
	<p class="htmlModuleContent">#Content.Content#</p>
	
</cfoutput>