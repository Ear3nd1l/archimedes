$(function() {
		   
	// Add a click event to the Close button on the lightbox to close it.
	$('#btnClose').click(function() {
		iFrameCloseLightbox({divID: 'divModuleOptions', fadeSpeed: 'medium'});
	});
	
	$('#btnCancel').click(function() {
		iFrameCloseLightbox({divID: 'divModuleOptions', fadeSpeed: 'medium'});
	});

	$('#btnSaveNewEntry').click(function() {
		$('#frmCreateBlogEntry').submit();
	});
	
	$('#btnCancelCreate').click(function() {
		location.href = 'adminPageConfigEditor.cfm?pageModuleID=' + PageModuleID;
	});

	$('#btnSaveEdit').click(function() {
		$('#frmEditBlogEntry').submit();
	});
	
	$('#btnCancelEdit').click(function() {
		location.href = 'adminPageConfigEditor.cfm?pageModuleID=' + PageModuleID;
	});
	
	$('#btnSave').click(function() {
		$('#frmEditBlogIndex').submit();
	});

	$('#btnShowSummary').click(function() {
		var hiddenField = $(this).attr('hiddenField');
		//console.log(hiddenField);
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

});
