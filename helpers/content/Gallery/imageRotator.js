var itemCounter = 0;
var imageArray = new Array();

$(function() {

	$('#imageRotatorNextImage').show().animate({opacity: 0}, 0);
	
	$.ajax (
		{
			type: 'get',
			url: URLRoot + 'cfc/content/imageRotator.cfc',
			data: {
				method: 'ajaxGetImages'
			},
			dataType: 'json',
			success: function(retArray) {

				imageArray = retArray;
				
				var imageTitle = retArray[ itemCounter ].title;
				var imageDescription = retArray[ itemCounter ].description;
				var imageURL = retArray[ itemCounter ].imageURL;
				var thumbnailPosition = retArray[ itemCounter + 1 ].thumbnailPosition;
				var nextImage = 'url(' + retArray[ itemCounter + 1 ].imageURL + ')';
				var positionArray = thumbnailPosition.split('|');
				
				$('#imageRotatorTitle').text(imageTitle);
				$('#imageRotatorDescription').text(imageDescription);
				$('#imageRotatorImage').attr('src', imageURL);
				$('#divThumbnailPreview').css('background-image', nextImage).animate({backgroundPosition: '-' + positionArray[0] + 'px -' +  positionArray[1] + 'px'});
				//, backgroundPosition: '(positionArray[0] positionArray[1])'
				$('#imageRotatorNextImage').show().animate({opacity: 1, right: -468}, 500);
				
				itemCounter++;
				
				$('#imageRotatorNextImage').click(function() {
					ChangeImage();
				});
				
			},
			error: function(msg) {
				alert(msg);
			}
		});
	
	// Set the duration
	var speed = 8000;
	
	var run = setInterval('ChangeImage()', speed);

});

function ChangeImage()
{
	
	$('#imageRotatorNextImage').animate({right: 0}, 500, function() {

		$('#divThumbnailPreview').animate({height: '200px', width: '660px', backgroundPosition: '0 0', top: '-5px', left: '51x'}, 500, function() {

			var imageTitle = imageArray[ itemCounter ].title;
			var imageDescription = imageArray[ itemCounter ].description;
			var imageURL = imageArray[ itemCounter ].imageURL;
			
			if(itemCounter == imageArray.length - 1)
			{
				var thumbnailPosition = imageArray[ 0 ].thumbnailPosition;
				var nextImage = 'url(' + imageArray[ 0 ].imageURL + ')';
				itemCounter = 0;
			}
			
			else
			{
				var thumbnailPosition = imageArray[ itemCounter + 1 ].thumbnailPosition;
				var nextImage = 'url(' + imageArray[ itemCounter + 1 ].imageURL + ')';
				itemCounter++;
			}
			
			var positionArray = thumbnailPosition.split('|');
			
			$('#imageRotatorTextContainer').animate({opacity: 0}, 50, function() {
			
				$('#imageRotatorTitle').text(imageTitle);
				$('#imageRotatorDescription').text(imageDescription);
				$('#imageRotatorImage').attr('src', imageURL);
				
				$('#imageRotatorTextContainer').animate({opacity: 1}, 50);
			
				$('#imageRotatorNextImage').animate({opacity: 0, right: '-706px'}, 0, function() {

					$('#divThumbnailPreview').css('background-image', nextImage).animate({height: '120px', width: '120px', left: '82px', top: '32px', border: '5px solid #fff', backgroundPosition: '-' + positionArray[0] + 'px -' +  positionArray[1] + 'px'}, function() {
						
						$('#imageRotatorNextImage').animate({opacity: 1, right: -468}, 500);
					
					});
									
				});
			
			});
			
			
		});
	});
	
}
