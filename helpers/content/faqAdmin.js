$(function() {

	$('.trFAQAdminEditPanel').hide();
	
	$('.tdFAQAdminRow').click(function() {
		var faqPanelID = $(this).attr('faqPanelID');
		
		$('.trFAQAdminEditPanel').hide();
		$('#' + faqPanelID).show();
	});
	
	$('.CancelButton').click(function() {
		var questionID = $(this).attr('questionID');
		
		$('#faqPanel' + questionID).hide();
	});

	$('.SaveButton').click(function() {
		var questionID = $(this).attr('questionID');
		
		// Validate the data
		var question = $('#txtQuestion' + questionID).val();
		if($.trim(question) == '')
		{
			$('#valQuestion' + questionID).show();
			$('#valSummary' + questionID).show();
		}
		else
		{
			$('#valQuestion' + questionID).hide();
		}
		
		var answer = $('#txtAnswer' + questionID).val();
		if($.trim(answer) == '')
		{
			$('#valAnswer' + questionID).show();
			$('#valSummary' + questionID).show();
		}
		else
		{
			$('#valAnswer' + questionID).hide();
		}

		// Ajax save method
		
		$('#faqPanel' + questionID).hide();
	});

});