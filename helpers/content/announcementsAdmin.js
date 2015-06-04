$(function() {

	// Hide all the editor rows and show the correct one.
	$('.spnEditAnnouncement').click(function() {
		var announcementID = $(this).attr('announcementID');
		
		$('.adminEditorRow').hide();
		$('#trAnnouncementEditor' + announcementID).show();
	});
	
	// Show the 'Create New Announcement' editor row.
	$('#spnAddNewAnnouncement').click(function() {
		$('#trAnnouncementEditorNew').show();
	});

	// Delete an announcement.
	$('.spnDeleteAnnouncement').click(function() {
		var announcementID = $(this).attr('announcementID');
		
		// Make sure the user really wants to delete this announcement.
		var answer = confirm('Are you sure?');
		if(answer)
		{
			$.ajax(
					{
						type: 'get',
						url: URLRoot + 'cfc/content/announcements.cfc',
						data: {
							method: 'ajaxDeleteAnnouncement',
							AnnouncementID: announcementID
						},
						dataType: 'json',
						success: function(retVal) {

							// Reload the page to reflect the changes.
							window.location.reload()
							
						},
						error: function(){
							// Show the error dialog.
							$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Your request could not be completed.</p>').dialog('open');
						}
					}
				);
		}
		else
		{
		}
	});
	
	// Hide this editor row.
	$('.CancelButton').click(function() {
		var announcementID = $(this).attr('announcementID');
		
		$('#trAnnouncementEditor' + announcementID).hide();
	});
	
	// Hide the 'Create New Announcement' editor row.
	$('#CancelButtonNew').click(function() {
		$('#trAnnouncementEditorNew').hide();
	});

	// Toggle the ShowOnHomePage button.
	$('.btnToggle').click(function() {
		var hiddenField = $(this).attr('hiddenField');
		var toggleValue = $('#' + hiddenField).attr('value');
		
		// If it is set to no, mark it yes.
		if(toggleValue == 0)
		{
			$(this).attr('src', URLRoot + 'admin/images/toggleButtonYes.png');
			$('#' + hiddenField).attr('value', '1');
		}
		else
		{
			$(this).attr('src', URLRoot + 'admin/images/toggleButtonNo.png');
			$('#' + hiddenField).attr('value', '0');
		}
	});

	// Save the changes.
	$('.SaveButton').click(function() {
		var announcementID = $(this).attr('announcementID');
		var numErrors = 0;

		// Get the title and validate it.
		var title = $('#txtTitle' + announcementID).val();
		if($.trim(title) == '')
		{
			$('#valTitle' + announcementID).show();
			$('#valSummary' + announcementID).show();
			numErrors++;
		}
		else
		{
			$('#valTitle' + announcementID).hide();
		}
		
		// Get the ShowOnHomePage value
		var showOnHomePage = $('#rdoShowOnHomePage' + announcementID).val();
		
		// Get the start date and validate it. TODO: Use RegEx to make sure it's a date
		var startDate = $('#txtStartDate' + announcementID).val();
		if($.trim(startDate) == '')
		{
			$('#valStartDate' + announcementID).show();
			$('#valSummary' + announcementID).show();
			numErrors++;
		}
		else
		{
			$('#valStartDate' + announcementID).hide();
		}
		
		// Get the end date and validate it. TODO: Use RegEx to make sure it's a date
		var endDate = $('#txtEndDate' + announcementID).val();
		if($.trim(endDate) == '')
		{
			$('#valEndDate' + announcementID).show();
			$('#valSummary' + announcementID).show();
			numErrors++;
		}
		else
		{
			$('#valEndDate' + announcementID).hide();
		}
		
		// Get the abstract and validate it.
		var abstract = $('#txtaAbstract' + announcementID).val();
		if($.trim(abstract) == '')
		{
			$('#valAbstract' + announcementID).show();
			$('#valSummary' + announcementID).show();
			numErrors++;
		}
		else
		{
			$('#valAbstract' + announcementID).hide();
		}
		
		// Get the text and validate it.
		var text = $('#txtaText' + announcementID).val();
		if($.trim(text) == '')
		{
			$('#valText' + announcementID).show();
			$('#valSummary' + announcementID).show();
			numErrors++;
		}
		else
		{
			$('#valText' + announcementID).hide();
		}
		
		// If there were no errors, save the changes.
		if(numErrors == 0)
		{
			$.ajax(
					{
						type: 'get',
						url: URLRoot + 'cfc/content/announcements.cfc',
						data: {
							method: 'ajaxEditAnnouncement',
							AnnouncementID: announcementID,
							Title: title,
							Abstract: abstract,
							Text: text,
							StartDate: startDate,
							EndDate: endDate,
							ShowOnHomePage: showOnHomePage,
							AnnouncementIconID: 0
						},
						dataType: 'json',
						success: function() {
							
							// Reload the page to reflect the changes.
							window.location.reload()
							
						},
						error: function(){
							// Show the error dialog.
							$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Your request could not be completed.</p>').dialog('open');
						}
					}
				);
		}

	});

	// Save a new announcement.
	$('#SaveButtonNew').click(function() {
		var announcementBannerID = $('#hdnAnnouncementBannerID').val();
		var numErrors = 0;

		// Get the title and validate it.
		var title = $('#txtTitleNew').val();
		if($.trim(title) == '')
		{
			$('#valTitleNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valTitleNew').hide();
		}
		
		// Get the ShowOnHomePage value
		var showOnHomePage = $('#rdoShowOnHomePageNew').val();
		
		// Get the start date and validate it. TODO: Use RegEx to make sure it's a date
		var startDate = $('#txtStartDateNew').val();
		if($.trim(startDate) == '')
		{
			$('#valStartDateNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valStartDateNew').hide();
		}
		
		// Get the end date and validate it. TODO: Use RegEx to make sure it's a date
		var endDate = $('#txtEndDateNew').val();
		if($.trim(endDate) == '')
		{
			$('#valEndDateNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valEndDateNew').hide();
		}
		
		// Get the abstract and validate it.
		var abstract = $('#txtaAbstractNew').val();
		if($.trim(abstract) == '')
		{
			$('#valAbstractNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valAbstractNew').hide();
		}
		
		// Get the text and validate it.
		var text = $('#txtaTextNew').val();
		if($.trim(text) == '')
		{
			$('#valTextNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valTextNew').hide();
		}
		
		// If there were no errors, save the changes.
		if(numErrors == 0)
		{
			$.ajax(
					{
						type: 'get',
						url: URLRoot + 'cfc/content/announcements.cfc',
						data: {
							method: 'ajaxCreateAnnouncement',
							AnnouncementBannerID: announcementBannerID,
							Title: title,
							Abstract: abstract,
							Text: text,
							StartDate: startDate,
							EndDate: endDate,
							ShowOnHomePage: showOnHomePage,
							AnnouncementIconID: 0
						},
						dataType: 'json',
						success: function(retVal) {
							// Reload the page to reflect the changes.
							window.location.reload()
						},
						error: function(retVal){
							// Show the error dialog.
							$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Your request could not be completed.</p>').dialog('open');
						}
					}
				);
		}

	});

});
