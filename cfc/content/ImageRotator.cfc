<cfcomponent extends="ArchimedesCFC.common">

	<cffunction name="GetImages" access="public" returntype="query">
		<cfargument name="MaxRows" type="numeric" required="no" default="-1" />
		
		<cfquery datasource="#DSN#" name="qryGetImages" maxrows="#Arguments.MaxRows#">
			SELECT
					imageID,
					title,
					description,
					imageURL,
					thumbnailPosition
			FROM
					mod_ImageRotator
			WHERE
					dateCreated >= DateAdd(mm, -6, getDate())
			ORDER BY
					newID()
		</cfquery>
		
		<cfreturn qryGetImages />
	
	</cffunction>
	
	<cffunction name="ajaxGetImages" access="remote" returntype="array" returnformat="json">
		
		<cftry>
		
			<!--- Get the images. --->
			<cfset qryImages = GetImages(-1) />
			
			<!--- Create an empty array. --->
			<cfset retArray = ArrayNew(1) />
			
			<!--- If there are images in the set... --->
			<cfif qryImages.RecordCount>
			
				<cfloop query="qryGetImages">
				
					<!--- Create the temporary structure. --->
					<cfset structTemp = StructNew() />
					
					<cfscript>
					
						// Add the values to the temporary structure.
						StructInsert(structTemp, 'title', qryImages.title);
						StructInsert(structTemp, 'description', qryImages.description);
						StructInsert(structTemp, 'imageURL', qryImages.imageURL);
						StructInsert(structTemp, 'thumbnailPosition', qryImages.thumbnailPosition);
						
						// Add the structure to the array.
						ArrayAppend(retArray, structTemp);
					
					</cfscript>
				
				</cfloop>
				
			</cfif>
			
			<cfcatch></cfcatch>
			
		</cftry>
		
		<cfreturn retArray />
		
	</cffunction>
	
	<cffunction name="AddImage" access="public" returntype="boolean">
	
	</cffunction>
	
	<cffunction name="DeleteImage" access="public" returntype="boolean">
	
	</cffunction>

</cfcomponent>