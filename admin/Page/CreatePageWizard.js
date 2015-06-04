// JavaScript Document
$(function() {
	
	// Round the corners and hide all the panels
	$('.wizardPanel').corners('10px;').hide();
	
	if(showErrorPanel == true)
	{
		$('#pnlError').show();
	}
	else
	{
		// Show the first panel
		$('#pnlStep0').show();
	}
	
	// Hide the validation markers
	$('.validationErrorMarker').hide();
	
	$('#lnkStep0Next').click(function() {
		$('#spnPageParent').html($('select[id=ddlParentID] option:selected').attr('menuTitle'));
		$('#pnlStep0').hide('slide', {direction: 'up'}, 500);
		$('#pnlStep1').show('slide', {direction: 'down'}, 500);
	});
	
	// Panel 1 Next button click event 
	$('#lnkStep1Next').click(function() {
									  
		// Get the field value so we can validate it.
		var fieldValue = jQuery.trim($('#txtPageTitle').attr('value'));
		
		// If the field has a value, update the summary panel and move to the next panel.
		if ( fieldValue.length > 0)
		{
			$('#spnPageTitle').html($('#txtPageTitle').attr('value'));
			$('#pnlStep1').hide('slide', {direction: 'up'}, 500);
			$('#pnlStep2').show('slide', {direction: 'down'}, 500);
			$('#txtPageTitle').removeClass('validationErrorTextBox');
			$('#valPageTitle').hide();
		}
		
		// Otherwise, highlight the textbox and show the error marker.
		else
		{
			$('#txtPageTitle').addClass('validationErrorTextBox');
			$('#valPageTitle').show();
		}
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep1Back').click(function() {
		$('#pnlStep0').show('slide', {direction: 'up'}, 500);
		$('#pnlStep1').hide('slide', {direction: 'down'}, 500);
	});

// Panel 2 Next button click event
	$('#lnkStep2Next').click(function() {

		// Get the field value so we can validate it.
		var fieldValue = jQuery.trim($('#txtMenuTitle').attr('value'));
		
		// If the field has a value, update the summary panel and move to the next panel.
		if ( fieldValue.length > 0)
		{
			$('#spnMenuTitle').html($('#txtMenuTitle').attr('value'));
			$('#pnlStep2').hide('slide', {direction: 'up'}, 500);
			$('#pnlStep3').show('slide', {direction: 'down'}, 500);
			$('#txtMenuTitle').removeClass('validationErrorTextBox');
			$('#valMenuTitle').hide();
		}

		// Otherwise, highlight the textbox and show the error marker.
		else
		{
			$('#txtMenuTitle').addClass('validationErrorTextBox');
			$('#valMenuTitle').show();
		}
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep2Back').click(function() {
		$('#pnlStep1').show('slide', {direction: 'up'}, 500);
		$('#pnlStep2').hide('slide', {direction: 'down'}, 500);
	});

	// Panel 3 Next button click event
	$('#lnkStep3Next').click(function() {

		// Get the field value so we can validate it.
		var fieldValue = jQuery.trim($('#txtRedirectPath').attr('value'));
		var isNewRedirectPath = false;
		
		if ( fieldValue.length > 0)
		{
			// Check to see if this is a new redirect path
			$.ajax(
				   {
						type: 'get',
						url: URLRoot + 'cfc/page.cfc',
						data: {
							method: 'IsNewRedirectPath',
							redirectPath: $('#spnDepartmentPath').html() + fieldValue + '.cfm'
						},
						dataType: 'json',
						success: function(retVal) {
							
							if(retVal == true)
							{
								// If the field has a value, update the summary panel and move to the next panel.
								$('#spnPageURL').html('http://' + domainPath + $('#spnDepartmentPath').html() + fieldValue + '.cfm');
								$('#hdnDepartmentPath').attr('value',$('#spnDepartmentPath').html());
								$('#pnlStep3').hide('slide', {direction: 'up'}, 500);
								$('#pnlStep4').show('slide', {direction: 'down'}, 500);
								$('#txtRedirectPath').removeClass('validationErrorTextBox');
								$('#valRedirectPath').hide();
								$('#valDuplicateRedirectPath').hide();
							}
							else
							{
								$('#valDuplicateRedirectPath').show();
							}
						},
						error: function(retVal) {
						}
				   }
			);
		
		}

		// Otherwise, highlight the textbox and show the error marker.
		else
		{
			$('#txtRedirectPath').addClass('validationErrorTextBox');
			$('#valRedirectPath').show();
		}
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep3Back').click(function() {
		$('#pnlStep2').show('slide', {direction: 'up'}, 500);
		$('#pnlStep3').hide('slide', {direction: 'down'}, 500);
	});

	// Panel 4 Next button click event
	$('#lnkStep4Next').click(function() {

		// Get the field value so we can validate it.
		var fieldValue = jQuery.trim($('#txtPageKeywords').attr('value'));
		
		// If the field has a value, update the summary panel and move to the next panel.
		if ( fieldValue.length > 0)
		{
			$('#spnPageKeywords').html($('#txtPageKeywords').attr('value'));
			$('#spnPageDescription').html($('#txtaPageDescription').attr('value'));
			$('#pnlStep4').hide('slide', {direction: 'up'}, 500);
			$('#pnlStep5').show('slide', {direction: 'down'}, 500);
			$('#txtPageKeywords').removeClass('validationErrorTextBox');
			$('#valPageKeywords').hide();
		}

		// Otherwise, highlight the textbox and show the error marker.
		else
		{
			$('#txtPageKeywords').addClass('validationErrorTextBox');
			$('#valPageKeywords').show();
		}
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep4Back').click(function() {
		$('#pnlStep3').show('slide', {direction: 'up'}, 500);
		$('#pnlStep4').hide('slide', {direction: 'down'}, 500);
	});

	// Panel 5 Next button click event
	$('#lnkStep5Next').click(function() {
		// If the user has selected the page to show in the navigation, show the correct option on the summary panel
		if($('#rdoShowInNavigation').attr('value') == '1')
		{
			$('#spnShowInNavigationYes').show();
			$('#spnShowInNavigationNo').hide();
		}
		else
		{
			$('#spnShowInNavigationNo').show();
			$('#spnShowInNavigationYes').hide();
		}

		// If the user has selected the page to show in the site map, show the correct option on the summary panel
		if($('#rdoShowInSiteMap').attr('value') == '1')
		{
			$('#spnShowInSiteMapYes').show();
			$('#spnShowInSiteMapNo').hide();
		}
		else
		{
			$('#spnShowInSiteMapNo').show();
			$('#spnShowInSiteMapYes').hide();
		}
		$('#pnlStep6').show('slide', {direction: 'down'}, 500);
		$('#pnlStep5').hide('slide', {direction: 'up'}, 500);
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep5Back').click(function() {
		$('#pnlStep4').show('slide', {direction: 'up'}, 500);
		$('#pnlStep5').hide('slide', {direction: 'down'}, 500);
	});

	// Panel 6 Next button click event
	$('#lnkStep6Next').click(function() {

		// Get the layoutID so we can validate it.
		var layoutID = $('#hdnLayoutID').attr('value');
		
		// If a layout has been selected, update the summary panel and move to the next panel.
		if ( layoutID != '')
		{
			$('#imgSummaryLayout').attr({'src': $('#imgLayoutIcon' + layoutID).attr('src')});
			$('#pSummaryLayoutName').html($('#pLayoutName' + layoutID).html());
			$('#pSummaryLayoutDescription').html($('#pLayoutDescription' + layoutID).html());
			$('#pnlStep6').hide('slide', {direction: 'up'}, 500);
			$('#pnlStep7').show('slide', {direction: 'down'}, 500);
		}

		// Otherwise, show the error message.
		else
		{
			$('#valLayout').show();
		}
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep6Back').click(function() {
		$('#pnlStep5').show('slide', {direction: 'up'}, 500);
		$('#pnlStep6').hide('slide', {direction: 'down'}, 500);
	});

	// Panel 7 Next button click event
	$('#lnkStep7Next').click(function() {

		// Get the accessLevelID so we can validate it.
		var accessLevelID = $('#hdnAccessLevelID').attr('value');
		
		// If an Access Level has been selected, update the summary panel and move to the next panel.
		if ( accessLevelID != '')
		{
			$('#imgSummaryAccessLevel').attr({'src': $('#imgAccessLevelItemIcon' + accessLevelID).attr('src')});
			$('#pSummaryAccessLevelItemName').html($('#pAccessLevelItemName' + accessLevelID).html());
			$('#pSummaryAccessLevelItemDescription').html($('#pAccessLevelItemDescription' + accessLevelID).html());
			$('#pnlStep7').hide('slide', {direction: 'up'}, 500);
			$('#pnlSummary').show('slide', {direction: 'down'}, 500);
		}

		// Otherwise, show the error message.
		else
		{
			$('#valAccessLevel').show();
		}
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkStep7Back').click(function() {
		$('#pnlStep6').show('slide', {direction: 'up'}, 500);
		$('#pnlStep7').hide('slide', {direction: 'down'}, 500);
	});

	// When the back button is clicked, move to the previous panel.
	$('#lnkSummaryBack').click(function() {
		$('#pnlStep7').show('slide', {direction: 'up'}, 500);
		$('#pnlSummary').hide('slide', {direction: 'down'}, 500);
	});

	$('.layoutItem').click(function() {
		$('.layoutItem').removeClass('layoutItemSelected');
		$(this).addClass('layoutItemSelected');
		var layoutID = $(this).attr('layoutID');
		// Change value of hidden field with the new layoutID
		$('#hdnLayoutID').attr('value', layoutID);
	});
	
	$('.accessLevelItem').click(function() {
		$('.accessLevelItem').removeClass('accessLevelItemSelected');
		$(this).addClass('accessLevelItemSelected');
		var accessLevelID = $(this).attr('accessLevelID');
		// Change value of hidden field with the new layoutID
		$('#hdnAccessLevelID').attr('value', accessLevelID);
	});
	
	$('.btnToggle').click(function() {
		var hiddenField = $(this).attr('hiddenField');
		var toggleValue = $('#' + hiddenField).attr('value');
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

	// Update the URL Preview so the user can see what the page's URL will be.
	$('#txtRedirectPath').keyup(function(event) {
		$('#pURLPreview').show();
		$('#spnURLPreview').html($('#txtRedirectPath').attr('value'));
	});
	
	// Get the departmentPath from the selected option and update the URL Preview.
	$('#ddlDepartmentID').change(function() {
		var departmentPath = $('select[id=ddlDepartmentID] option:selected').attr('departmentPath');
		$('#spnDepartmentPath').html(departmentPath);
	});
	
	$('#lnkFinish').click(function() {
		$('#frmCreatePageWizard').submit();
	});
	
});
