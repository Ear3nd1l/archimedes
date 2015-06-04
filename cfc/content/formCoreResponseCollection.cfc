<cfcomponent extends="ArchimedesCFC.baseCollection">

	<cffunction name="MapObjects" access="public" returntype="void" output="yes">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>

			<cfloop query="Arguments.qryData">
				
				<cfscript>
					
					FormResponse = CreateObject('component', 'ArchimedesCFC.content.formCoreResponse');
					
					FormResponse.QuestionnaireResponseID = GetInt(Arguments.qryData.questionnaireResponseID);
					FormResponse.QuestionnaireID = GetInt(Arguments.qryData.questionnaireID);
					FormResponse.DateSubmitted = GetDate(Arguments.qryData.dateSubmitted);
					FormResponse.Rowguid = GetGuid(Arguments.qryData.rowguid);
					FormResponse.GetResponseAnswers();
					FormResponse.Sanitize();
					
					Add(FormResponse);
				</cfscript>
			
			</cfloop>
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetBySearch" access="public" returntype="void">
		<cfargument name="QuestionnaireID" type="numeric" required="no" default="#NullInt#" />
		<cfargument name="ProfileID" type="numeric" required="no" default="#NullInt#" />

		<cfquery datasource="#DSN#" name="qryGetBySearch">
			SELECT
					questionnaireResponseID,
					profileID,
					dateSubmitted,
					rowguid
			FROM
					qst_QuestionnaireResponse
			WHERE
					1 = 1
					<cfif Arguments.QuestionnaireID gt NullInt>
						AND questionnaireID = #Arguments.QuestionnaireID#
					</cfif>
					<cfif Arguments.ProfileID gt NullInt>
						AND profileID = #Arguments.ProfileID#
					</cfif>
		</cfquery>

	</cffunction>
	
	<cffunction name="SearchByQuestionNameAndValue" access="public" returntype="void">
		<cfargument name="Question" type="string" required="yes" default="#NullString#" />
		<cfargument name="FreeFormAnswer" type="string" required="yes" default="#NullString#" />
		
		<cfquery datasource="#DSN#" name="qrySearchByQuestionNameAndValue">
			SELECT
					questionnaireResponseID,
					profileID,
					dateSubmitted,
					rowguid
			FROM
					qst_QuestionnaireResponse
			WHERE
					questionnaireResponseID IN (
													SELECT
															questionnaireResponseID
													FROM 
															qst_QuestionnaireResponseAnswer qra INNER JOIN
															qst_Question q ON qra.questionID = q.questionID
													WHERE 
															q.question = '#Argument.Question#'
															AND CAST(qra.freeFormAnswer AS varchar(max)) = '#Argument.FreeFormAnswer#'
												)
		</cfquery>
		
		<cfset MapObjects(qrySearchByQuestionNameAndValue) />
		
	</cffunction>

</cfcomponent>