$(function() {
	
	// Hide the imeage list
	$('#ulAnnouncementList').hide();
	
	// Set the duration
	var speed = 5000;
	
	var run = setInterval('rotateAnnouncements()', speed);
	
	announcementCounter = 0;
	
	$('#spnPreviousAnnouncement').click(function() {
		if(announcementCounter < 1)
		{
			announcementCounter = $('#ulAnnouncementList li').length - 2;
		}
		else
		{
			announcementCounter = announcementCounter - 2;
		}
		
		clearInterval(run);
		rotateAnnouncements();
		run = setInterval('rotateAnnouncements()', speed);
	});
	
	$('#spnNextAnnouncement').click(function() {
		clearInterval(run);
		rotateAnnouncements();
		run = setInterval('rotateAnnouncements()', speed);
	});
	
	$('#announcementContainer').hover(
		function() {
			clearInterval(run);
		},
		function() {
			run = setInterval('rotateAnnouncements()', speed);
		}
	);


	$('.announcementMore').click(function() {
		var announcementID = $(this).attr('announcementID');
		$.ajax (
				{
					type: 'get',
					url: URLRoot + 'cfc/content/announcements.cfc',
					data: {
						method: 'ajaxGetAnnouncement',
						AnnouncementID: announcementID
					},
					dataType: 'json',
					success: function(retStruct) {
						$('#announcementDetailTitle').text(retStruct.title);
						$('#announcmentDetailText').html(retStruct.text);
						$.lightbox({
							divID: 		'divAnnouncementDetails',
							fadeSpeed:	'medium'
						})
					},
					error: function() {
						alert('Your request could not be completed at this time.');
					}
				});
	});
	
});

function rotateAnnouncements()
{
	var announcementSet = $('#ulAnnouncementList li');
	var announcementCount = $('#ulAnnouncementList li').length;
	
	if(announcementCounter == announcementCount - 1)
	{
		announcementCounter = 0;
	}
	else
	{
		announcementCounter++;
	}
	
	var nextAnnouncement = ($(announcementSet).get(announcementCounter));

	var announcementTitle = $(nextAnnouncement).attr('title');
	var announcementText = $(nextAnnouncement).attr('text');
	var announcementID = $(nextAnnouncement).attr('announcementID');

	// Show the new item
	$('#announcementContainer').animate({opacity: 0}, 200, function() {
	
		$('#announcementTitle').text(announcementTitle);
		$('#announcementText').text(announcementText);
		$('#announcementMore').attr('announcementID', announcementID);
	
	});

	$('#announcementContainer').animate({opacity: 1}, 200);

}