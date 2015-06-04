<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />

<cfobject component="#Attributes.cfcPath#" name="FAQ" />
<cfset FAQ.Init(Attributes.PageModuleID) />
<cfset qryItems = FAQ.Items />


<cfoutput>

	<cfif qryItems.RecordCount>

		<h3 class="moduleHeading">FAQ</h3>
		
		<div id="divFAQContainer#Attributes.PageModuleID#">
	
			<cfloop query="qryItems">
			
				<h3 class="jqFAQHandle" panel="divAnswer#qryItems.questionID#">
					#qryItems.question#
					<div id="divAnswer#qryItems.questionID#" class="jqAccordianPanel hidden">#qryItems.answer#</div>
				</h3>
			
			</cfloop>
		
		</div>
		
		<script>
		
			$.makeAccordian({
				divID: 			'divFAQContainer#Attributes.PageModuleID#',
				upSpeed: 		'fast',
				downSpeed: 		'fast',
				handleClass: 	'jqFAQHandle'
			});
	
		</script>
	
	</cfif>

</cfoutput>
