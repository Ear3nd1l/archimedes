<cfcomponent extends="archimedesCFC.common" displayname="Forms Core Framework" hint="">

	<cfparam name="THIS.QuestionnaireID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.QuestionnaireTitle" default="#NullString#" type="string" />
	<cfparam name="THIS.SiteID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.IntroText" default="#NullString#" type="string" />
	<cfparam name="THIS.ConfirmationText" default="#NullString#" type="string" />
	<cfparam name="THIS.IsParent" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.IsDeleted" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.Rowguid" default="#NullGuid#" type="guid" />
	
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfset MapData(GetByQuestionnaireID(GetQuestionnaireID(Arguments.value))) />
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfif IsQuery(Arguments.qryData) AND qryData.RecordCount>
		
			<cfscript>
				
				THIS.QuestionnaireID = GetInt(Arguments.qryData.questionnaireID);
				THIS.QuestionnaireTitle = GetString(Arguments.qryData.questionnaireTitle);
				THIS.SiteID = GetInt(Arguments.qryData.siteID);
				THIS.IntroText = GetString(Arguments.qryData.introText);
				THIS.ConfirmationText = GetString(Arguments.qryData.confirmationText);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
				THIS.IsDeleted = GetBool(Arguments.qryData.isDeleted);
				THIS.Rowguid = GetGuid(Arguments.qryData.rowguid);
				
			</cfscript>
		
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetQuestionnaireID" access="private" returntype="numeric">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetQuestionnaireID">
			SELECT
					questionnaireID
			FROM
					mod_RegistrationForm
			WHERE
					pageModuleID = #Arguments.PageModuleID#
		</cfquery>
		
		<cfreturn qryGetQuestionnaireID.questionnaireID />
		
	</cffunction>

	<cffunction name="GetByQuestionnaireID" access="public" returntype="query">
		<cfargument name="QuestionnaireID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="qst_Questionnaire_GetQuestionnaireByID">
			<cfprocparam dbvarname="@QuestionnaireID" value="#Arguments.QuestionnaireID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetByQuestionnaireID" />
		</cfstoredproc>
		
		<cfreturn qryGetByQuestionnaireID />
		
	</cffunction>

	<cffunction name="InitByRowguid" access="public" returntype="void">
		<cfargument name="Rowguid" type="guid" required="yes" default="#NullGuid#" />
		
		<cfstoredproc datasource="#DSN#" procedure="qst_Questionnaire_GetQuestionnaireByUUID">
			<cfprocparam dbvarname="@Rowguid" value="#Arguments.Rowguid#" cfsqltype="cf_sql_varchar" />
			<cfprocresult name="qryGetByRowguid" />
		</cfstoredproc>
		
		<cfset MapData(qryGetByQuestionnaireID) />
		
	</cffunction>
	
	<cffunction name="GetQuestionnaireQuestions" access="public" returntype="query">
		
		<cfstoredproc datasource="#DSN#" procedure="qst_Question_GetQuestionnaireQuestions">
			<cfprocparam dbvarname="@QuestionnaireID" value="#THIS.QuestionnaireID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryGetQuestionnaireQuestions" />
		</cfstoredproc>
		
		<cfreturn qryGetQuestionnaireQuestions />
		
	</cffunction>
	
	<cffunction name="GetQuestionArray" access="public" returntype="array">
		
		<cfset qryQuestionnaireQuestions = GetQuestionnaireQuestions() />
		<cfset questionnaireQuestions = ArrayNew(1) />
		
		<cfloop query="qryQuestionnaireQuestions">
			
			<cfset questionStructure = StructNew() />
			
			<cfscript>
				// Add the question's field values to the question structure.
				StructInsert(questionStructure, "QuestionID", qryQuestionnaireQuestions.questionID);
				StructInsert(questionStructure, "QuestionTitle", qryQuestionnaireQuestions.question);
				StructInsert(questionStructure, "IsRequired", qryQuestionnaireQuestions.required);
				StructInsert(questionStructure, "QuestionType", qryQuestionnaireQuestions.questionType);
				StructInsert(questionStructure, "Control", qryQuestionnaireQuestions.control);
				StructInsert(questionStructure, "txtCols", qryQuestionnaireQuestions.txtCols);
				StructInsert(questionStructure, "txtRows", qryQuestionnaireQuestions.txtRows);
				StructInsert(questionStructure, "rdoAlign", qryQuestionnaireQuestions.rdoAlign);
				StructInsert(questionStructure, "ScaleLength", qryQuestionnaireQuestions.scaleLength);
				StructInsert(questionStructure, "ValidationType", qryQuestionnaireQuestions.validationType);
				StructInsert(questionStructure, "RegularExpression", qryQuestionnaireQuestions.regularExpression);
				StructInsert(questionStructure, "Answers", GetQuestionAnswersAsStructure(qryQuestionnaireQuestions.questionID));
				
				// Add the question to the questionnaire structure.
				ArrayAppend(questionnaireQuestions, questionStructure);
			</cfscript>
			
		</cfloop>
		
		<cfreturn questionnaireQuestions />
		
	</cffunction>
	
	<cffunction name="GetQuestionAnswersAsStructure" access="public" returntype="array">
		<cfargument name="QuestionID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfstoredproc datasource="#DSN#" procedure="qst_Answer_GetAnswersByQuestionID">
			<cfprocparam dbvarname="@QuestionID" value="#Arguments.QuestionID#" cfsqltype="cf_sql_integer" />
			<cfprocresult name="qryAnswers" />
		</cfstoredproc>
		
		<cfset questionAnswers = ArrayNew(1) />
		
		<cfloop query="qryAnswers">
			
			<cfset answerStructure = StructNew() />
			<cfscript>
				// Add the answer's field values to the answer structure.
				StructInsert(answerStructure, "AnswerID", qryAnswers.answerID);
				StructInsert(answerStructure, "Answer", qryAnswers.answer);
				
				// Add the answer to the questionAnswers structure.
				ArrayAppend(questionAnswers, answerStructure);
			</cfscript>

		</cfloop>
		
		<cfreturn questionAnswers />
		
	</cffunction>

</cfcomponent>