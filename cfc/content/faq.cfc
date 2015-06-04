<cfcomponent extends="ArchimedesCFC.modules.pageModule">

	<cfparam name="THIS.FAQID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.IsActive" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.Items" type="query" default="#GetItems()#" />
	
	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript>
			MapData(GetByPageModuleID(Arguments.Value));
			GetItems();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>
			
				THIS.FAQID = GetInt(Arguments.qryData.faqID);
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.IsActive = GetBool(Arguments.qryData.isActive);
			
			</cfscript>
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetByPageModuleID" access="public" returntype="query">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetByPageModuleID">
			SELECT
					faqID,
					pageModuleID,
					isActive
			FROM
					mod_FAQ
			WHERE
					pageModuleID = #Arguments.PageModuleID#
		</cfquery>
		
		<cfreturn qryGetByPageModuleID />
	
	</cffunction>
	
	<cffunction name="GetItems" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetItems">
			SELECT
					q.questionID,
					q.question,
					q.answer
			FROM
					mod_FAQItem i INNER JOIN
					mod_FAQQuestion q ON i.questionID = q.questionID
			WHERE
					q.isActive = 1
					AND i.faqID = #THIS.FAQID#
			ORDER BY
					i.sortOrder
		</cfquery>
		
		<cfset THIS.Items = qryGetItems />
		
		<cfreturn qryGetItems />
		
	</cffunction>
	
	<cffunction name="GetAllQuestions" access="public" returntype="query">
	
		<cfquery datasource="#DSN#" name="qryGetAllQuestions">
			SELECT
					q.questionID,
					q.question,
					q.answer
			FROM
					mod_FAQQuestion q
			WHERE
					q.isActive = 1
			ORDER BY
					q.question
		</cfquery>
		
		<cfreturn qryGetAllQuestions />

	</cffunction>

	<cffunction name="CreateDefaultPageModule" access="public" returntype="boolean">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateDefaultPageModule">
				INSERT
						mod_FAQ
						(
							pageModuleID
						)
				VALUES
						(
							#Arguments.PageModuleID#,
						)
				SELECT SCOPE_IDENTITY() AS faqID
			</cfquery>
			
			<cfreturn qryCreateDefaultPageModule.RecordCount eq 1 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
	</cffunction>
	
	<cffunction name="CreateQuestion" access="public" returntype="boolean">
		<cfargument name="Question" type="string" required="yes" default="#NullString#" />
		<cfargument name="Answer" type="string" required="yes" default="#NullString#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryCreateQuestion">
					INSERT
							mod_FAQQuestion
							(
								question,
								answer,
								isActive
							)
					VALUES
							(
								'#Arguments.Question#',
								'#Arguments.Answer#',
								1
							)
				
					SELECT SCOPE_IDENTITY() AS questionID
				</cfquery>
				
				<cfreturn qryCreateQuestion.RecordCount gt 0 />
				
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="EditQuestion" access="public" returntype="boolean">
		<cfargument name="QuestionID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Question" type="string" required="yes" default="#NullString#" />
		<cfargument name="Answer" type="string" required="yes" default="#NullString#" />
		
		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>

			<cftry>
			
				<cfquery datasource="#DSN#" name="qryEditQuestion">
					UPDATE
							mod_FAQQuestion
					SET
							question = '#Arguments.Question#',
							answer = '#Arguments.Answer#'
					WHERE
							questionID = #Arguments.QuestionID#
				</cfquery>
				
				<cfreturn True />
			
				<cfcatch><cfreturn False /></cfcatch>
			
			</cftry>
			

		<cfelse>
		
			<cfreturn False />
		
		</cfif>

	</cffunction>
	
	<cffunction name="DeactivateQuestion" access="public" returntype="boolean">
		<cfargument name="QuestionID" type="numeric" required="yes" default="#NullInt#" />

		<cfif Session.Profile.IsValidSession(cgi.HTTP_USER_AGENT, cgi.REMOTE_ADDR)>
		
			<cftry>
			
				<cfquery datasource="#DSN#" name="qryDeactivateQuestion">
					UPDATE
							mod_FAQQuestion
					SET
							isActive = 0
					WHERE
							questionID = #Arguments.QuestionID#
				</cfquery>
				
				<cfreturn True />
				
				<cfcatch><cfreturn False /></cfcatch>
				
			</cftry>
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>

	</cffunction>
	
	<cffunction name="ajaxCreateQuestion" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="Question" type="string" required="yes" default="#NullString#" />
		<cfargument name="Answer" type="string" required="yes" default="#NullString#" />
		
		<cfreturn CreateQuestion(Arguments.Question, Arguments.Answer) />
	
	</cffunction>
	
	<cffunction name="ajaxEditQuestion" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="QuestionID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="Question" type="string" required="yes" default="#NullString#" />
		<cfargument name="Answer" type="string" required="yes" default="#NullString#" />
		
		<cfreturn EditQuestion(Arguments.QuestionID, Arguments.Question, Arguments.Answer) />
	
	</cffunction>
	
	<cffunction name="ajaxDeactiveQuestion" access="remote" returntype="boolean" returnformat="json">
		<cfargument name="QuestionID" type="numeric" required="yes" default="#NullInt#" />
	
		<cfreturn DeactivateQuestion(Arguments.QuestionID) />
	
	</cffunction>

</cfcomponent>