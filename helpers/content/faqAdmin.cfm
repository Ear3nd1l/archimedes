<cfparam name="url.fuseaction" default="Home" />

<cfobject component="#PageModule.cfcPath#" name="FAQAdmin" />
<cfset FAQAdmin.Init(PageModule.PageModuleID) />
<cfset qryFAQItems = FAQAdmin.Items />

<cfoutput>

	<h3>Frequently Asked Questions:</h3>
	
	<cfswitch expression="#url.fuseaction#">
	
		<cfcase value="ManageQuestions">
		
			<span id="spnCreateQuestion">Create New Question</span>
			
			<table border="0" cellpadding="2" cellspacing="1" class="tblData">
				<tr class="adminEditorRow" id="trQuestionEditorNew">
					<td>
						
						<input type="text" id="txtQuestionNew" value="" class="tblDataRowInput" />
						<span id="valQuestionNew" class="validationError">Required</span>
						
						<div class="clear"></div>
						
						<textarea rows="4" cols="60" id="txtaAnswerNew" class="tblDataRowInput"></textarea>
						<span id="valAnswerNew" class="validationError">Required</span>
						
						<div class="clear"></div>
						
						<span class="iFrameFormButton Save floatLeft" id="SaveButtonNew">Save</span>
						<span id="valSummaryNew" class="validationError" style="float: right;">There are errors in your submission.</span>
						<span class="iFrameFormButton Cancel floatRight" id="CancelButtonNew">Cancel</span>
						
					</td>
				</tr>
			</table>
		
			<cfset qryAllQuestions = FAQAdmin.GetAllQuestions() />
			
			<table border="0" cellpadding="2" cellspacing="1" width="98%" class="tblData">
			
				<cfloop query="qryAllQuestions">
				
					<tr>
						<td class="tdFAQAdminRow tblDataRow" faqPanelID="faqPanel#qryAllQuestions.QuestionID#">
							<span class="spnFAQAdminQuestionTitle">#qryAllQuestions.question#</span>
						</td>
					</tr>
					<tr class="trFAQAdminEditPanel adminEditorRow" id="faqPanel#qryAllQuestions.QuestionID#">
						<td>
							
							<input type="text" id="txtQuestion#qryAllQuestions.questionID#" value="#qryAllQuestions.question#" class="tblDataRowInput" />
							<span id="valQuestion#qryAllQuestions.questionID#" class="validationError">Required</span>
							
							<div class="clear"></div>
							
							<textarea rows="4" cols="60" id="txtaAnswer#qryAllQuestions.questionID#" class="tblDataRowInput">#qryAllQuestions.answer#</textarea>
							<span id="valAnswer#qryAllQuestions.questionID#" class="validationError">Required</span>
							
							<div class="clear"></div>
							
							<span class="iFrameFormButton SaveButton floatLeft" questionID="#qryAllQuestions.questionID#">Save</span>
							<span id="valSummary#qryAllQuestions.questionID#" class="validationError" style="float: right;">There are errors in your submission.</span>
							<span class="iFrameFormButton CancelButton floatRight" questionID="#qryAllQuestions.questionID#">Cancel</span>
							
						</td>
					</tr>
				
				</cfloop>
			
			</table>
		
		</cfcase>
		
		<cfdefaultcase>
		
			<a href="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&fuseaction=ManageQuestions">Manage Questions</a>
			
		</cfdefaultcase>
		
	</cfswitch>	

	<script src="#Application.URLRoot#helpers/content/faqAdmin.js"></script>

</cfoutput>

