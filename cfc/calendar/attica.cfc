<!---
	File Name:		Attica.cfc
	Author:			Chris Hampton
	Created:		
	Last Modified:	
	History:		Reset history for Alpha 2
	Purpose:		CFC object for pages
	Basis:			Based on Kinky Calendar, created by Ben Nadel - http://www.bennadel.com/projects/kinky-calendar.htm

--->

<cfcomponent extends="ArchimedesCFC.common">

	<cfparam name="THIS.AtticaID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.PageModuleID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DepartmentID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DepartmentName" default="#NullString#" type="string" />
	<cfparam name="THIS.SiteID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DefaultViewTypeID" default="#NullInt#" type="numeric" />
	<cfparam name="THIS.DefaultViewType" default="#NullString#" type="string" />
	<cfparam name="THIS.IntroText" default="#NullString#" type="string" />
	<cfparam name="THIS.IsUpcomingEvents" default="#NullBool#" type="boolean" />
	<cfparam name="THIS.MaxRows" default="-1" type="numeric" /> <!--- This does not use NullInt as its default because a value of -1 in the maxrows attribute of a query returns all rows. --->
	<cfparam name="THIS.Events" type="any" default="" /><!---  default="#GetEvents()#" type="query" --->
	
	<cfparam name="VARIABLES.RawEvents" type="any" default="" /><!---  default="#GetRawEvents()#" type="query" --->
	<cfparam name="VARIABLES.NonRecurringEvents" type="any" default=""  /><!--- default="#GetNonRecurringEvents()#" type="query" --->
	<cfparam name="VARIABLES.EventExceptions" type="any" default=""  /><!--- default="#GetEventExceptions()#" type="query" --->

	<cffunction name="Init" access="public" returntype="void">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfscript> 
		
			MapData(GetByPageModuleID(Arguments.PageModuleID));
			
		</cfscript>
		
	</cffunction>
	
	<cffunction name="MapData" access="private" returntype="void">
		<cfargument name="qryData" type="query" required="yes" default="" />
		
		<cfif IsQuery(Arguments.qryData) AND Arguments.qryData.RecordCount>
		
			<cfscript>

				THIS.AtticaID = GetInt(Arguments.qryData.atticaID);
				THIS.PageModuleID = GetInt(Arguments.qryData.pageModuleID);
				THIS.DepartmentID = GetInt(Arguments.qryData.departmentID);
				THIS.DepartmentName = GetString(Arguments.qryData.departmentName);
				THIS.SiteID = GetInt(Arguments.qryData.siteID);
				THIS.DefaultViewTypeID = GetInt(Arguments.qryData.defaultViewTypeID);
				THIS.DefaultViewType = GetString(Arguments.qryData.defaultViewType);
				THIS.IntroText = GetString(Arguments.qryData.introText);
				THIS.IsUpcomingEvents = GetBool(Arguments.qryData.isUpcomingEvents);
				
				// Sanitize the string properties
				Sanitize();
			
			</cfscript>
		
		</cfif>
		
	</cffunction>

	<cffunction name="GetByPageModuleID" access="public" returntype="query" hint="Gets the calendar info based on the pageModuleID.">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetByPageModuleID">
			SELECT
					a.atticaID,
					a.pageModuleID,
					a.departmentID,
					d.department AS departmentName,
					a.siteID,
					a.defaultViewTypeID,
					vt.viewType AS defaultViewType,
					a.introText,
					a.isUpcomingEvents
			FROM
					mod_Attica a LEFT OUTER JOIN
					com_Department d ON a.departmentID = d.departmentID INNER JOIN
					mod_AtticaViewType vt ON a.defaultViewTypeID = vt.viewTypeID
			WHERE
					a.pageModuleID = #Arguments.PageModuleID#					
		</cfquery>
		
		<cfreturn qryGetByPageModuleID />
		
	</cffunction>
	
	<cffunction name="CreateDefaultPageModule" access="public" returntype="boolean" hint="Sets the default parameters for a new Calendar module.">
		<cfargument name="PageModuleID" type="numeric" required="yes" default="#NullInt#" />
		<cfargument name="PageID" type="numeric" required="yes" default="#NullInt#" />
		
		<cftry>
		
			<cfquery datasource="#DSN#" name="qryCreateDefaultPageModule">
				INSERT
						mod_Attica
						(
							pageModuleID,
							departmentID,
							siteID,
							defaultViewTypeID,
							isUpcomingEvents,
							maxRows
						)
				VALUES
						(
							#Arguments.PageModuleID#,
							0,
							#Applications.SiteID#,
							3,
							0,
							-1
						)
				SELECT SCOPE_IDENTITY() AS atticaID
			</cfquery>
			
			<cfreturn qryCreateDefaultPageModule.RecordCount eq 1 />
			
			<cfcatch><cfreturn False /></cfcatch>
			
		</cftry>
	</cffunction>
	
	<cffunction name="GetEventByEventCode" access="public" returntype="struct">
		<cfargument name="EventCode" type="string" required="yes" default="#NullString#" />
		
		<cfset retStruct = StructNew() />
		
		<!--- Split the event code to get the date and eventID. --->
		<cfset eventDate = DateFormat(ListGetAt(Arguments.EventCode, 1, '_'), "mm/dd/yyyy") />
		<cfset eventID = ListGetAt(Arguments.EventCode, 2, '_') />
		
		<cfif IsNumeric(eventID) AND IsDate(eventDate)>
		
			<!--- Check to see if there is an exception for this event on this date. --->
			<cfquery datasource="#DSN#" name="qryGetException" maxrows="1">
				SELECT
						ee.eventExceptionID,
						ee.eventID,
						ee.exceptionDate,
						ee.isCancelled,
						rt.recurrenceType,
						CASE
							WHEN ee.eventName IS NULL THEN e.eventName
							ELSE ee.eventName
						END AS eventName,
						CASE
							WHEN ee.eventDescription IS NULL THEN e.eventDescription
							ELSE ee.eventDescription
						END AS eventDescription,
						CASE
							WHEN ee.startTime IS NULL THEN e.startTime
							ELSE ee.startTime
						END AS startTime,
						CASE
							WHEN ee.endTime IS NULL THEN e.endTime
							ELSE ee.endTime
						END AS endTime,
						CASE
							WHEN ee.isAllDay IS NULL THEN e.isAllDay
							ELSE ee.isAllDay
						END AS isAllDay,
						CASE
							WHEN ee.eventLocationID IS NULL THEN e.eventLocationID
							ELSE ee.eventLocationID
						END AS eventLocationID,
						CASE
							WHEN ee.eventLocationID IS NULL THEN el.eventLocation
							ELSE el2.eventLocation
						END AS eventLocation
				FROM
						mod_AtticaEventException ee INNER JOIN
						mod_AtticaEvent e ON ee.eventID = e.eventID INNER JOIN
						mod_AtticaRecurrenceType rt ON e.recurrenceTypeID = rt.recurrenceTypeID LEFT OUTER JOIN
						mod_AtticaEventLocation el ON e.eventLocationID = el.eventLocationID LEFT OUTER JOIN
						mod_AtticaEventLocation el2 ON ee.eventLocationID = el2.eventLocationID
				WHERE
						ee.eventID = #eventID#
						AND exceptionDate = '#DateFormat(eventDate, "yyyy-mm-dd")#'
						AND isCancelled = 0
			</cfquery>			
			
			<cfif qryGetException.RecordCount>
			
				<!--- Move the data into a structure --->
				<cfscript>
	
					StructInsert(retStruct, "EventExceptionID", qryGetException.eventExceptionID);
					StructInsert(retStruct, "EventID", qryGetException.eventID);
					StructInsert(retStruct, "EventDate", qryGetException.exceptionDate);
					StructInsert(retStruct, "EventName", qryGetException.eventName);
					StructInsert(retStruct, "EventDescription", qryGetException.eventDescription);
					StructInsert(retStruct, "StartTime", qryGetException.startTime);
					StructInsert(retStruct, "EndTime", qryGetException.endTime);
					StructInsert(retStruct, "IsAllDay", qryGetException.isAllDay);
					StructInsert(retStruct, "EventLocation", qryGetException.eventLocation);
					StructInsert(retStruct, "EventLocationID", qryGetException.eventLocationID);
					StructInsert(retStruct, "RecurrenceType", qryGetException.recurrenceType);
					StructInsert(retStruct, "IsException", True);
	
				</cfscript>
			
			<!--- If there is not an exception, get the info from the primary event. --->
			<cfelse>
			
				<cfset qryEventDetails = GetEventByID(eventID) />
				
				<cfif qryEventDetails.RecordCount>
			
					<!--- Move the data into a structure --->
					<cfscript>
		
						StructInsert(retStruct, "EventExceptionID", 0);
						StructInsert(retStruct, "EventID", qryEventDetails.eventID);
						StructInsert(retStruct, "EventDate", eventDate);
						StructInsert(retStruct, "EventName", qryEventDetails.eventName);
						StructInsert(retStruct, "EventDescription", qryEventDetails.eventDescription);
						StructInsert(retStruct, "StartTime", qryEventDetails.startTime);
						StructInsert(retStruct, "EndTime", qryEventDetails.endTime);
						StructInsert(retStruct, "IsAllDay", qryEventDetails.isAllDay);
						StructInsert(retStruct, "EventLocation", qryEventDetails.eventLocation);
						StructInsert(retStruct, "EventLocationID", qryEventDetails.eventLocationID);
						StructInsert(retStruct, "RecurrenceType", qryEventDetails.recurrenceType);
						StructInsert(retStruct, "IsException", False);
		
					</cfscript>
			
				</cfif>
			
			</cfif>
			
		</cfif>
		
		<!--- If the structure is empty, return basic info about the event. --->
		<cfif StructIsEmpty(retStruct)>
			
			<cfscript>
			
				StructInsert(retStruct, "eventCode", Arguments.EventCode);
				StructInsert(retStruct, "eventDate", eventDate);
				StructInsert(retStruct, "eventID", eventID);
			
			</cfscript>
			
		</cfif>
		
		<cfreturn retStruct />
		
	</cffunction>
	
	<cffunction name="CreateEvent" access="public" returntype="boolean">
	
	</cffunction>
	
	<cffunction name="EditEvent" access="public" returntype="boolean">
	
	</cffunction>
	
	<cffunction name="CreateException" access="public" returntype="boolean">
	
	</cffunction>
	
	<cffunction name="EditException" access="public" returntype="boolean">
	
	</cffunction>
	
	<cffunction name="UserHasAccess" access="public" returntype="boolean">
	
		<!--- Site Admins always have access. Only site admins have access to global calendars. --->
		<cfif Session.Profile.HasRole("Site Administrator")>
			
			<cfreturn True />
		
		<!--- If this is not a global calendar and the user's departmentID equals the calendar's departmentID... --->
		<cfelseif THIS.DepartmentID neq 0 AND Session.Profile.DepartmentID eq THIS.DepartmentID>
		
			<!--- TODO: Check to see if the user is a department admin. --->
			
			<!--- TODO: If not, check to see if they have the 'Calender Manager' role. --->
		
		<cfelse>
		
			<cfreturn False />
		
		</cfif>
	
	</cffunction>

	<cffunction name="GetEvents" access="public" returntype="void" output="yes">
		<cfargument name="StartDate" type="string" required="yes" default="#NullDate#" />
		<cfargument name="EndDate" type="string" required="yes" default="#NullDate#" />
		<cfargument name="DepartmentID" type="numeric" required="no" default="0" />
		
		<!--- Create the query object --->
		<cfset qryEvents = QueryNew(
			  "eventID, eventName, eventDescription, siteID, departmentID, departmentName, eventLocationID, eventLocation, startDate, endDate, startTime, endTime, isAllDay, recurrenceTypeID, recurrenceType, recurrenceIndex, eventTypeID, eventType, class, dateCreated, dateModified",
			  "integer, varchar, varchar, integer, integer, varchar, integer, varchar, date, date, time, time, bit, integer, varchar, varchar, integer, varchar, varchar, date, date"
		  ) />
									  
		<cfif IsDate(Arguments.StartDate) AND IsDate(Arguments.EndDate)>
		
			<cfscript>
			
				// Get the base data
				GetRawEvents(Arguments.DepartmentID);
				GetNonRecurringEvents();
				GetEventExceptions(Arguments.StartDate, Arguments.EndDate, Arguments.DepartmentID);
			
			</cfscript>
			
			<cfset incrementTo = NullDate />
			<cfset incrementFrom = NullDate />
			
			<!--- Loop through the raw events. --->
			<cfloop query="VARIABLES.RawEvents">
			
				<!--- If the end date has a valid value... --->
				<cfif IsDate(VARIABLES.RawEvents.endDate)>
				
					<!--- Set the end date to the lower of two values: event end date or user supplied end date. --->
					<cfset incrementTo = VARIABLES.RawEvents.endDate />
				
				<cfelse>
				
					<!--- If there is no end date specified, set this value to the user supplied end date. --->
					<cfset incrementTo = Arguments.EndDate />
				
				</cfif>
				
				<!--- Default the recurrence increment type to Day. --->
				<cfset incrementType = 'd' />
				<cfset incrementAmount = 1 />
				
				<!--- Set the start date to the event start date. --->
				<cfset incrementFrom = VARIABLES.RawEvents.startDate />

				<!--- Set the allowable days of the week for incrementing.  Default to all. --->
				<cfset daysOfWeek = "" />
				
				<cfswitch expression="#VARIABLES.RawEvents.recurrenceType#">
				
					<cfcase value="None">
						<!--- Do nothing. --->
					</cfcase>
					
					<cfcase value="Daily">
					
						<!--- Set the increment type and amount. --->
						<cfset incrementType = 'd' />
						<cfset incrementAmount = 1 />

					</cfcase>
					
					<cfcase value="Weekly">
					
						<cfset incrementFrom = (incrementFrom - DayOfWeek(incrementFrom) + DayOfWeek(VARIABLES.RawEvents.startDate)) />
					
						<!--- Set the increment type and amount. --->
						<cfset incrementType = 'd' />
						<cfset incrementAmount = 7 />

					</cfcase>
					
					<cfcase value="Bi-Weekly">
					
						<cfset incrementFrom = (incrementFrom - DayOfWeek(incrementFrom) + DayOfWeek(VARIABLES.RawEvents.startDate)) />
						<cfset incrementFrom = (incrementFrom - ((incrementFrom - VARIABLES.RawEvents.startDate) MOD 14)) />
					
						<!--- Set the increment type and amount. --->
						<cfset incrementType = 'd' />
						<cfset incrementAmount = 14 />

					</cfcase>
					
					<cfcase value="Monthly">
					
						<cfset incrementFrom = Max(DateAdd("yyyy", -1, VARIABLES.RawEvents.startDate), VARIABLES.RawEvents.startDate) />
						
						<!--- Set the increment type and amount. --->
						<cfset incrementType = 'm' />
						<cfset incrementAmount = 1 />

					</cfcase>
					
					<cfcase value="Yearly">
						<!--- This recurrence type is not currently active. --->
					</cfcase>
					
					<cfcase value="Monday-Friday">
						
						<!--- Set the increment type and amount. --->
						<cfset incrementType = 'd' />
						<cfset incrementAmount = 1 />
						<cfset daysOfWeek = "2,3,4,5,6" />
						
					</cfcase>
					
					<cfcase value="Saturday-Sunday">
						
						<!--- Set the increment type and amount. --->
						<cfset incrementType = 'd' />
						<cfset incrementAmount = 1 />
						<cfset daysOfWeek = "1,7" />
						
					</cfcase>
					
					<cfcase value="Every nth Day of the Month">
					
					</cfcase>
					
					<cfcase value="Selected Dates">
					
					</cfcase>
				
					<cfdefaultcase>
						<!--- Do nothing. --->
					</cfdefaultcase>				
				
				</cfswitch>
				
				<cfif VARIABLES.RawEvents.recurrenceType eq "None">
				
					<!--- Insert the event info into the temp query. --->
					<cfscript>
					
						// Add a new row.
						QueryAddRow(qryEvents, 1);
						
						// Add the values to the row.
						QuerySetCell(qryEvents, "eventID", VARIABLES.RawEvents.eventID);
						QuerySetCell(qryEvents, "eventName", VARIABLES.RawEvents.eventName);
						QuerySetCell(qryEvents, "eventDescription", VARIABLES.RawEvents.eventDescription);
						QuerySetCell(qryEvents, "siteID", VARIABLES.RawEvents.siteID);
						QuerySetCell(qryEvents, "departmentID", VARIABLES.RawEvents.departmentID);
						QuerySetCell(qryEvents, "departmentName", VARIABLES.RawEvents.departmentName);
						QuerySetCell(qryEvents, "eventLocationID", VARIABLES.RawEvents.eventLocationID);
						QuerySetCell(qryEvents, "eventLocation", VARIABLES.RawEvents.eventLocation);
						QuerySetCell(qryEvents, "startDate", VARIABLES.RawEvents.startDate);
						QuerySetCell(qryEvents, "endDate", VARIABLES.RawEvents.endDate);
						QuerySetCell(qryEvents, "startTime", VARIABLES.RawEvents.startTime);
						QuerySetCell(qryEvents, "endTime", VARIABLES.RawEvents.endTime);
						QuerySetCell(qryEvents, "isAllDay", VARIABLES.RawEvents.isAllDay);
						QuerySetCell(qryEvents, "recurrenceTypeID", VARIABLES.RawEvents.recurrenceTypeID);
						QuerySetCell(qryEvents, "recurrenceType", VARIABLES.RawEvents.recurrenceType);
						QuerySetCell(qryEvents, "recurrenceIndex", DateFormat(VARIABLES.RawEvents.startDate, "mm-dd-yyyy") & "_" & VARIABLES.RawEvents.eventID);
						QuerySetCell(qryEvents, "eventTypeID", VARIABLES.RawEvents.eventTypeID);
						QuerySetCell(qryEvents, "eventType",VARIABLES.RawEvents.eventType);
						QuerySetCell(qryEvents, "class", VARIABLES.RawEvents.class);
						QuerySetCell(qryEvents, "dateCreated", VARIABLES.RawEvents.dateCreated);
						QuerySetCell(qryEvents, "dateModified", VARIABLES.RawEvents.dateModified);
					
					</cfscript>
				
				<cfelseif VARIABLES.RawEvents.RecurrenceType eq "Every nth Day of the Month">
				
				
					<!--- Calculate the date that this event should occur on. --->
					<cfset nthDay = ListGetAt(VARIABLES.RawEvents.recurrenceData, 1, "|") />
					<cfset theDayOfWeek = ListGetAt(VARIABLES.RawEvents.recurrenceData, 2, "|") />
					<cfset currentDay = (nthDay * 7) - (DayOfWeek(Arguments.StartDate) -1) + theDayOfWeek />
					
					<cfif theDayOfWeek gte DayOfWeek(Arguments.StartDate)>
						<cfset currentDay = currentDay - 7 />
					</cfif>
					
					<cfset eventDate = DateFormat(Arguments.StartDate, "mm") & "/" & currentDay & "/" & DateFormat(Arguments.StartDate, "yyyy") />
				
					<cfif (VARIABLES.RawEvents.startDate lte Arguments.StartDate) AND (VARIABLES.RawEvents.endDate gte Arguments.StartDate)>
					
						<!--- Check the exception events and see if there is a modified event for this date. --->
						<cfquery dbtype="query" name="qoqGetEventException">
							SELECT
									*
							FROM
									VARIABLES.EventExceptions
							WHERE
									eventID = #VARIABLES.RawEvents.eventID#
									AND exceptionDate like '#DateFormat(currentDay, "yyyy-mm-dd")#%'
						</cfquery>
						
						<cfif qoqGetEventException.RecordCount>
						
						<cfelse>
					
							<!--- Insert the event info into the temp query. --->
							<cfscript>
							
								// Add a new row.
								QueryAddRow(qryEvents, 1);
								
								// Add the values to the row.
								QuerySetCell(qryEvents, "eventID", VARIABLES.RawEvents.eventID);
								QuerySetCell(qryEvents, "eventName", VARIABLES.RawEvents.eventName);
								QuerySetCell(qryEvents, "eventDescription", VARIABLES.RawEvents.eventDescription);
								QuerySetCell(qryEvents, "siteID", VARIABLES.RawEvents.siteID);
								QuerySetCell(qryEvents, "departmentID", VARIABLES.RawEvents.departmentID);
								QuerySetCell(qryEvents, "departmentName", VARIABLES.RawEvents.departmentName);
								QuerySetCell(qryEvents, "eventLocationID", VARIABLES.RawEvents.eventLocationID);
								QuerySetCell(qryEvents, "eventLocation", VARIABLES.RawEvents.eventLocation);
								QuerySetCell(qryEvents, "startDate", eventDate);
								QuerySetCell(qryEvents, "endDate", VARIABLES.RawEvents.endDate);
								QuerySetCell(qryEvents, "startTime", VARIABLES.RawEvents.startTime);
								QuerySetCell(qryEvents, "endTime", VARIABLES.RawEvents.endTime);
								QuerySetCell(qryEvents, "isAllDay", VARIABLES.RawEvents.isAllDay);
								QuerySetCell(qryEvents, "recurrenceTypeID", VARIABLES.RawEvents.recurrenceTypeID);
								QuerySetCell(qryEvents, "recurrenceType", VARIABLES.RawEvents.recurrenceType);
								QuerySetCell(qryEvents, "recurrenceIndex", DateFormat(currentDay, "mm-dd-yyyy") & "_" & VARIABLES.RawEvents.eventID);
								QuerySetCell(qryEvents, "eventTypeID", VARIABLES.RawEvents.eventTypeID);
								QuerySetCell(qryEvents, "eventType",VARIABLES.RawEvents.eventType);
								QuerySetCell(qryEvents, "class", VARIABLES.RawEvents.class);
								QuerySetCell(qryEvents, "dateCreated", VARIABLES.RawEvents.dateCreated);
								QuerySetCell(qryEvents, "dateModified", VARIABLES.RawEvents.dateModified);
							
							</cfscript>
							
						</cfif>

					</cfif>
				
				<cfelseif VARIABLES.RawEvents.RecurrenceType eq "Selected Dates">
				
					<cfloop list="#VARIABLES.RawEvents.recurrenceData#" delimiters="|" index="currentDay">
					
						<!--- Check the exception events and see if there is a modified event for this date. --->
						<cfquery dbtype="query" name="qoqGetEventException">
							SELECT
									*
							FROM
									VARIABLES.EventExceptions
							WHERE
									eventID = #VARIABLES.RawEvents.eventID#
									AND exceptionDate like '#DateFormat(currentDay, "yyyy-mm-dd")#%'
						</cfquery>
						
						<cfif qoqGetEventException.RecordCount>
						
						<cfelse>
						
							<!--- Insert the event info into the temp query. --->
							<cfscript>
							
								// Add a new row.
								QueryAddRow(qryEvents, 1);
								
								// Add the values to the row.
								QuerySetCell(qryEvents, "eventID", VARIABLES.RawEvents.eventID);
								QuerySetCell(qryEvents, "eventName", VARIABLES.RawEvents.eventName);
								QuerySetCell(qryEvents, "eventDescription", VARIABLES.RawEvents.eventDescription);
								QuerySetCell(qryEvents, "siteID", VARIABLES.RawEvents.siteID);
								QuerySetCell(qryEvents, "departmentID", VARIABLES.RawEvents.departmentID);
								QuerySetCell(qryEvents, "departmentName", VARIABLES.RawEvents.departmentName);
								QuerySetCell(qryEvents, "eventLocationID", VARIABLES.RawEvents.eventLocationID);
								QuerySetCell(qryEvents, "eventLocation", VARIABLES.RawEvents.eventLocation);
								QuerySetCell(qryEvents, "startDate", currentDay);
								QuerySetCell(qryEvents, "endDate", VARIABLES.RawEvents.endDate);
								QuerySetCell(qryEvents, "startTime", VARIABLES.RawEvents.startTime);
								QuerySetCell(qryEvents, "endTime", VARIABLES.RawEvents.endTime);
								QuerySetCell(qryEvents, "isAllDay", VARIABLES.RawEvents.isAllDay);
								QuerySetCell(qryEvents, "recurrenceTypeID", VARIABLES.RawEvents.recurrenceTypeID);
								QuerySetCell(qryEvents, "recurrenceType", VARIABLES.RawEvents.recurrenceType);
								QuerySetCell(qryEvents, "recurrenceIndex", DateFormat(currentDay, "mm-dd-yyyy") & "_" & VARIABLES.RawEvents.eventID);
								QuerySetCell(qryEvents, "eventTypeID", VARIABLES.RawEvents.eventTypeID);
								QuerySetCell(qryEvents, "eventType",VARIABLES.RawEvents.eventType);
								QuerySetCell(qryEvents, "class", VARIABLES.RawEvents.class);
								QuerySetCell(qryEvents, "dateCreated", VARIABLES.RawEvents.dateCreated);
								QuerySetCell(qryEvents, "dateModified", VARIABLES.RawEvents.dateModified);
							
							</cfscript>
						
						</cfif>							
					
					</cfloop>
				
				<cfelse>
				
					<!--- Set the offset. This is the number of iterations we are away from the start date. --->
					<cfset offset = 0 />
				
					<!--- Set the current date to work with. --->
					<cfset currentDay = DateAdd(incrementType, (offset * incrementAmount), incrementFrom) />
					
					
					<!--- Loop and increment the days while we are within the requested date range. --->
					<cfloop condition="(currentDay lte incrementTo)">
					
						<cfif (
							<!--- Within window. --->
							(currentDay lte incrementTo) and 
							
							<!--- Within allowable days. ---> 
							((NOT Len(daysOfWeek)) OR ListFind(daysOfWeek, DayOfWeek(currentDay)))
						)>
						
							<!--- Check the exception events and see if there is a modified event for this date. --->
							<cfquery dbtype="query" name="qoqGetEventException">
								SELECT
										*
								FROM
										VARIABLES.EventExceptions
								WHERE
										eventID = #VARIABLES.RawEvents.eventID#
										AND exceptionDate like '#DateFormat(currentDay, "yyyy-mm-dd")#%'
							</cfquery>
							
							<!--- If an exception has been found, let's check it and see what needs to be done with it. --->
							<cfif qoqGetEventException.RecordCount>
							
								<!--- Check to see if this event has been cancelled.  If not, process it. --->
								<cfif qoqGetEventException.isCancelled eq 0>
								
									<!--- Insert the exception's data into the temp query. --->
									<cfscript>
									
										// Add a new row.
										QueryAddRow(qryEvents, 1);
										
										// Add the values to the row.
										QuerySetCell(qryEvents, "eventID", qoqGetEventException.eventID);
										QuerySetCell(qryEvents, "eventName", qoqGetEventException.eventName);
										QuerySetCell(qryEvents, "eventDescription", qoqGetEventException.eventDescription);
										QuerySetCell(qryEvents, "siteID", VARIABLES.RawEvents.siteID);
										QuerySetCell(qryEvents, "departmentID", VARIABLES.RawEvents.departmentID);
										QuerySetCell(qryEvents, "departmentName", VARIABLES.RawEvents.departmentName);
										QuerySetCell(qryEvents, "eventLocationID", qoqGetEventException.eventLocationID);
										QuerySetCell(qryEvents, "eventLocation", qoqGetEventException.eventLocation);
										QuerySetCell(qryEvents, "startDate", qoqGetEventException.exceptionDate);
										QuerySetCell(qryEvents, "endDate", VARIABLES.RawEvents.endDate);
										QuerySetCell(qryEvents, "startTime", qoqGetEventException.startTime);
										QuerySetCell(qryEvents, "endTime", qoqGetEventException.endTime);
										QuerySetCell(qryEvents, "isAllDay", qoqGetEventException.isAllDay);
										QuerySetCell(qryEvents, "recurrenceTypeID", VARIABLES.RawEvents.recurrenceTypeID);
										QuerySetCell(qryEvents, "recurrenceType", VARIABLES.RawEvents.recurrenceType);
										QuerySetCell(qryEvents, "recurrenceIndex", DateFormat(qoqGetEventException.exceptionDate, "mm-dd-yyyy") & "_" & qoqGetEventException.eventID);
										QuerySetCell(qryEvents, "eventTypeID", VARIABLES.RawEvents.eventTypeID);
										QuerySetCell(qryEvents, "eventType",VARIABLES.RawEvents.eventType);
										QuerySetCell(qryEvents, "class", VARIABLES.RawEvents.class);
										QuerySetCell(qryEvents, "dateCreated", VARIABLES.RawEvents.dateCreated);
										QuerySetCell(qryEvents, "dateModified", VARIABLES.RawEvents.dateModified);
									
									</cfscript>
								
								</cfif>
							
							<!--- Otherwise, process it normally. --->
							<cfelse>
							
								<!--- Insert the event info into the temp query. --->
								<cfscript>
								
									// Add a new row.
									QueryAddRow(qryEvents, 1);
									
									// Add the values to the row.
									QuerySetCell(qryEvents, "eventID", VARIABLES.RawEvents.eventID);
									QuerySetCell(qryEvents, "eventName", VARIABLES.RawEvents.eventName);
									QuerySetCell(qryEvents, "eventDescription", VARIABLES.RawEvents.eventDescription);
									QuerySetCell(qryEvents, "siteID", VARIABLES.RawEvents.siteID);
									QuerySetCell(qryEvents, "departmentID", VARIABLES.RawEvents.departmentID);
									QuerySetCell(qryEvents, "departmentName", VARIABLES.RawEvents.departmentName);
									QuerySetCell(qryEvents, "eventLocationID", VARIABLES.RawEvents.eventLocationID);
									QuerySetCell(qryEvents, "eventLocation", VARIABLES.RawEvents.eventLocation);
									QuerySetCell(qryEvents, "startDate", currentDay);
									QuerySetCell(qryEvents, "endDate", VARIABLES.RawEvents.endDate);
									QuerySetCell(qryEvents, "startTime", VARIABLES.RawEvents.startTime);
									QuerySetCell(qryEvents, "endTime", VARIABLES.RawEvents.endTime);
									QuerySetCell(qryEvents, "isAllDay", VARIABLES.RawEvents.isAllDay);
									QuerySetCell(qryEvents, "recurrenceTypeID", VARIABLES.RawEvents.recurrenceTypeID);
									QuerySetCell(qryEvents, "recurrenceType", VARIABLES.RawEvents.recurrenceType);
									QuerySetCell(qryEvents, "recurrenceIndex", DateFormat(currentDay, "mm-dd-yyyy") & "_" & VARIABLES.RawEvents.eventID);
									QuerySetCell(qryEvents, "eventTypeID", VARIABLES.RawEvents.eventTypeID);
									QuerySetCell(qryEvents, "eventType",VARIABLES.RawEvents.eventType);
									QuerySetCell(qryEvents, "class", VARIABLES.RawEvents.class);
									QuerySetCell(qryEvents, "dateCreated", VARIABLES.RawEvents.dateCreated);
									QuerySetCell(qryEvents, "dateModified", VARIABLES.RawEvents.dateModified);
								
								</cfscript>
							
							</cfif>							
					
						</cfif>
					
						<!--- Add one to the offset. --->
						<cfset offset = (offset + 1) />
						
						<!--- Get the next date to work with. --->
						<cfset currentDay = DateAdd(incrementType, (offset * incrementAmount), incrementFrom) />
				
					</cfloop>
				
				</cfif>
				
			</cfloop>
			
		</cfif>
		
		<!--- Filter the query results to make sure that we only get events scheduled between the specified start and end dates. --->
		<cfquery dbtype="query" name="THIS.Events">
			SELECT
					*
			FROM
					qryEvents
			WHERE
					startDate >= '#DateFormat(Arguments.StartDate, "yyyy-mm-dd 00:00:00")#'
					AND startDate <= '#DateFormat(Arguments.EndDate, "yyyy-mm-dd 23:59:00")#'
			ORDER BY
					startDate,
					startTime,
					endTime
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetRawEvents" access="private" returntype="void">
		<cfargument name="DepartmentID" type="numeric" required="no" default="0" />
	
		<cfquery datasource="#DSN#" name="VARIABLES.RawEvents" maxrows="#THIS.MaxRows#">
			SELECT
					e.eventID,
					e.eventName,
					e.eventDescription,
					e.siteID,
					e.departmentID,
					d.department AS departmentName,
					e.eventLocationID,
					el.eventLocation,
					e.startDate,
					e.endDate,
					e.startTime,
					e.endTime,
					e.isAllDay,
					e.recurrenceTypeID,
					rt.recurrenceType,
					e.recurrenceData,
					e.eventTypeID,
					et.eventType,
					et.class,
					e.dateCreated,
					e.dateModified
			FROM
					mod_AtticaEvent e INNER JOIN
					mod_AtticaRecurrenceType rt ON e.recurrenceTypeID = rt.recurrenceTypeID INNER JOIN
					mod_AtticaEventLocation el ON e.eventLocationID = el.eventLocationID INNER JOIN
					mod_AtticaEventType et ON e.eventTypeID = et.eventTypeID LEFT OUTER JOIN
					com_Department d ON e.departmentID = d.departmentID
			WHERE
					1 = 1
					AND e.isDeleted = 0
					AND e.siteID = #THIS.SiteID#

					<cfif THIS.DepartmentID gt 0>
						AND e.departmentID = #THIS.DepartmentID#
					<cfelseif Arguments.DepartmentID gt 0>
						AND e.departmentID = #Arguments.DepartmentID#
					</cfif>

			ORDER BY
					e.startDate,
					e.startTime,
					e.eventName
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetNonRecurringEvents" access="private" returntype="void">

		<cfquery dbtype="query" name="VARIABLES.NonRecurringEvents">
			SELECT
					*
			FROM
					VARIABLES.RawEvents
			WHERE
					recurrenceType = 'None'
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetEventExceptions" access="private" returntype="void">
		<cfargument name="StartDate" type="string" required="yes" default="#NullDate#" />
		<cfargument name="EndDate" type="string" required="yes" default="#NullDate#" />
		<cfargument name="DepartmentID" type="numeric" required="no" default="0" />
	
		<cfquery datasource="#DSN#" name="VARIABLES.EventExceptions">
			SELECT
					ee.eventExceptionID,
					ee.eventID,
					ee.exceptionDate,
					ee.isCancelled,
					CASE
						WHEN ee.eventName IS NULL THEN e.eventName
						ELSE ee.eventName
					END AS eventName,
					CASE
						WHEN ee.eventDescription IS NULL THEN e.eventDescription
						ELSE ee.eventDescription
					END AS eventDescription,
					CASE
						WHEN ee.startTime IS NULL THEN e.startTime
						ELSE ee.startTime
					END AS startTime,
					CASE
						WHEN ee.endTime IS NULL THEN e.endTime
						ELSE ee.endTime
					END AS endTime,
					CASE
						WHEN ee.isAllDay IS NULL THEN e.isAllDay
						ELSE ee.isAllDay
					END AS isAllDay,
					CASE
						WHEN ee.eventLocationID IS NULL THEN e.eventLocationID
						ELSE ee.eventLocationID
					END AS eventLocationID,
					CASE
						WHEN ee.eventLocationID IS NULL THEN el.eventLocation
						ELSE el2.eventLocation
					END AS eventLocation
			FROM
					mod_AtticaEventException ee INNER JOIN
					mod_AtticaEvent e ON ee.eventID = e.eventID LEFT OUTER JOIN
					mod_AtticaEventLocation el ON e.eventLocationID = el.eventLocationID LEFT OUTER JOIN
					mod_AtticaEventLocation el2 ON ee.eventLocationID = el2.eventLocationID
			WHERE
					1 = 1
					
					<cfif VARIABLES.RawEvents.RecordCount>
						AND ee.eventID IN
						(
							#ValueList(VARIABLES.RawEvents.eventID, ',')#
						)
					</cfif>
					
					<cfif IsDate(Arguments.StartDate)>
						AND ee.exceptionDate >= '#DateFormat(Arguments.StartDate, "yyyy-mm-dd")#'
					</cfif>
					
					<cfif isDate(Arguments.EndDate)>
						AND ee.exceptionDate <= '#DateFormat(Arguments.EndDate, "yyyy-mm-dd")#'
					</cfif>

					<cfif THIS.DepartmentID gt NullInt>
						AND e.departmentID = #THIS.DepartmentID#
					<cfelseif Arguments.DepartmentID gt 0>
						AND e.departmentID = #Arguments.DepartmentID#
					</cfif>
		</cfquery>

	</cffunction>
	
	<cffunction name="GetEventByID" access="public" returntype="query">
		<cfargument name="EventID" type="numeric" required="yes" default="#NullInt#" />
		
		<cfquery datasource="#DSN#" name="qryGetEventByID">
			SELECT
					e.eventID,
					e.eventName,
					e.eventDescription,
					e.siteID,
					e.departmentID,
					d.department AS departmentName,
					e.eventLocationID,
					el.eventLocation,
					e.startDate,
					e.endDate,
					e.startTime,
					e.endTime,
					e.isAllDay,
					e.recurrenceTypeID,
					rt.recurrenceType,
					e.eventTypeID,
					et.eventType,
					et.class,
					e.dateCreated,
					e.dateModified
			FROM
					mod_AtticaEvent e INNER JOIN
					mod_AtticaRecurrenceType rt ON e.recurrenceTypeID = rt.recurrenceTypeID INNER JOIN
					mod_AtticaEventLocation el ON e.eventLocationID = el.eventLocationID INNER JOIN
					mod_AtticaEventType et ON e.eventTypeID = et.eventTypeID LEFT OUTER JOIN
					com_Department d ON e.departmentID = d.departmentID
			WHERE
					e.eventID = #Arguments.EventID#
		</cfquery>
		
		<cfreturn qryGetEventByID />
		
	</cffunction>
	
	<cffunction name="GetDepartments" access="public" returntype="query">
		
		<cfquery datasource="#DSN#" name="qryGetDepartments">
			SELECT
					d.departmentID,
					d.department
			FROM
					com_Department d INNER JOIN
					mod_AtticaDepartment ad ON d.departmentID = ad.departmentID
			WHERE
					d.isActive = 1
					AND ad.isActive = 1
					
					<cfif THIS.DepartmentID gt 0>
						AND d.departmentID = #THIS.DepartmentID#
					</cfif>
			ORDER BY
					d.department
		</cfquery>
		
		<cfreturn qryGetDepartments />
		
	</cffunction>

</cfcomponent>