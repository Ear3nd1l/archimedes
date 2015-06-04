<!--- Define variables. --->
<cfparam name="Attributes.PageModuleID" default="0" type="numeric" />
<cfparam name="Attributes.cfcPath" default="" type="string" />
<cfparam name="form.ddlDepartmentID" default="0" type="numeric" />
<cfparam name="url.did" default="0" type="numeric" />
<cfparam name="url.uuid" default="#DateFormat(Now(), 'mm')##DateFormat(Now(), 'yyyy')#" type="string" />
<cfparam name="url.offset" default="0" type="numeric" />

<!--- Create the object and initialize it. --->
<cfobject component="#Attributes.cfcPath#" name="Attica" />
<cfset Attica.Init(Attributes.PageModuleID) />

<!---
		The next and previous buttons add the department to the query string.
		If this is the case, set the form value to the query string value.
--->
<cfif url.did gt 0 AND form.ddlDepartmentID eq 0>
	<cfset form.ddlDepartmentID = url.did />
</cfif>

<!---
		Get a list of departments.
		If this module is specific to a department, it will only return the assigned department's info.
--->
<cfset qryDepartments = Attica.GetDepartments() />

<!--- Split the month and year from the query string variable. --->
<cfset suppliedMonth = Left(url.uuid, 2) />
<cfset suppliedYear = Right(url.uuid, 4) />

<!--- Validate the variables and replace them with the current date if invalid. --->
<cfif Not IsNumeric(suppliedMonth) OR Not IsNumeric(suppliedYear)>
	<cfset suppliedMonth = DateFormat(Now(), 'mm') />
	<cfset suppliedYear = DateFormat(Now(), 'yyyy') />
</cfif>

<!--- Validate the offset value --->
<cfif NOT isNumeric(url.offset)>
	<cfset url.offset = 0 />
</cfif>

<!---
		If this module is specific to a department, and the filter select box has not been changed, make sure that the assigned department is selected in the select box.
		We use the FieldNames key because if a form is submitted via JavaScript, the button is not added to the structure.
--->
<cfif NOT StructKeyExists(form, 'fieldNames') AND Attica.DepartmentID neq 0>
	<cfset form.ddlDepartmentID = Attica.DepartmentID />
</cfif>

<!---
		Set the current month, previous month and next month values.
		Default each date to the first of the month.
--->
<cfset thisMonth = suppliedMonth & "/01/" & suppliedYear />
<cfset previousMonth = DateAdd('m', -1, thisMonth) />
<cfset nextMonth = DateAdd('m', 1, thisMonth) />

<!---
		Set the last day of the month.
		Set the first and last days that are shown in a month view.
		These values may not be in the current month.
--->
<cfset lastDayOfMonth = DateAdd('d', -1, nextMonth) />
<cfset firstCalendarDay = DateAdd('d', (DayOfWeek(thisMonth) - 1) * -1, thisMonth) />
<cfset lastCalendarDay = DateAdd('d', (6 - DayOfWeek(lastDayOfMonth)), nextMonth) />

<!--- Set the first and last day of the week for the list view used for non-JavaScript enabled users. --->
<cfset firstDayOfWeek = DateAdd('d', (DayOfWeek(Now()) - 1) * -1, Now()) />
<cfset lastDayOfWeek = DateAdd('d', 7 - DayOfWeek(Now()), Now()) />

<!--- Offset the week beginning and end. --->
<cfset firstDayOfWeek = DateAdd('d', url.offset, firstDayOfWeek) />
<cfset lastDayOfWeek = DateAdd('d', url.offset, lastDayOfWeek) />

<!--- Get the events. --->
<cfset Attica.GetEvents(thisMonth, lastDayOfMonth, form.ddlDepartmentID) />

<!---
		Get a list of all the dates that have events.
		This will be a more efficient manner of querying the events for each day.
--->
<cfset lstEventDates = ValueList(Attica.Events.startDate) />

<cfoutput>

	<!--- Create the select box that will be used to filter events by department. --->
	<div id="divCalendarFilter">
		<form method="post" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" id="frmFilterEvents">
		
			<span>Filter events by department:</span>
			<select id="ddlDepartmentID" name="ddlDepartmentID">
				<option selected="selected" value="0">All Departments</option>
				<cfloop query="qryDepartments">
					<option value="#qryDepartments.departmentID#" <cfif form.ddlDepartmentID eq qryDepartments.departmentID>selected="selected"</cfif>>#qryDepartments.department#</option>
				</cfloop>
			</select>
			
			<input type="submit" value="Filter" id="btnSubmitFilter" />
		
		</form>
	</div>
	
	<div class="viewSwitcher">
		<span class="viewMonth">Month</span>
		<span class="viewWeek">Week</span>
	</div>

	<div class="monthView">

		<h3>#DateFormat(thisMonth, "mmmm, yyyy")#</h3>
		
		<div class="monthContainer" id="monthContainer#Attributes.PageModuleID#">
		
			<div class="monthNavigation">
				<a href="?uuid=#DateFormat(previousMonth, 'mmyyyy')#&did=#form.ddlDepartmentID#" class="monthPrevious">&lt;</a>
				<a href="?uuid=#DateFormat(Now(), 'mmyyyy')#&did=#form.ddlDepartmentID#" class="monthToday">Today</a>
				<a href="?uuid=#DateFormat(nextMonth, 'mmyyyy')#&did=#form.ddlDepartmentID#" class="monthNext">&gt;</a>
			</div>
		
			<div class="daysOfWeekHeader">
				<div class="daysOfWeekHeaderItem">Sunday</div>
				<div class="daysOfWeekHeaderItem">Monday</div>
				<div class="daysOfWeekHeaderItem">Tuesday</div>
				<div class="daysOfWeekHeaderItem">Wednesday</div>
				<div class="daysOfWeekHeaderItem">Thursday</div>
				<div class="daysOfWeekHeaderItem">Friday</div>
				<div class="daysOfWeekHeaderItem">Saturday</div>
				<div class="clear"></div>
			</div>
			
			<!--- Loop through every day on the calendar. --->
			<cfloop from="#firstCalendarDay#" to="#lastCalendarDay#" index="day" step="1">
				
				<!--- If the day is today, add the 'today' class to the cell. --->
				<cfif DateFormat(day, "mm/dd/yyyy") eq DateFormat(Now(), "mm/dd/yyyy")>
					<cfset cellClasses = "dayCell today" />
				<cfelse>
					<cfset cellClasses = "dayCell" />
				</cfif>
				
				<!--- If the day is not in the current month, add the 'notCurrentMonth' class to the cell. --->
				<cfif DateFormat(day, "mm") neq DateFormat(thisMonth, "mm")>
					<cfset cellClasses = cellClasses & " notCurrentMonth" />
				</cfif>
				
				<!--- Output the days and events --->
				<cfswitch expression="#DayOfWeek(day) MOD 7#">
				
					<cfcase value="1">
						<!--- Since this is sunday, create the new row. --->
						<div class="weekRow">
							<div class="sunday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
					
					<cfcase value="2">
						<div class="monday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
				
					<cfcase value="3">
						<div class="tuesday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
				
					<cfcase value="4">
						<div class="wednesday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
				
					<cfcase value="5">
						<div class="thursday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
				
					<cfcase value="6">
						<div class="friday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
				
					<cfcase value="0">
						<div class="saturday #cellClasses#" id="cell#DateFormat(day, 'mmddyyyy')#">
					</cfcase>
				
				</cfswitch>
				
				<!--- Output the numeric day. --->
				#DateFormat(day, "dd")# 
				
				<!--- If the user has access to add new events, create the button. --->
				<cfif DateFormat(day, "mm") eq DateFormat(thisMonth, "mm") AND Attica.UserHasAccess()>
					<span class="spnAddEvent" cellID="cell#DateFormat(day, 'mmddyyyy')#">+</span>
				</cfif>
				
				<!--- Check to see if this day has any events. --->
				<cfif ListFind(lstEventDates, DateFormat(day, "yyyy-mm-dd"))>
				
					<!--- If so, get the events from the query. --->
					<cfquery dbtype="query" name="qoqGetDayEvents">
						SELECT
								eventName,
								recurrenceIndex,
								class,
								startTime,
								endTime
						FROM
								Attica.Events
						WHERE
								startDate = '#DateFormat(day, "yyyy-mm-dd")#'
					</cfquery>
					
					<!--- Output the events. --->
					<cfloop query="qoqGetDayEvents">
					
						<p class="evtItem #qoqGetDayEvents.class#" eventCode="#qoqGetDayEvents.RecurrenceIndex#">
							<span class="calStartTime">#TimeFormat(qoqGetDayEvents.startTime, "h:mm tt")#</span>
							<span class="calEndTime">#TimeFormat(qoqGetDayEvents.endTime, "h:mm tt")#</span>
							<span class="calEventName">#eventName#</span>
						</p>
						
					</cfloop>
					
				</cfif>
				
				</div>
				
				<!--- If this is saturday, close the row. --->
				<cfif DayOfWeek(day) MOD 7 eq 0>
					</div>
				</cfif>
				
			</cfloop>
			
			<div class="clear"></div>
			
		</div>
	
	</div>
	
</cfoutput>

	
	<div class="weekView jsHide">
	
		<!--- Get the events for the current week. --->
		<cfset Attica.GetEvents(firstDayOfWeek, lastDayOfWeek, form.ddlDepartmentID) />
		
		<!---
				The week view is split into two columns.
				Find out how many events go in the first column.
		--->
		<cfset numPerColumn = Round(Attica.Events.RecordCount / 2) />
		
		<!--- Output the starting date of the week. --->
		<h3>Events for the Week Starting <cfoutput>#DateFormat(firstDayOfWeek, 'mmmm dd, yyyy')#</cfoutput></h3>
		
		<cfoutput>
			<div class="monthNavigation">
				<a href="?offset=#(url.offset - 7)#" class="monthPrevious">&lt;</a>
				<a href="?offset=0" class="monthToday">Today</a>
				<a href="?offset=#(url.offset + 7)#" class="monthNext">&gt;</a>
			</div>
		</cfoutput>

		<div class="weekContainer">
		
			<div class="weekLeftColumn">
		
				<!--- Loop through the query, grouped by the start date. --->
				<cfoutput query="Attica.Events" group="StartDate">
				
					<!--- Create a heading for the day --->
					<h4 class="weekDayHeading">#DayOfWeekAsString(DayOfWeek(Attica.Events.StartDate))# #DateFormat(Attica.Events.StartDate, 'mmmm dd, yyyy')#</h4>
				
					<!--- Output the events. --->
					<cfoutput>
						<div class="weekEventItem #Attica.Events..class#">
							
							<div class="evtDetailsLeftContainer">
							
								<span class="evtDetailLabel">Event Name</span>
								<span class="evtDetailValue">#Attica.Events.EventName#</span>
								
								<span class="evtDetailLabel">Description</span>
								<span class="evtDetailValue">#Attica.Events.eventDescription#</span>
							
							</div>
							
							<div class="evtDetailsRightContainer">
							
								<div class="evtDetailsLeftContainer">
							
									<span class="evtDetailLabel">Date</span>
									<span class="evtDetailValue">#DateFormat(Attica.Events.startDate, "mmmm dd, yyyy")#</span>
									
								</div>
								
								<div class="evtDetailsRightContainer">
								
									<span class="evtDetailLabel">Start Time</span>
									<span class="evtDetailValue">#TimeFormat(Attica.Events.startTime, "h:mm tt")#</span>
									
									<cfif Attica.Events.IsAllDay eq 1>
										<span class="evtDetailValue">This is an all day event.</span>
									<cfelse>
										<span class="evtDetailLabel">End Time</span>
										<span class="evtDetailValue">#TimeFormat(Attica.Events.EndTime, "h:mm tt")#</span>
									</cfif>
									
								</div>
								
								<div class="evtDetailsFullContainer">
								
									<span class="evtDetailLabel">Location</span>
									<span class="evtDetailValue">#Attica.Events.eventLocation#</span>
									
								</div>
								
							</div>
							
							<div class="clear"></div>
				
						</div>
						
						<!--- If the current row is the last event in the left column, close it and start the right column. --->
						<cfif Attica.Events.CurrentRow eq numPerColumn>
						
							</div>
							
							<div class="weekRightColumn">
						
						</cfif>
						
					</cfoutput>
					
				</cfoutput>
			
			</div>
			
			<div class="clear"></div>
		
		</div>
	
	</div>
	
<cfoutput>
	
	<script>
	
		// Define variables
		var pmid = #Attributes.PageModuleID#;
	
		$(function() {
			
			/*
				Create the hover function for the cells.
				Exclude the cells that are not part of the current month.
			*/
			$('.dayCell').not('.notCurrentMonth').hover(
					function() {
						
						// Remove any active hovered cells.
						$('.dayCellHover').remove();
						
						// Get the cellID
						var cellID = $(this).attr('id');
						
						// Get the current position of this item.
						var position = $(this).position();
						
						// Create a clone of the cell, add the hover class to it, set its position and append it to the month container so it is positioned correctly.
						$('##' + cellID).clone().addClass('dayCellHover').css({'left': position.left + 'px', 'top': position.top + 'px'}).appendTo('##monthContainer#Attributes.PageModuleID#');
						
						// Add click event functions to the cloned event items.
						$('.evtItem').click(function() {
							
							// Append a lightbox item for viewing the details.
							$(document.body).append('<div id="divEventView" class="lightBox"><iframe id="ifEventDetails" frameborder="0" width="100%" height="100%" src="" class="evtIFrame" /></div>');
							
							// Get the event code
							var eventCode = $(this).attr('eventCode');
							
							// Set the source of the iframe with the event code.
							$('##ifEventDetails').attr('src', URLRoot + 'helpers/content/calendar/atticaEventDetails.cfm?eventCode=' + eventCode + '&pmid=' + pmid);
							
							// Show the lightbox.
							$.lightbox({
								divID: 		'divEventView',
								fadeSpeed:	'medium'
							})
						});
						
						// Add click event to the Add New Event button.
						$('.spnAddEvent').click(function() {
							
							// Append a lightbox item for creating an event.
							$(document.body).append('<div id="divEventEditor" class="lightBox"><iframe id="ifCreateEvent" frameborder="0" width="100%" height="100%" src="" class="evtIFrame" /></div>');							
							
							// Get the cellID
							var cellID = $(this).attr('cellID');
							
							// Set the source of the iframe with the cellID.
							$('##ifEventDetails').attr('src', URLRoot + 'helpers/content/calendar/atticaCreateEvent.cfm?cellID=' + cellID + '&pmid=' + pmid);

							// Show the lightbox.
							$.lightbox({
								divID: 		'divEventEditor',
								fadeSpeed:	'medium'
							})

						});
					}
			);
			
			// Hide the submit button because the select box will auto submit.
			$('##btnSubmitFilter').hide();
			
			// Move this to the master page.
			$('.jsHide').hide();
			
			// Show the month view.
			$('.monthView').show();/**/
			
			// Add an auto submit to the select box.
			$('##ddlDepartmentID').change(function() {
				$('##frmFilterEvents').submit();
			});
			
			$('.viewMonth').click(function() {
				$('.weekView').hide();
				$('.monthContainer').show();
			});
			
			$('.viewWeek').click(function() {
				$('.weekView').show();
				$('.monthContainer').hide();
			});
			
		});
	
	</script>

</cfoutput>