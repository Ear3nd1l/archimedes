<cfparam name="IsValidForm" default="False" type="boolean" />

<cfobject component="#PageModule.cfcPath#" name="htmlContent" />
<cfset htmlContent.Init(PageModule.PageModuleID) />

<cfif isPostBack>

	<cfif IsEmpty(form.txtaContent) eq False>
		
		<cfscript>
			
			// Update the properties
			htmlContent.Title = Trim(form.txtTitle);
			htmlContent.Content = Trim(form.txtaContent);
			
			// Save the object
			htmlContent.Save();
			
			isValidForm = True;
			
		</cfscript>
		
	<cfelse>
	
		<cfset ErrorMessage = "Content is required." />
		
	</cfif>

</cfif>

<p>HTML Content Editor</p>
<cfif isDefined("ErrorMessage") AND Len(Trim(ErrorMessage)) gt 0>
	<p style="color: red; font-weight: bold;"><cfoutput>#ErrorMessage#</cfoutput></p>
</cfif>

<cfform method="post" action="adminPageConfigEditor.cfm?pageModuleID=#PageModule.PageModuleID#">

	<span>Title:</span><br />
	<cfinput type="text" id="txtTitle" name="txtTitle" value="#htmlContent.Title#" style="width: 800px;" maxlength="100" />
	<br />
	
	<cftextarea height="300" width="800" id="txtaContent" name="txtaContent" richtext="true" value=""><cfoutput>#htmlContent.Content#</cfoutput></cftextarea>
	
	<input type="submit" id="btnSaveContent" value="Save" /> <input type="button" id="btnCancel" value="Cancel" />
	
</cfform>

<cfif isValidForm>
	<script>
	
		$(function() {
			iFrameCloseLightbox({divID: 'divModuleOptions', fadeSpeed: 'medium'});
		});
	
	</script>
<cfelse>
	<script>
	
		$(function() {
			$('#btnCancel').click(function() {
				iFrameCloseLightbox({divID: 'divModuleOptions', fadeSpeed: 'medium'});
			});
		});
	
	</script>
</cfif>