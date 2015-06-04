<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />

<cfobject component="#Attributes.cfcPath#" name="Blog" />
<cfset Blog.Init(Attributes.PageModuleID) /> 

<cfoutput>

	<cfset qryBlogEntries = Blog.BlogEntries() />
	
	<cfif Blog.ShowSummary>
	
		<cfif qryBlogEntries.RecordCount>
		
			<cfloop query="qryBlogEntries">
			
				<h3 class="lnkBlogEntryTitle"><a href="#qryBlogEntries.redirectPath#">#qryBlogEntries.title#</a></h3>
			
				<!--- Get the first paragraph --->
				<cfset firstParagraph = ListGetAt(qryBlogEntries.content, 1, "#chr(13)#") />
				
				<!--- Try to get the second paragraph if it exists --->
				<cftry>
					<cfset abstract = firstParagraph & ListGetAt(qryBlogEntries.content, 2, "#chr(13)#") />
					<cfcatch>
						<cfset abstract = firstParagraph />
					</cfcatch>
				</cftry>
	
				<div class="blogAbstract">
					#abstract#
				</div>
			
				<p class="blogMore"><a href="#qryBlogEntries.redirectPath#">More...</a></p>
			
				<p class="blogInfo">Posted on #DateFormat(qryBlogEntries.blogDate, "mmmm dd, yyyy")#</p>

			</cfloop>
		
		<cfelse>
		
			<p>This blog has no entries.</p>
		
		</cfif>
	
	<cfelse>
	
		<cfif qryBlogEntries.RecordCount>
		
			<h3 class="moduleHeading">#Blog.BlogTitle#</h4>
		
			<ul class="ulBlogEntryList">
		
				<cfloop query="qryBlogEntries">
				
					<li><a href="#qryBlogEntries.redirectPath#" class="lnkBlogEntry">#qryBlogEntries.title#</a></li>
				
				</cfloop>
			
			</ul>
		
		<cfelse>
		
			<p>This blog has no entries.</p>
		
		</cfif>
	
	</cfif>

</cfoutput>