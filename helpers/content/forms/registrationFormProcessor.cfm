<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />

<!--- If a form has been submitted, process it.  Otherwise, this has been called from the admin tool and will display no options. --->
<cfif isDefined("form.hdnPageModuleID")>

	<cfobject component="#Attributes.cfcPath#" name="Response" />
	
	<cfset RegistrationForm = Response.GetModuleByName("Registration") />
	
	<cfset RegistrationForm.Init(form.hdnPageModuleID) />
	<cfset questionnaireQuestions = RegistrationForm.GetQuestionArray() />
	
	
	<cfscript>
		Response.QuestionnaireID = RegistrationForm.QuestionnaireID;
		Response.ProfileID = Caller.Profile.ProfileID;
		Response.Save();
	</cfscript>
	
	<cfloop from="1" to="#ArrayLen(questionnaireQuestions)#" index="i">
	
		<!--- TODO:  Validate the data --->
		<cfset fieldValue = Evaluate("form.Question" & questionnaireQuestions[i].QuestionID) />
		<cftry>
			
			<cfset Answers = questionnaireQuestions[i].Answers />
			
			<!--- If this question does not have predefined answers, then save the response as a FreeForm Answer --->
			<cfif ArrayIsEmpty(Answers)>
			
				<cfset Response.SaveResponseAnswer(QuestionID=questionnaireQuestions[i].QuestionID, FreeFormAnswer=fieldValue) />
			
			<!--- Otherwise, save the answerID --->
			<cfelse>
			
				<cfset Response.SaveResponseAnswer(QuestionID=questionnaireQuestions[i].QuestionID, AnswerID=fieldValue) />
			
			</cfif>
			
				<cfoutput>
					form.Question#questionnaireQuestions[i].QuestionID# = #fieldValue# - Saved<br />
				</cfoutput>
		
			<cfcatch>
			
				<cfdump var="#cfcatch#" />
				<cfabort />
		
			</cfcatch>
		</cftry>
		
	
	</cfloop>
	
	<cflocation url="/Registration/Confirmation.cfm?UUID=#Response.Rowguid#" addtoken="no" />

<cfelse>

	<p>Nothing has been submitted.</p>

</cfif>