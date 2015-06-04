<cfset MinimumRank = 9 />
<cfinclude template="#Application.HelperPath#/admin/verifyAccess.cfm" />

<cfset SectionID = 2 />

<cfobject component="ArchimedesCFC.pageTemplateCollection" name="PageTemplates" />
<cfset PageTemplates.Init(Application.SiteID) />

<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="Create Page Wizard" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#" HelperPath="#Application.HelperPath#" CodeBehind="CreatePage.js">

	<p>Please choose from a Page Template below to begin.</p>

	<cfoutput>
	
		<cfloop from="1" to="#PageTemplates.Count#" index="i">
			<cfset PageTemplate = PageTemplates.GetAt(i) />
			<cfset qryTemplateModules = PageTemplate.TemplateModules />
			
			<div class="divPageTemplate" PageTemplateID="#PageTemplate.TemplateID#">
			
				<!--- Show the template name and description --->
				<h3 class="templateName">#PageTemplate.TemplateName#</h3>
				<p class="templateDescription">#PageTemplate.description#</p>
				
				<!--- Show the default template layout --->
				<cfif PageTemplate.LayoutID gt NullInt>
					<div class="divLayoutOptions">
						<img src="#Application.URLRoot#admin/images/Layouts/layoutIconLargeLayout#PageTemplate.layoutID#.png" width="100" height="100" border="0" class="imgLayoutIconPageWizard" />
						<div class="layoutOptionsPageWizard">
							<p class="layoutName">#PageTemplate.LayoutName#</p>
							<p class="layoutDescription">#PageTemplate.LayoutDescription#</p>
						</div>
					</div>
				</cfif>
				
				<div class="clearWithMargin">&nbsp;</div>
	
				<!--- Output the modules --->
				<cftry>
					<cfif qryTemplateModules.RecordCount>
						<h4>Default Modules</h4>
						<p style="margin-bottom: 0px; font-weight: bold;">The following modules are included in the Page Template:</p>
						<cfloop query="qryTemplateModules">
							#qryTemplateModules.moduleName#<br />
						</cfloop>
					</cfif>
					<cfcatch></cfcatch>
				</cftry>
				
			</div>
			
		</cfloop>
		
	</cfoutput>
	
</cf_AdminMasterPage>