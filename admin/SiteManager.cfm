<cfset qrySiteHelpers = Application.Site.GetSiteHelpersAsQuery(Application.SiteID) />

<cfset SectionID = 4 />

<cfparam name="form.hdnCurrentPanel" default="divSiteInfo" />
<cf_AdminMasterPage SiteName="#Application.Site.SiteName#" PageTitle="Site Manager" UrlRoot="#Application.URLRoot#" SkinPath="#Application.Site.SkinPath#">

	<h3 class="AdminPageTitle">Site Manager</h3>
	
	<div id="divSiteSettings" class="jqAccordian">
	
		<h3 class="jqAccordianHandle" panel="divSiteInfo">Site Info</h3>
		
		<div id="divSiteInfo" class="jqAccordianPanel hidden">
			<form id="frmSiteInfo" action="SiteManager.cfm" method="post">
				<input type="hidden" name="hdnCurrentPanel" value="divSiteInfo" />
				
				Site Info:<br />
				
				<input type="submit" value="Save" />
			</form>
		</div>
		
		<h3 class="jqAccordianHandle" panel="divSiteHelpers">Site Helpers</h3>
		
		<div id="divSiteHelpers" class="jqAccordianPanel hidden">
			<form id="fromSiteHelpers" action="SiteManager.cfm" method="post">
				<input type="hidden" name="hdnCurrentPanel" value="divSiteHelpers">
				
				Site Helpers:<br /><br />
				
				<div id="divSiteHelpers" class="jqSmallAccordian center">
				
					<cfoutput query="qrySiteHelpers">
					
						<h3 class="jqAccordianSmallHandle" title="divHelper#qrySiteHelpers.moduleID#">#qrySiteHelpers.siteSetting#</h3>
						
						<div id="divHelper#qrySiteHelpers.moduleID#" class="jqAccordianPanel hidden">
							foo
						</div>
					
					</cfoutput>
				
				</div>
				
				<br />
				
				<input type="submit" value="Save" />
			</form>
		</div>
		
		<h3 class="jqAccordianHandle" panel="divSiteLayouts">Layouts</h3>
		
		<div id="divSiteLayouts" class="jqAccordianPanel hidden">
			<form id="frmSiteLayouts" action="SiteManager.cfm" method="post">
				<input type="hidden" name="hdnCurrentPanel" value="divSiteLayouts" />
				
				Layouts:<br />
				<input type="submit" value="Save" />
			</form>
		</div>
	
	</div>

	<script type="text/javascript">
		$(function() {
			$.makeAccordian({
				divID: 			'divSiteSettings',
				upSpeed: 		'medium',
				downSpeed: 		'slow',
				handleClass: 	'jqAccordianHandle'
			});
			$.makeAccordian({
				divID: 			'divSiteHelpers',
				upSpeed:		'medium',
				downSpeed: 		'slow',
				handleClass: 	'jqAccordianSmallHandle'
			});
			$("#<cfoutput>#form.hdnCurrentPanel#</cfoutput>").removeClass("hidden");
		});
	</script>

</cf_AdminMasterPage>