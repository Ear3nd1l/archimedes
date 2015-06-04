<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />
 

<cfif IsDefined("url.UUID")>
	<cfobject component="ArchimedesCFC.content.formCoreResponse" name="Response" />
	<cfset Response.Init(url.UUID) />
	
	<p>Thank you for your submission.  Please review the details below.</p>
	
	<cfset qryResponseAnswers = Response.ResponseAnswers />
	
	<cfoutput query="qryResponseAnswers">
		<div class="divResponseAnswerContainer">
			<span class="spnResponseQuestionLabel">#qryResponseAnswers.question#</span>
			<span class="spnResponseAnswerLabel">#qryResponseAnswers.answer#</span>
		</div>
	</cfoutput>

<cfelse>

	<cfobject component="#Attributes.cfcPath#" name="RegistrationForm" />
	<cfset RegistrationForm.Init(Attributes.PageModuleID) />
	
	<cfoutput>
	
		<h3 class="QuestionnaireTitle">#RegistrationForm.QuestionnaireTitle#</h3>
		
		<p class="QuestionnaireIntroText">#RegistrationForm.IntroText#</p>
		
		<hr class="QuestionnaireSeparator" />
		
		<cfset questionnaireQuestions = RegistrationForm.GetQuestionArray() />
		
		<form action="/Registration/Processor.cfm" method="post" name="frmRegistration">
		
			<input type="hidden" name="hdnQuestionnaireID" value="#RegistrationForm.QuestionnaireID#" />
			<input type="hidden" name="hdnPageModuleID" value="#Attributes.PageModuleID#" />
		
			<cfloop from="1" to="#ArrayLen(questionnaireQuestions)#" index="i">
			
				<cfmodule template="#questionnaireQuestions[i].control#" questionInfo="#questionnaireQuestions[i]#">
			
			</cfloop>
			
			<input type="button" id="btnSubmit" value="Submit" />
		
		</form>
		
		<script>
		
			$(function() {
				$('##btnSubmit').click(function() {
					var isValid = true;
					
					$('.required').each(function() {
						if($(this).val() == '')
						{
							isValid = false;
							$(this).addClass('validationError');
						}
					});
					
					if(isValid == false)
					{
						$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>There were errors on the form.</p>').dialog('open');
					}
					else
					{
						document.forms['frmRegistration'].submit();
					}
				});
			});
		
		</script>
	
	</cfoutput>

</cfif>