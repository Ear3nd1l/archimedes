// Include the ajaxUpload plugin by Andrew Valums. http://valums.com/ajax-upload/
IncludeExternalScript(URLRoot + 'jQuery/ajaxupload.js');

$(function() {

	/*new AjaxUpload('fileUpload', {
		action: '',
		name: '',
		data: {
			FolderID: ''
		},
		autoSubmit: false,
		responseType: 'json',
		onSubmit: function(file, extention){},
		onComplete: function(file, response){}
	});*/

	/*
		Make the tab panels
	*/
	$.makeTabs({
		firstPanel: 	'divFolders',
		tabClass:		'folderHandle',
		panelClass:		'filePanel',
		activeTabClass:	'folderHandleActive'
	});

	$('#' + defaultPanel).show();
	$('.filePreviewRow').hide();
	
	$('.fileCell').click(function() {
		var fileID = $(this).attr('fileID');
		$.ajax(
		{
			type: 'get',
			url: URLRoot + 'cfc/fileManager/atheneum.cfc',
			data: {
					method: 'ajaxGetFileInfo',
					FileID: fileID
			},
			dataType: 'json',
			success: function(retStruct) {
				$('#lblFileTitle').text(retStruct.Title);
				$('#lblFileName').text(retStruct.FileName);
				$('#lblFileSize').text(retStruct.FileSize);
				$('#lblFileKeywords').text(retStruct.Keywords);
				$('#lblMimeType').text(retStruct.MimeType);
				var mimeType = retStruct.MimeType;
				if(mimeType.indexOf('image') > 0)
				{
					$('#lblFileDimensions').text(retStruct.Width + 'x' + retStruct.Height);
					$('#imgFilePreview').attr('src', retStruct.FolderPath + retStruct.FileName);
				}
				else
				{
					$('#imgFilePreview').hide();
				}
				$('.filePreviewRow').show();
			},
			error: function(retStruct) {
			}
		});
	});
	
	$('.folderHandle').click(function() {
		$('.filePreviewRow').hide();
		$('#lblFileTitle').text('');
		$('#lblFileName').text('');
		$('#lblFileSize').text('');
		$('#lblFileKeywords').text('');
		$('#lblMimeType').text('');
		$('#lblFileDimensions').text('');
	});
	
	$('.lnkPreview').click(function() {
		var image = $(this).attr('image');
		
		$('#divImagePreviewLightbox').attr('src', image);
		$.lightbox({
			divID: 		'divAnnouncementDetails',
			fadeSpeed:	'medium'
		})
		
	});

});