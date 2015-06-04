<cfcomponent extends="archimedesCFC.common">

	<cfparam name="THIS.QuestionnaireResponseID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.QuestionnaireID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.ProfileID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DateSubmitted" default="#NullDate#" type="date" />
	<cfparam name="THIS.IsDeleted" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.Rowguid" default="#NullGuid#" type="guid" />
	<cfparam name="THIS.ResponseAnswers" default="#ResponseAnswers()#" type="query" />
	
	<!---
			Init
				Initializes the object
	--->
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" required="yes" default="#NullGuid#" />
		
		<cfscript>
			MapData(GetByRowguid(Arguments.value));
			ResponseAnswers();
		</cfscript>
		
	</cffunction>
	
	<!---
			MapData
				Takes the query data and maps it to the object's properties.
	--->
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
			
			<cfscript>
			
				THIS.QuestionnaireResponseID = GetInt(Arguments.qryData.questionnaireResponseID);
				THIS.QuestionnaireID = GetInt(Arguments.qryData.questionnaireID);
				THIS.ProfileID = GetInt(Arguments.qryData.profileID);
				THIS.DateSubmitted = GetDate(Arguments.qryData.dateSubmitted);
				THIS.IsDeleted = GetBool(Arguments.qryData.isDeleted);
				THIS.Rowguid = GetGuid(Arguments.qryData.rowguid);
			
			</cfscript>
			
			<!--- Sanitize the string properties --->
			<cfset Sanitize() />
	
		</cfif>
		
	</cffunction>
	
	<!---
			GetByRowguid
				Returns a recordset based on the rowguid.
	--->
	<cffunction name="GetByRowguid" access="public" returntype="query">
		<cfargument name="Rowguid" required="yes" default="#NullGuid#" />
		
		<cfif IsGuid(Arguments.RowGuid)>
		
			<cfquery datasource="#DSN#" name="qryGetByRowguid">
				SELECT
						questionnaireResponseID,
						questionnaireID,
						profileID,
						dateSubmitted,
						isDeleted,
						rowguid
				FROM
						qst_QuestionnaireResponse
				WHERE
						rowguid = '#Arguments.Rowguid#'
			</cfquery>
			
			<cfreturn qryGetByRowguid />
		
		</cfif>
		
	</cffunction>
	
	<!---
			Save
				Saves the response.
	--->
	<cffunction name="Save" access="public" returntype="void">
	
		<cfquery datasource="#DSN#" name="qrySaveQuestionnaireResponse">
			INSERT
					qst_QuestionnaireResponse
					(
						questionnaireID,
						profileID
					)
			VALUES
					(
						#THIS.QuestionnaireID#,
						#THIS.ProfileID#
					)
			SELECT rowguid FROM qst_QuestionnaireResponse WHERE questionnaireResponseID = SCOPE_IDENTITY()
		</cfquery>
		
		<cfif qrySaveQuestionnaireResponse.RecordCount>
			<cfset MapData(GetByRowGuid(qrySaveQuestionnaireResponse.rowguid)) />
		</cfif>
	
	</cffunction>
	
	<!---
			ResponseAnswers
				Gets the answers for the response.
	--->
	<cffunction name="ResponseAnswers" access="public" returntype="void">
	
		<cfquery datasource="#DSN#" name="qryGetResponseAnswers">
			SELECT
					qra.questionnaireResponseAnswerID, 
					qra.questionnaireResponseID, 
					qra.questionID, 
					qra.answerID, 
					CASE
						WHEN answerID IS NULL THEN freeFormAnswer
						ELSE (SELECT answer FROM qst_Answer WHERE answerID = qra.answerID)
					END AS answer,
					q.question
			FROM 
					qst_QuestionnaireResponseAnswer qra INNER JOIN
					qst_Question q ON qra.questionID = q.questionID
			WHERE 
					qra.questionnaireResponseID = #THIS.QuestionnaireResponseID#
		</cfquery>
		
		<cfset THIS.ResponseAnswers = qryGetResponseAnswers />
	
	</cffunction>
	
	<!---
			ajaxResponseAnswers
				Gets the answers for the response and returns a struct as a JSON object.
	--->
	<cffunction name="ajaxResponseAnswers" access="remote" returntype="struct" returnFormat="json">
		<cfargument name="QuestionnaireResponseID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			THIS.QuestionnaireResponseID = Arguments.QuestionnaireResponseID;
			ResponseAnswers();
			retStruct = StructNew();
		</cfscript>
		
		<cfloop query="THIS.ResponseAnswers">
			<cfset StructInsert(retStruct, ReplaceNoCase(THIS.ResponseAnswers.question, " ", "", "all"), THIS.ResponseAnswers.answer) />
		</cfloop>
		
		<cfreturn retStruct />
		
	</cffunction>
	
	<!---
			SaveResponseAnswer
				Saves an answer.
	--->
	<cffunction name="SaveResponseAnswer" access="public" returntype="void">
		<cfargument name="QuestionID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="AnswerID" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="FreeFormAnswer" type="string" required="no" default="#NullString#" />
		
		<cfquery datasource="#DSN#" name="qrySaveResponseAnswer">
			INSERT
					qst_QuestionnaireResponseAnswer
					(
						questionnaireResponseID,
						questionID,
						answerID,
						freeformAnswer
					)
			VALUES
					(
						#THIS.QuestionnaireResponseID#,
						#Arguments.QuestionID#,
						<cfif Arguments.AnswerID gt NullInt>
							#Arguments.AnswerID#,
						<cfelse>
							NULL,
						</cfif>
						'#Arguments.FreeFormAnswer#'
					)
		</cfquery>
		
	</cffunction>
	
</cfcomponent>