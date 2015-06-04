<!--- Create the object --->
<cfobject component="#PageModule.cfcPath#" name="Blog" />
<cfset Blog.Init(PageModule.PageModuleID) />
<cfset qryBlogEntries = Blog.BlogEntries() />

<!--- If we are creating a new blog, include the editor. --->
<cfif url.fuseaction eq "CreateBlogEntry">

	<cfinclude template="blogEntryCreate.cfm" />

<cfelse>

	<cfif IsDefined("url.BlogEntryID")>
	
		<cfset BlogEntry = Blog.GetModuleByName("Blog Entry Viewer") />
		<cfset BlogEntry.Init(BlogEntryID=url.BlogEntryID) />
		
		<cfif IsPostback>
		
			<cfscript>
			
				// Create the object
				Validate = CreateObject("component", "ArchimedesCFC.validate");
				
				// Trim the form fields
				Validate.TrimStruct(form);
				
				if(IsEmpty(form.txtTitle)) Validate.ErrorMsg(Message="Title is required.", FormField="txtTitle");
				if(IsEmpty(form.txtBlogDate)) Validate.ErrorMsg(Message="Blog Date is required.", FormField="txtBlogDate");
				if(NOT IsDate(form.txtBlogDate)) Validate.ErrorMsg(Message="Blog Date is invalid.", FormField="txtBlogDate");
				if(IsEmpty(form.txtaContent)) Validate.ErrorMsg(Message="Content is required.", FormField="txtContent");
				
				/* 
					Save the form values to the object.
					If there are validation errors, this will preserve the entered content for the form.
				*/
				BlogEntry.Title = form.txtTitle;
				BlogEntry.BlogDate = form.txtBlogDate;
				BlogEntry.Content = form.txtaContent;
				
				// If the form is valid, save the object.
				if(Validate.IsValidForm())
				{
					BlogEntry.Save();
				}
			
			</cfscript>
			
			<!--- If there were errors, show the list. --->
			<cfif Validate.IsValidForm eq False>
			
				<p><cfoutput>#Validate.GetErrors()#</cfoutput></p>
			
			<!--- Otherwise, return to the index. --->
			<cfelse>
			
				<script>
					$(function() {
						location.href = 'adminPageConfigEditor.cfm?pageModuleID=' + PageModuleID;
					});
				</script>
			
			</cfif>
		
		</cfif>
		
		<cfoutput>
		
		
			<cfform action="adminPageConfigEditor.cfm?pageModuleID=#PageModule.PageModuleID#&BlogEntryID=#qryBlogEntries.blogEntryID#" method="post" name="frmEditBlogEntry" id="frmEditBlogEntry">
			
				<span class="moduleOptionsLabel">Title:</span>
				<input type="text" id="txtTitle" name="txtTitle" style="width: 800px;" maxlength="100" value="#BlogEntry.Title#" />
				<br />
				<span class="moduleOptionsLabel">Blog Date:</span>
				<input type="text" id="txtBlogDate" name="txtBlogDate"  style="width: 800px;" maxlength="100" value="#DateFormat(BlogEntry.BlogDate, 'mm/dd/yyyy')#" />
				<br />
				<cftextarea height="325" width="800" id="txtaContent" name="txtaContent" richtext="true" toolbar="ArchimedesBasic"><cfoutput>#BlogEntry.Content#</cfoutput></cftextarea>
				<br />
				<img name="btnSaveEdit" id="btnSaveEdit" src="#Application.URLRoot#admin/images/saveButton.png" border="0" width="89" alt="Save" title="Save" class="imgButton" />
				<img name="btnCancelEdit" id="btnCancelEdit" src="#Application.URLRoot#admin/images/cancelButton.png" border="0" width="89" alt="Cancel" title="Cancel" class="imgButton" />
			
			</cfform>
		
		</cfoutput>
	
	</cfif>
	
</cfif>