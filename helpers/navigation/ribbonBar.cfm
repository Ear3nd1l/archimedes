<cfparam name="Attributes.MenuItems" default="" />
<cfparam name="Attributes.ParentID" default="0" />

<cfobject component="#Application.Site.SiteHelpers.Navigation.cfcPath#" name="RibbonBar" />
<cfset parentMenuItem = RibbonBar.GetParentRibbon(Attributes.ParentID) />

<!--- If the current page is a level 0 item, set the parentMenuItem variable to this page's menuItemID. --->
<cfif parentMenuItem eq 0>

</cfif>

<cfquery dbtype="query" name="qoqGetLevel1Items">
	SELECT
			*
	FROM
			Attributes.MenuItems
	WHERE
			parentID = 0
</cfquery>

<cfquery dbtype="query" name="qoqGetLevel2Items">
	SELECT
			*
	FROM
			Attributes.MenuItems
	WHERE
			parentID <> 0
			AND Depth = 2
</cfquery>

<div id="divRibbonNavigation" class="span-24">

	<div id="ribbonNavigationLeftOverlay"></div>

	<!--- Create the headers --->
	<div class="ribbonHeading">
		<cfoutput query="qoqGetLevel1Items">
			<a href="#qoqGetLevel1Items.redirectPath#" class="ribbonHandle" id="rbnRibbonHandle#qoqGetLevel1Items.menuItemID#" ribbon="rbnRibbon#qoqGetLevel1Items.menuItemID#">#qoqGetLevel1Items.MenuText#</a>
		</cfoutput>
		<div class="clear"></div>
	</div>
	
	<!--- Create the ribbons --->
	<div class="ribbonBar">
		<cfoutput query="qoqGetLevel2Items" group="parentID">
			<ul class="ribbon" id="rbnRibbon#qoqGetLevel2Items.parentID#">
				<cfoutput>
					<li class="ribbonItem" id="rbnRibbonItem#qoqGetLevel2Items.menuItemID#">
						<!--- <img src="#qoqGetLevel2Items.ribbonIcon#" class="ribbonIcon" /> --->
						<a href="#qoqGetLevel2Items.redirectPath#" class="lnkRibbonItemName">#qoqGetLevel2Items.MenuText#</a>
					</li>
				</cfoutput>
				<li class="clear"></li>
			</ul>
		</cfoutput>
	</div>
	
	<div id="ribbonNavigationRightOverlay"></div>

	<div class="clear"></div>

</div>

<cfoutput>

	<script>
		$.makeRibbonBar({
			divID: 				'divRibbonNavigation',
			handleClass: 		'ribbonHandle',
			activeHandleClass: 	'ribbonHandleActive',
			ribbonClass: 		'ribbon',
			defaultHandle: 		'rbnRibbonHandle#Trim(parentMenuItem)#',
			eventType:			'hover'
		});
	</script>

</cfoutput>