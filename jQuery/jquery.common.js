/*
	ArchimedesCMS jQuery Common Function Library
	Version 0.2a
	
	All functions created by Chris Hampton unless otherwise noted.

*/

// 	Disable form elements
//		Syntax:
//			$("form#myForm input.special").disable();
//
//		Reference:
//			jQuery In Action, page 12.  By Bear Bibeault and Yehuda Katz.  Published 2008 by Manning Publications Co
//
(function($) {
	$.fn.disable = function() {
		return this.each(function() {
			if (typeof this.disabled != "undefined") this.disabled = true;
		});
	}
})(jQuery);

// Reverse the text in a form field
//		Syntax:
//			$("#txtTextbox").reverseText();
//
(function($) {
	$.fn.reverseText = function() {
		return this.each(function() {
			var retVal = "";
			for (i=0;i<=this.value.length;i++)
			{
				retVal = this.value.charAt(i) + retVal;
			}
			this.value = retVal;
		});
	}
})(jQuery);

// Reverse a string
//
//
(function($) {
	$.fn.stringReverse = function(str) {
		var retVal = "";
		for (i=0;i<=str.length;i++)
		{
			retVal = str.charAt(i) + retVal;
		}
		return retVal;
	}
})(jQuery);

// Show the value of a form field in an alert box
//		Syntax:
//			$("#txtTextbox").alertFieldValue();
//
(function($) {
	$.fn.alertFieldValue = function() {
		return this.each(function() {
			alert(this.value);
		});
	}
})(jQuery);

// Create an accordian from a div and nested ULs
//		Syntax:
//			$.makeAccordian({
//				divID: 			'divAccordian', 
//				upSpeed: 		'medium', 
//				downSpeed: 		'slow', 
//				handleClass: 	'jqAccordianHandle'
//			});
//
(function($) {
   $.makeAccordian = function(options) {
   	
		// Set the default options
		var defaults = {
			divID:			'',
			upSpeed:		'medium',
			downSpeed:		'medium',
			handleClass:	'jqAccordianHandle'
		};

		// Overwrite default options 
		// with user provided ones 
		// and merge them into "options"
		var options = $.extend({}, defaults, options); 
		
		// Hide the panels
		$('#' + options.divID + ' div.hidden').hide();
		
		// Add a click event to the accordian handles
		$('#' + options.divID + ' h3.' + options.handleClass).click(function() {
			
			// Get the associated panel 
			var accordianPanel = $(this).attr('panel');
			
			// If the panel is hidden, we want to show it.
			if ($('#' + accordianPanel).is(':hidden'))
			{
				// Hide all the panels
				$('#' + options.divID + ' .jqAccordianPanel').slideUp(options.upSpeed);
				
				// Show the one we want
				$('#' + accordianPanel).slideDown(options.downSpeed);
			}
			
			// Otherwise, we want to hide it
			else
			{
				$('#' + accordianPanel).slideUp(options.upSpeed);
			}
		});
	}
})(jQuery);

// Create a ribbon bar
//		Syntax:
//			$.makeRibbonBar({
//				divID: 				'divRibbonBar', 
//				handleClass: 		'ribbonHandle', 
//				activeHandleClass: 	'ribbonHandleActive', 
//				ribbonClass: 		'ribbon', 
//				defaultHandle: 		'handle1'
//			});
//
(function($) {
	$.makeRibbonBar = function(options) {
		
		// Set the default options
		var defaults = {
			divID:				'',
			handleClass:		'ribbonHandle',
			activeHandleClass:	'ribbonHandleActive',
			ribbonClass:		'ribbon',
			defaultHandle:		'',
			eventType:			'click',
			scrollable:			false,
			scrollBarClass:		'ribbonScrollbar',
			defaultScrollbar:	''
		};
		
		// Overwrite default options with user provided ones and merge them into "options"
		var options = $.extend({}, defaults, options); 
		
		// Get the current width of the handles including the padding
		var currentHandleWidth = $('#' + options.divID + ' > div > span.' + options.handleClass).width() + parseInt($('#' + options.divID + ' > div > span.' + options.handleClass).css('padding-left')) + parseInt($('#' + options.divID + ' > div > span.' + options.handleClass).css('padding-right')) + parseInt($('#' + options.divID + ' > div > span.' + options.handleClass).css('margin-right'));

		// Get the number of handles and width of the div so they can be spaced properly
		var numberOfHandles = $('#' + options.divID + ' > div > span.' + options.handleClass).size();
		var divWidth = $('#' + options.divID).width();
		
		// If the total width of the handles will be longer than the width of the container, we need to shrink them.
		if ((numberOfHandles * currentHandleWidth) >= divWidth) {
			var handleWidth = (divWidth / numberOfHandles) - 10;
			$('.' + options.handleClass).css('width', handleWidth);
		}
		
		// Hide all the ribbons
		$('.' + options.ribbonClass).hide();
		
		// Add the activeHandleClass to the default handle
		$('#' + options.defaultHandle).addClass(options.activeHandleClass);
		
		// If this ribbon bar is scrollable, hide all the scrollbars and show the active one
		if(options.scrollable == true)
		{
			$('.' + options.scrollBarClass).hide();
			$('#' + options.defaultScrollbar).show();
		}
		
		/* 
			Get the ribbon this handle is associated with and show it.  
			Add the activeRibbon class to it so we can hide it when another handle is clicked
		 */
		var defaultRibbon = $('#' + options.defaultHandle).attr('ribbon');
		$('#' + defaultRibbon).show().addClass('activeRibbon');
		
		if(options.eventType == 'click')
		{
			// Add a click event to the handles
			$('.' + options.handleClass).click(function() {
				
				// If this is not the currently active handle, let's switch it.  Otherwise, do nothing.
				if ($(this).hasClass(options.activeHandleClass) != true) {
					
					// Get the associated ribbon and scrollbar
					var ribbonToShow = $(this).attr('ribbon');
					var scrollBarToShow = $(this).attr('scrollbar');
					
					// Hide the currently active ribbon
					$('.activeRibbon').hide().removeClass('activeRibbon'); //'slide', {direction: 'down'}, 500
					
					// Hide all the scrollbars
					$('.' + options.scrollBarClass).hide();
					
					// Show the new ribbon
					$('#' + ribbonToShow).show().addClass('activeRibbon'); // 'slide', {direction: 'up'}, 500
					
					// Show the new scrollbar
					$('#' + scrollBarToShow).show();
					
					// Remove the activeHandleClass from all handles
					$('.' + options.handleClass).removeClass(options.activeHandleClass);
					
					// Add the activeHandleClass to the clicked handle
					$(this).addClass(options.activeHandleClass);
				}
			});
		}
		else
		{
			// Add a hover event to the handles
			$('.' + options.handleClass).hover(function() {
				
				// If this is not the currently active handle, let's switch it.  Otherwise, do nothing.
				if ($(this).hasClass(options.activeHandleClass) != true) {
					
					// Get the associated ribbon and scrollbar
					var ribbonToShow = $(this).attr('ribbon');
					var scrollBarToShow = $(this).attr('scrollbar');
					
					// Hide the currently active ribbon
					$('.activeRibbon').hide().removeClass('activeRibbon'); //'slide', {direction: 'down'}, 500
					
					// Hide all the scrollbars
					$('.' + options.scrollBarClass).hide();
					
					// Show the new ribbon
					$('#' + ribbonToShow).show().addClass('activeRibbon'); // 'slide', {direction: 'up'}, 500
					
					// Show the new scrollbar
					$('#' + scrollBarToShow).show();
					
					// Remove the activeHandleClass from all handles
					$('.' + options.handleClass).removeClass(options.activeHandleClass);
					
					// Add the activeHandleClass to the clicked handle
					$(this).addClass(options.activeHandleClass);
				}
			});
		}
	}
})(jQuery);

// Create a lightbox
//
//
(function($) {
	$.lightbox = function(options) {
		
		// Set the default options
		var defaults = {
			divID:		'',
			fadeSpeed:	'fast'
		};
		
		/*
		,
			width: '830px',
			height: '480px'
		*/
		
		// Overwrite default options with user provided ones and merge them into "options"
		var options = $.extend({}, defaults, options); 
		var divID = $('#' + options.divID);
		//$('#' + options.divID).css({'width': options.width, 'height': options.height});
		
		$(document.body).append('<div id="divLightboxOverlay"></div>');
		$('#divLightboxOverlay').height($(document).height()).width($(window).width()).show();

		var containerTop = Math.round(($(window).scrollTop() + (($(window).height() - divID.outerHeight()) / 2))) + 'px';
		var containerLeft = Math.round(($(window).width() - divID.outerWidth()) / 2) + 'px';
		$('#' + options.divID).css({'top': containerTop, 'left': containerLeft, 'margin-top': 0, 'margin-left': 0}).show().append('<div id="lightBoxCloseButton">Close Window</div>');
		
		$('#lightBoxCloseButton').click(function() {
			$('#divLightboxOverlay').animate({opacity: 0}, 0, function() 
			{
				$('#lightBoxCloseButton').hide().remove();
				$('#' + options.divID).hide();
			}).remove();
			
		});
	}
})(jQuery);

// Create a tab control
//		Syntax:
//			$.makeTabs({
//				firstPanel:		'tab1',
//				tabClass: 		'tabHandle',
//				panelClass: 	'tabPanel',
//				activeTabClass:	''
//			});
//
(function($) {
	$.makeTabs = function(options) {
		
		// Set the default options
		var defaults = {
			firstPanel:		'',
			tabClass: 		'',
			panelClass: 	'',
			activeTabClass:	''
		};
		
		// Overwrite default options with user provided ones and merge them into "options"
		var options = $.extend({}, defaults, options); 

		$('.' + options.panelClass).hide();
		$('#' + options.firstPanel).show();
		
		$('.' + options.tabClass).click(function() {
			$('.' + options.tabClass).removeClass(options.activeTabClass);
			$(this).addClass(options.activeTabClass);
			
			$('.' + options.panelClass).hide();
			
			var panel = $(this).attr('tabPanel');
			$('#' + panel).show();
		});
	};
})(jQuery);

var iFrameCloseLightbox = function(options) {

	// Set the default options
	var defaults = {
		divID:		'',
		fadeSpeed:	'fast'
	};
	
	// Overwrite default options with user provided ones and merge them into "options"
	var options = $.extend({}, defaults, options); 
		
	var reloadWindowOnClose = GetCookieValue('reloadWindowOnClose');
	
	if(isDebugging)
	{
		console.log(reloadWindowOnClose);
	}

	if(reloadWindowOnClose)
	{
		$('#divLightboxOverlay', top.document).fadeOut(options.fadeSpeed).remove();
		$('#' + options.divID, top.document).fadeOut(options.fadeSpeed).remove();
		try
		{
			window.parent.location = window.parent.location.href;
		}
		catch(exception)
		{
		}
		DeleteCookie('reloadWindowOnClose');
		console.log('Deleted Cookie');
	}
	else
	{
		$('#divLightboxOverlay', top.document).fadeOut(options.fadeSpeed).remove();
		$('#' + options.divID, top.document).fadeOut(options.fadeSpeed).remove();
	}
}

var closeLightbox = function(divID) {

	// Set the default options
	var defaults = {
		divID:		'',
		fadeSpeed:	'fast'
	};
	
	// Overwrite default options with user provided ones and merge them into "options"
	var options = $.extend({}, defaults, options); 

	$('#divLightboxOverlay').fadeOut(options.fadeSpeed).remove();
	$('#' + options.divID).fadeOut(options.fadeSpeed);
}

$(function() {
		   
	// Create a flag to let us know that console logging is enabled.
	try
	{
		console.log('Setting Debug Flag');
		isDebugging = true;
	}
	catch(exception)
	{
		isDebugging = false;
	}
	
	/*
		Create the Alert dialog box
	*/
	$alertDialog = $('<div class="dialogBox"></div>')
		.dialog({
			bgiframe: false,
			resizable: false,
			minheight:140,
			modal: true,
			title: 'Alert!',
			autoOpen: false,
			buttons: {
				'OK': function() {
					$(this).dialog('close');
				}
			}
		});

	// Lightbox Editor bind event
	$('.lnkEditContent').click(function() {
		
		if(isDebugging)
		{
			console.log('Loading lightbox editor');
		}
		
		// Add the lightbox to the page
		$(document.body).append('<div id="divModuleOptions" class="lightBox"><iframe id="ifModuleEditor" frameborder="0" width="100%" height="100%" src="" class="evtIFrame" /></div>');
		
		// Get the module code
		var uuid = $(this).attr('uuid');
		
		// Set the source of the iframe
		$('#ifModuleEditor').attr('src', URLRoot + 'helpers/admin/frontEndEditor.cfm?uuid=' + uuid);
		
		// Show the lightbox.
		$.lightbox({
			divID: 		'divModuleOptions',
			fadeSpeed:	'medium'
		})

	});
	
	$('.cPanelTab').click(function() {
		
		var panelToShow = $(this).attr('panel');
		var panelHeight = $('#' + panelToShow).outerHeight();
		var tabHeight = $(this).outerHeight();
		
		if($('#' + panelToShow).css('top') != '0px')
		{
			$('#' + panelToShow).animate({top: 0}, 250);
		}
		else
		{
			$('#' + panelToShow).animate({top: ((panelHeight - tabHeight) * -1) + 4}, 1000);
		}
		
	});
	
});

(function($) {
	$.announcementsBar = function(options) {
		
		// Set the default options
		var defaults = {
			container:				'',
			interval: 				5000,
			numberOfItemsToRotate:	1,
			announcementItemClass:	'announcementItem',
			previousItemHandleID:	'',
			nextItemHandleID:		''
		};
		
		// Overwrite default options with user provided ones and merge them into "options"
		var options = $.extend({}, defaults, options); 
		
		// Get the total number of items, the width of the items and their left margin.
		var totalItems = $('#' + options.container + ' .' + options.announcementItemClass).length;
		var itemWidth = $('.' + options.announcementItemClass).outerWidth();
		var itemMargin = $('.' + options.announcementItemClass).css('margin-left');
		
		var isHandlerActive = false;
		
		// Strip the 'px' from the value.
		itemMargin = itemMargin.substring(0,itemMargin.length - 2);
		
		// Set the width of the container object.
		var containerWidth = (totalItems * itemWidth) + ((totalItems + 1) * itemMargin);
		$('#' + options.container).css('width', containerWidth + 'px');

		// Next item click handler
		$('#' + options.nextItemHandleID).click(function() {
			
			if(isHandlerActive == false)
			{
			
				// Get the current right and left positions of the container.
				var currentRightPosition = $('#' + options.container).css('right');
				currentRightPosition = currentRightPosition.substring(0,currentRightPosition.length - 2);
				
				var currentLeftPosition = $('#' + options.container).css('left');
				currentLeftPosition = currentLeftPosition.substring(0,currentLeftPosition.length - 2);
				
				// Calculate how much to move the container.
				var amountToMove = (Math.round(itemMargin) + Math.round(itemWidth)) * options.numberOfItemsToRotate;
				
				// Calculate the new position of the container.
				var newPosition = Math.round(currentLeftPosition) - Math.round(amountToMove);
				
				// As long as we are not at the end of the item list, slide the container.
				if (currentRightPosition < -1)
				{
					$('#' + options.container).animate({left: newPosition}, 100);
				}
				else
				{
				}
			
			}

		});

		$('#' + options.previousItemHandleID).click(function() {

			if(isHandlerActive == false)
			{
			
				// Get the current right and left positions of the container.
				var currentRightPosition = $('#' + options.container).css('right');
				currentRightPosition = currentRightPosition.substring(0,currentRightPosition.length - 2);
				
				var currentLeftPosition = $('#' + options.container).css('left');
				currentLeftPosition = currentLeftPosition.substring(0,currentLeftPosition.length - 2);
				
				// Calculate how much to move the container.
				var amountToMove = (Math.round(itemMargin) + Math.round(itemWidth)) * options.numberOfItemsToRotate;
				
				// Calculate the new position of the container.
				var newPosition = Math.round(currentLeftPosition) + Math.round(amountToMove);
				
				// As long as we are not at the end of the item list, slide the container.
				if (currentLeftPosition < -1)
				{
					$('#' + options.container).animate({left: newPosition}, 100);
				}
				else
				{
				}
			
			}

		});
		
		$('.announcementItem').click(function() {
			
			$('.announcementView').remove();
			
			isHandlerActive = true;
			
			// Get the current right and left positions of the container.
			var currentRightPosition = $('#' + options.container).css('right');
			currentRightPosition = currentRightPosition.substring(0,currentRightPosition.length - 2);
			
			var currentLeftPosition = $('#' + options.container).css('left');
			currentLeftPosition = currentLeftPosition.substring(0,currentLeftPosition.length - 2);
			
			var containerWidth = $('#' + options.container).outerWidth();
			var parentWidth = $('#' + options.container).parent().outerWidth();
			var leftPosition = Math.round(containerWidth) + Math.round(currentRightPosition) - Math.round(parentWidth);
			
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
						
						$('<div id="divAnnouncementDetails" class="lightBox"><span id="announcementDetailTitle" class="announcementTitleDetail"></span><span id="announcementDetailText" class="announcementTextDetail"></span></div>').appendTo(document.body);
						
						$('#announcementDetailTitle').text(retStruct.title);
						$('#announcementDetailText').html(retStruct.text);
						
						$.lightbox({
							divID: 		'divAnnouncementDetails',
							fadeSpeed:	'medium'
						})
						
						isHandlerActive = false;
						
						/*$('<div class="announcementItem"><span>' + retStruct.title + '</span><span>' + retStruct.text + '</span></div>').appendTo('#' + options.container).animate({left: leftPosition, top: 0, className: 'announcementView'}, 100).click(function() {
							$(this).remove();
						});*/
					},
					error: function() {
						alert('Your request could not be completed at this time.');
					}
				});
			
		});
	}
})(jQuery);

/*
	IncludeExternalScript
		Includes a specified javascript file
*/
function IncludeExternalScript(file) {
	var newScript = document.createElement('script');
	newScript.src = file;
	var head = document.getElementsByTagName('head');
	$(head).append(newScript);
}

var CreateCookie = function(name, value, expirationYear, expirationMonth, expirationDay, path)
{
	var cookieInfo = name + '=' + escape(value);
	
	if(expirationYear)
	{
		var expires = new Date(expirationYear, expirationMonth, expirationDay);
		cookieInfo += "; expires=" + expires.toGMTString();
	}
	
	if ( path )
	{
		cookieInfo += "; path=" + escape ( path );
	}

	document.cookie = cookieInfo;
}

var DeleteCookie = function(cookieName)
{
	var cookieDate = new Date ();  // current date & time
	cookieDate.setTime (cookieDate.getTime() - 1);
	document.cookie = cookieName += "=; expires=" + cookieDate.toGMTString();
}

var GetCookieValue = function(cookieName)
{
	var cookieValue = document.cookie.match ( '(^|;) ?' + cookieName.toUpperCase() + '=([^;]*)(;|$)' );
	
	if (cookieValue)
	{
		return (unescape(cookieValue[2]));
	}
	
	else
	{
		return null;
	}
}