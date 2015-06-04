$(function() {

	$('.tblFancy').tablesorter({widgets: ['zebra']});
	
	$('.tblFancyRow:even').addClass('even');
	$('.tblFancyRow:odd').addClass('odd');

	$('.tblFancyRow').click(function() {
		var profileID = $(this).attr('profileID');
		
		$(document.body).append('<div id="divUserEditor" class="lightBox"><iframe id="ifUserEditor" frameborder="0" width="100%" height="100%" src="userDetails.cfm" class="evtIFrame" /></div>');
		
		$('#ifUserEditor').attr('src', 'userDetails.cfm?ProfileID=' + profileID);
		
		// Show the lightbox.
		$.lightbox({
			divID: 		'divUserEditor',
			fadeSpeed:	'medium'
		})

	});
	
	$('#lnkCreateNewUser').click(function() {
										  
		$(document.body).append('<div id="divUserEditor" class="lightBox"><iframe id="ifUserEditor" frameborder="0" width="100%" height="100%" src="userDetails.cfm" class="evtIFrame" /></div>');
		
		$('#ifUserEditor').attr('src', 'createUser.cfm');
		
		// Show the lightbox.
		$.lightbox({
			divID: 		'divUserEditor',
			fadeSpeed:	'medium'
		})

	});

});