$(function() {
	$('.panelItem').click(function() {
		var pageID = $(this).attr('pageID');
		window.location = URLRoot + 'admin/Page/PageEditor.cfm?pageID=' + pageID;
	});
	$(".pageMenuItem").hover( function() {
		$("span.pageMenuDescription", this).addClass("pageMenuDescriptionHover");
	},
	function() {
		$("span.pageMenuDescription", this).removeClass("pageMenuDescriptionHover");
	});
});
