<cfoutput query="Page.PageBuckets">

	<!--- Get the modules for this bucket from the existing query of page modules. --->
	<cfquery dbtype="query" name="qoqBucketModules">
		SELECT
				pageModuleID,
				controlPath,
				cfcPath,
				rowguid
		FROM
				Page.PageModules
		WHERE
				bucketID = #Page.PageBuckets.bucketID#
		ORDER BY
				sortOrder
	</cfquery>

	<!--- Create the bucket --->
	<div id="#Page.PageBuckets.divName#" class="pageBucket #Page.PageBuckets.additionalClasses#">
		
		<!--- Loop through the modules and load their control template. --->
		<cfloop query="qoqBucketModules">
		
			<div id="bucketModule#qoqBucketModules.pageModuleID#" class="#Page.PageBuckets.divName#_ModuleContainer">
				
				<cfif IsPageEditor>
					<span class="lnkEditContent" uuid="#qoqBucketModules.rowguid#">Edit</span>
				</cfif>
					
				<cfmodule template="#qoqBucketModules.controlPath#" pageModuleID="#qoqBucketModules.pageModuleID#" cfcPath="#qoqBucketModules.cfcPath#">
			
			</div>
			
			<div class="clear"></div>
		
		</cfloop>
		
	</div>

</cfoutput>