<cfparam name="url.uuid" default="#DateFormat(Now(), 'mm')##DateFormat(Now(), 'yyyy')#" type="string" />

<!--- Split the month and year from the query string variable. --->
<cfset suppliedMonth = Left(url.uuid, 2) />
<cfset suppliedYear = Right(url.uuid, 4) />

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

<div class="monthView">

	<div class="monthContainer" id="monthContainer">
	
		<cfoutput>
		
		<div class="monthNavigation">
			<a href="?uuid=#DateFormat(previousMonth, 'mmyyyy')#" class="monthPrevious">&lt;</a>
			<span class="currentMonth">#DateFormat(thisMonth, "mmmm, yyyy")#</span>
			<!---<a href="?uuid=#DateFormat(Now(), 'mmyyyy')#" class="monthToday">Today</a>--->
			<a href="?uuid=#DateFormat(nextMonth, 'mmyyyy')#" class="monthNext">&gt;</a>
		</div>
		
		<div class="clear"></div>
	
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
			
			</div>
			
			<!--- If this is saturday, close the row. --->
			<cfif DayOfWeek(day) MOD 7 eq 0>
				</div>
			</cfif>
			
		</cfloop>
		
		</cfoutput>
		
		<div class="clear"></div>
		
	</div>

</div>
