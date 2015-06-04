// JavaScript Document
$(function() {
	$('.divPageTemplate').corners('10px;');
	$('.divPageTemplate').hover(
		function() {
			$(this).addClass('roundCorners').corners('10px');
		},
		function() {
			$(this).removeClass('roundCorners');
		}
	).click(function() {
		var pageTemplateID = $(this).attr('PageTemplateID');
		location.href = URLRoot + 'admin/page/CreatePageWizard.cfm?PageTemplateID=' + pageTemplateID;
	});
	
	
});
