<cftry>

	<!---
			TODO:
				
				Add Exception processing for Every nth Day and Specified Days recurrence types.
	--->

	<cfinclude template="#Application.URLRoot#helpers/admin/frontEndEditorConfig.cfm" />

	<cfobject component="ArchimedesCFC.calendar.attica" name="Attica" />
	<cfif IsNumeric(url.pmid)>
	
		<cfset Attica.Init(url.pmid) />
		<cfset eventStruct = Attica.GetEventByEventCode(url.eventCode) />
		
		<cfoutput>
		
			<div id="divEventDetails" class="evtContainer">
			
				<h3 class="evtHeading">Event Details</h3>
			
				<div class="evtDetailsLeftContainer MainContainer">
				
					<cfif eventStruct.IsException>
						<span class="evtImportant">This event is part of a series and has been modified from the original.</span>
					</cfif>
					
					<span class="evtDetailLabel">Event Name</span>
					<span class="evtDetailValue">#eventStruct.EventName#</span>
					
					<span class="evtDetailLabel">Description</span>
					<span class="evtDetailValue">#eventStruct.eventDescription#</span>
				
				</div>
				
				<div class="evtDetailsRightContainer MainContainer">
				
					<div class="evtDetailsLeftContainer">
				
						<span class="evtDetailLabel">Date</span>
						<span class="evtDetailValue">#DateFormat(eventStruct.eventDate, "mmmm dd, yyyy")#</span>
						
					</div>
					
					<div class="evtDetailsRightContainer">
					
						<span class="evtDetailLabel">Start Time</span>
						<span class="evtDetailValue">#TimeFormat(eventStruct.startTime, "h:mm tt")#</span>
						
						<cfif eventStruct.IsAllDay eq 1>
							<span class="evtDetailValue">This is an all day event.</span>
						<cfelse>
							<span class="evtDetailLabel">End Time</span>
							<span class="evtDetailValue">#TimeFormat(eventStruct.EndTime, "h:mm tt")#</span>
						</cfif>
						
					</div>
					
					<div class="evtDetailsFullContainer">
					
						<span class="evtDetailLabel">Location</span>
						<span class="evtDetailValue">#eventStruct.eventLocation#</span>
						
					</div>
					
				</div>
				
				<div class="clear"></div>
			
			</div>
			
			<cfif Attica.UserHasAccess()>
				
				<cfif eventStruct.RecurrenceType eq "None">
					<span id="lnkEditNonRecurringEvent">Edit</span>
				<cfelse>
			
					<span id="lnkEditRecurringEvent">Edit</span>
					<ul id="ulEditEventMenu">
						<li id="lnkEditEventSeries" class="liEditEventMenuItem">Edit Series</li>
						<li id="lnkEditEventItem" class="liEditEventMenuItem">Edit This Item</li>
					</ul>
				
				</cfif>
					
				<div id="divEditEvent">
				
				</div>
				
			</cfif>
			
			<div class="evtDetailsFullContainer">
				<img id="btnClose" src="#Application.URLRoot#admin/images/closeButton.png" alt="Close" title="Close" width="89" border="0" />
			</div>
		
		</cfoutput>
		
		<script>
		
			$(function() {
				// Add a click event to the Close button on the lightbox to close it.
				$('#btnClose').click(function() {
					iFrameCloseLightbox({divID: 'divEventView', fadeSpeed: 'medium'});
				});
		
			});
		</script>
		
	<cfelse>
	
		<h2>Invalid Event Code</h2>
		<cfabort />
	
	</cfif>
	
	<cfcatch><h2>Invalid Event Code</h2></cfcatch>

</cftry>