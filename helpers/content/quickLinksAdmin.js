$(function() {

	// Hide the sortable list
	$('#ulSortableLinks').hide();
	$('#spnSaveSort').hide();
	$('#spnCancelSort').hide();

	// Hide all the editor rows and show the correct one.
	$('.spnEditLink').click(function() {
		var linkID = $(this).attr('linkID');
		
		$('.adminEditorRow').hide();
		$('#trLinkEditor' + linkID).show();
	});
	
	// Show the 'Create New Announcement' editor row.
	$('#spnAddNewLink').click(function() {
		$('#trLinkEditorNew').show();
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

	// Hide this editor row.
	$('.CancelButton').click(function() {
		var linkID = $(this).attr('linkID');
		
		$('#trLinkEditor' + linkID).hide();
	});
	
	// Hide the 'Create New Announcement' editor row.
	$('#CancelButtonNew').click(function() {
		$('#trLinkEditorNew').hide();
	});

	// Save the changes.
	$('.SaveButton').click(function() {
		var linkID = $(this).attr('linkID');
		var numErrors = 0;

		// Get the link text and validate it.
		var linkText = $('#txtLinkText' + linkID).val();
		if($.trim(linkText) == '')
		{
			$('#valLinkText' + linkID).show();
			$('#valSummary' + linkID).show();
			numErrors++;
		}
		else
		{
			$('#valLinkText' + linkID).hide();
		}
		
		// Get the isNewWindow value
		var isNewWindow = $('#rdoIsNewWindow' + linkID).val();
		
		// Get the url and validate it. TODO: Use RegEx to make sure this is a URL
		var url = $('#txtURL' + linkID).val();
		if($.trim(url) == '')
		{
			$('#valURL' + linkID).show();
			$('#valSummary' + linkID).show();
			numErrors++;
		}
		else
		{
			$('#valURL' + linkID).hide();
		}
		
		// If there were no errors, save the changes.
		if(numErrors == 0)
		{
			$.ajax(
					{
						type: 'get',
						url: URLRoot + 'cfc/content/quickLinks.cfc',
						data: {
							method: 'ajaxEditLink',
							LinkID: linkID,
							LinkText: linkText,
							URL: url,
							IsNewWindow: isNewWindow
						},
						dataType: 'json',
						success: function() {
							
							// Reset the field values because they are persistent in Firefox and other browsers.
							$('#txtLinkText').val('');
							$('#txtURL').val('');
							
							// Reload the page to reflect the changes.
							window.location.reload();
							
						},
						error: function(){
							// Show the error dialog.
							$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Your request could not be completed.</p>').dialog('open');
						}
					}
				);
		}

	});

	// Save the changes.
	$('#SaveButtonNew').click(function() {
		var numErrors = 0;

		// Get the link text and validate it.
		var linkText = $('#txtLinkTextNew').val();
		if($.trim(linkText) == '')
		{
			$('#valLinkTextNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valLinkTextNew').hide();
		}
		
		// Get the isNewWindow value
		var isNewWindow = $('#rdoIsNewWindowNew').val();
		
		// Get the url and validate it. TODO: Use RegEx to make sure this is a URL
		var url = $('#txtURLNew').val();
		if($.trim(url) == '')
		{
			$('#valURLNew').show();
			$('#valSummaryNew').show();
			numErrors++;
		}
		else
		{
			$('#valURLNew').hide();
		}
		
		// If there were no errors, save the changes.
		if(numErrors == 0)
		{
			$.ajax(
					{
						type: 'get',
						url: URLRoot + 'cfc/content/quickLinks.cfc',
						data: {
							method: 'ajaxCreateLink',
							QuickLinksID: $('#hdnQuickLinksID').val(),
							LinkText: linkText,
							URL: url,
							IsNewWindow: isNewWindow
						},
						dataType: 'json',
						success: function() {
							
							// Reload the page to reflect the changes.
							window.location.reload();
							
						},
						error: function(){
							// Show the error dialog.
							$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Your request could not be completed.</p>').dialog('open');
						}
					}
				);
		}

	});

	// Delete a link.
	$('.spnDeleteLink').click(function() {
		var linkID = $(this).attr('linkID');
		
		// Make sure the user really wants to delete this link.
		var answer = confirm('Are you sure?');
		if(answer)
		{
			$.ajax(
					{
						type: 'get',
						url: URLRoot + 'cfc/content/quickLinks.cfc',
						data: {
							method: 'ajaxDeleteLink',
							LinkID: linkID
						},
						dataType: 'json',
						success: function(retVal) {

							// Reload the page to reflect the changes.
							window.location.reload();
							
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

	$('#spnSortLinks').click(function() {
		$('.tblData').hide();
		$('#spnAddNewLink').hide();
		$('#spnSortLinks').hide();
		$('#spnSaveSort').show();
		$('#spnCancelSort').show();
		$('#ulSortableLinks').show().sortable({
			cursor: 'pointer',
			opacity: 0.7,
			revert: true,
			scroll: true
		}).disableSelection();
	});
	
	$('#spnSaveSort').click(function() {
		var orderList = $('#ulSortableLinks').sortable('toArray');

		// Use AJAX to save the sort order.
		$.ajax(
		{
			type: 'get',
			url: URLRoot + 'cfc/content/quickLinks.cfc',
			data: {
					method: 'ajaxUpdateSortOrder',
					OrderList: orderList
			},
			dataType: 'json',
			success: function(retVal) {
				if(retVal == true)
				{
					window.location.reload();
				}
				else {
					$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>There was an error processing your request. Please try again.</p>').dialog('open');
				}
			},
			error: function(retVal) {
				$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>There was an error processing your request. Please try again.</p>').dialog('open');
			}
		});

	});
	
	$('#spnCancelSort').click(function() {
		window.location.reload();
	});

});
