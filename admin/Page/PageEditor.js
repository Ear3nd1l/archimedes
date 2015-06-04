// JavaScript Code File for PageEditor.cfm
$(function() {

	$('.pageBucket').corners('10px');
	
	$.makeRibbonBar({
		divID: 				'divModules',
		handleClass: 		'ribbonHandle',
		activeHandleClass: 	'ribbonHandleActive',
		ribbonClass: 		'ribbonHolder',
		defaultHandle: 		defaultRibbonHandle,
		scrollable:			true,
		scrollBarClass:		'ribbonScrollbar',
		defaultScrollbar:	defaultScrollbar
	});
	
	// Make the Available Users permissions items draggable
	$('.spnAvailableUserItem').draggable(
		{
			cursor: 'move',
			opacity: 0.7,
			helper: 'clone',
			scroll: false
		}
	);
	
	// Make the Assigned Users permissions items draggable
	$('.spnAssignedUsersItem').draggable(
		{
			cursor: 'move',
			opacity: 0.7,
			helper: 'clone',
			scroll: false
		}
	);

// Make the Available Users container droppable
	$('#divAvailableUsers').droppable(
		 {
			 accept: '.spnAssignedUsersItem',
			 tolerance: 'pointer',
			 hoverClass: 'permissionsBoxHover',
			 drop: function(ev, ui){
				var profileID = $(ui.draggable).attr('profileID');
				$.ajax(
						{
							type: 'get',
							url: URLRoot + 'cfc/user/Archon.cfc',
							data: {
								method: 'RemoveUserPageRights',
								pageID: thisPageID,
								profileID: profileID
							},
							dataType: 'json',
							success: function() {
								$('#divAvailableUsers').append($(ui.draggable).removeClass('spnAssignedUsersItem').addClass('spnAvailableUserItem'));
								SortUsers('divAvailableUsers');
							},
							error: function(){
								$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Unable to remove this user\'s access.</p>').dialog('open');
							}
						}
					);
				 }
		 }
	 );

	// Make the Page Manager container droppable
	$('#divPageManagers').droppable(
		 {
			 accept: '.spnAvailableUserItem, .spnAssignedUsersItem',
			 tolerance: 'pointer',
			 hoverClass: 'permissionsBoxHover',
			 drop: function(ev, ui){
				var profileID = $(ui.draggable).attr('profileID');
				$.ajax(
						{
							type: 'get',
							url: URLRoot + 'cfc/user/Archon.cfc',
							data: {
								method: 'GrantUserPageManagerRight',
								pageID: thisPageID,
								profileID: profileID
							},
							dataType: 'json',
							success: function() {
								$('#divPageManagers').append($(ui.draggable).removeClass('spnAvailableUserItem').addClass('spnAssignedUsersItem'));
								SortUsers('divPageManagers');
							},
							error: function(){
								$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Unable to grant this user access.</p>').dialog('open');
							}
						}
					);
				 }
		 }
	 );
	
	// Make the Page Editor container droppable
	$('#divPageEditors').droppable(
		 {
			 accept: '.spnAvailableUserItem, .spnAssignedUsersItem',
			 tolerance: 'pointer',
			 hoverClass: 'permissionsBoxHover',
			 drop: function(ev, ui){
				var profileID = $(ui.draggable).attr('profileID');
				$.ajax(
						{
							type: 'get',
							url: URLRoot + 'cfc/user/Archon.cfc',
							data: {
								method: 'GrantUserPageEditorRight',
								pageID: thisPageID,
								profileID: profileID
							},
							dataType: 'json',
							success: function() {
								$('#divPageEditors').append($(ui.draggable).removeClass('spnAvailableUserItem').addClass('spnAssignedUsersItem'));
								SortUsers('divPageEditors');
							},
							error: function(){
								$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Unable to grant this user access.</p>').dialog('open');
							}
						}
					);
				}
		}
	 );

	// Make the buckets droppable
	$('.droppable').droppable(
			{
				accept: '.draggableRibbonItem, .draggableBucketItem', // Accept items from the ribbon or from another bucket
				tolerance: 'pointer',
				hoverClass: 'permissionsBoxHover',
				drop: function(ev, ui){
					// When the user drops an item, check to see if it is from the ribbon.  If so, duplicate it so they can add another
					if ($(ui.draggable).hasClass('draggableRibbonItem')) 
					{
						// We're adding a temp class, so we can find the clone later and change it's ID
						$(this).append($(ui.draggable).clone().removeClass().addClass('draggableBucketItem').addClass('tempClass'));
						
						
						// Create the pageModuleID variable to store the new ID and get the moduleID from the ribbon item so we can add the correct module to the bucket
						pageModuleID = 0;
						moduleID = $(ui.draggable).attr('moduleID');
						
						// Get the bucketID
						var bucketID = $(this).attr('bucketID');
						
						// Call ajax methods to add this item to the page
						$.ajax(
							{
								type: 'get',
								url: URLRoot + 'cfc/modules/pageModule.cfc',
								data: {
									method: 'ajaxAddModuleToBucket',
									pageID: thisPageID,
									moduleID: moduleID,
									bucketID: bucketID
								},
								dataType: 'json',
								success: function(newPageModuleID) {
									if(newPageModuleID > 0)
									{
										
										// Change the id of the ribbon item so that it is now a bucket item. Add the pageModuleID and ID of the containing bucket as attributes to the new bucket item
										$('.tempClass').attr('id','bucketItem' + newPageModuleID).removeClass('tempClass').removeClass('ui.state-default').attr('pageModuleID', newPageModuleID).attr('bucketID', bucketID);
										
										// Add the buttons to the bucket item
										$('#bucketItem' + newPageModuleID).html($('#bucketItem' + newPageModuleID).html() + '<span class="spnEditModule" pageModuleID="' + newPageModuleID + '">Edit Settings</span><span class="spnDeleteModule" pageModuleID="' + newPageModuleID + '">Delete Module</span>');
										
										// Rebind the click event
										$('.spnEditModule').click(function() {
											ShowEditor($(this))
										});

										ShowEditor($('#bucketItem' + newPageModuleID));
									}
									else{
										alert('Unable to add the module to the page.');
										//$('.tempClass').remove();
									}
								},
								error: function(objResponse){
									$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Unable to add the module to the page.</p>').dialog('open');
									//$('.tempClass').remove();
								}
							}
						);
						
					}
					// If this item is already in a bucket, we do not duplicate it.
					else
					{
						// Get the pageModuleID from the bucket item
						var pageModuleID = $(ui.draggable).attr('pageModuleID');
						
						// Get the bucketID that the item was in
						var parentBucket = $(ui.draggable).attr('bucketID');
						
						// Get the bucketID for this bucket
						var bucketID = $(this).attr('bucketID');
						
						if(parentBucket == bucketID)
						// This item is remaining in the same bucket
						{
							// Tell the user that the sort order has changed and they will need to save.
							$('#spnGetBucket2SortOrder').show().attr('bucketID', bucketID);
						}
						else
						// Move this item from its old bucket to the new one
						{
							// Call ajax methods to move this item from it's old bucket to the new one.
						}
						
					}
				}
			}
	);
	
	$('#spnGetBucket2SortOrder').click(function() {
		var bucketID = $(this).attr('bucketID');
		$.ajax(
			   {
					type: 'get',
					url: URLRoot + 'cfc/modules/pageModule.cfc',
					data: {
						method: 'UpdateSortOrder',
						OrderList: $('#ulBucket' + bucketID).sortable('toArray')
					},
					dataType: 'json',
					success: function(retVal) {
						if(retVal == true)
						{
							$('#spnGetBucket2SortOrder').hide();
						}
						else
						{
							$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>The sort order could not be updated.</p>').dialog('open');
						}
					},
					error: function(retVal) {
						$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>The sort order could not be updated.</p>').dialog('open');
					}
			   }
		);
	});
	
	// Make the ribbon items draggable
	$('.draggableRibbonItem').draggable(
		{
			cursor: 'pointer',
			opacity: 0.7,
			helper: 'clone'
		}
	);
	/*
	// Make the bucket items draggable
	$('.draggableBucketItem').draggable(
			{
				cursor: 'pointer',
				opacity: 0.7
			}
	);
	*/
	$('.spnEditModule').click(function() {
		ShowEditor($(this))
	});

	var ShowEditor = function(obj)
	{
		var pageModuleID = $(obj).attr('pageModuleID');
		// Show the lightbox with the admin control so the user can manage the module
		$('#iModuleOptions').attr('src',HelperPath + '/admin/adminPageConfigEditor.cfm?pageModuleID=' + pageModuleID);
		$.lightbox({
			divID: 		'divModuleOptions',
			fadeSpeed:	'medium'
		})
	}
	
	// Sort function based on http://www.onemoretake.com/2009/02/25/sorting-elements-with-jquery/			
	var SortUsers = function(divID)
	{
		var userList = $('#' + divID).children('span').get();
		userList.sort(function(a,b) {
			var compA = $(a).attr('lastName').toUpperCase();
			var compB = $(b).attr('lastName').toUpperCase();
			return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
		});
		$.each(userList, function(idx, itm){$('#' + divID).append(itm); });
	}
	
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
	
	$('#btnSavePage').click(function() {
		$('#frmEditPage').submit();
	});
	
	$('#btnCancel').click(function() {
		location.href = URLRoot + 'admin/PageManager.cfm';
	});
	
	$('.ribbonScrollbar').slider({
		animate: true,
		change: handleSliderChange,
		slide: handleSliderSlide
	});
	
	function handleSliderChange(e, ui) {
		var ribbonToScroll = $(this).attr('ribbon');
		var maxScroll = $("#" + ribbonToScroll).attr("scrollWidth") - $("#" + ribbonToScroll).width();
		$("#" + ribbonToScroll).animate({scrollLeft: ui.value * (maxScroll / 100) }, 1000);
	}
	
	function handleSliderSlide(e, ui) {
		var ribbonToScroll = $(this).attr('ribbon');
		var maxScroll = $("#" + ribbonToScroll).attr("scrollWidth") - $("#" + ribbonToScroll).width();
		$("#" + ribbonToScroll).attr({scrollLeft: ui.value * (maxScroll / 100) });
	}

});
