<cfset MinimumRank = 4 />
<cfinclude template="#Application.HelperPath#/admin/verifyAccess.cfm" />

<cfset SectionID = 1 />

<cfobject component="ArchimedesCFC.content.announcements" name="Announcements" />
<cfset qryGlobalAnnouncements = Announcements.GetHomePageItems() />

<cfobject component="#Application.Site.SiteHelpers.ImageRotator.cfcPath#" name="ImageRotator" />
<cfset qryImages = ImageRotator.GetImages(-1) />

<cf_AdminMasterPage Title="Admin Home" URLRoot="#Application.URLRoot#">

	<cfoutput>

		
			<div id="admAnnouncementPanel" class="panel rounded shadow">
			
				<h3 class="panelHeading roundedSmall shadow">Announcements</h3>
				
				<cfloop query="qryGlobalAnnouncements">
				
					<div class="panelItem announcementItem roundedSmall shadow" announcementID="#qryGlobalAnnouncements.announcementID#">
						
						<h4 class="announcementTitle">#qryGlobalAnnouncements.title#</h4>
						<p class="announcementAbstract">
							
							<cfset cleanText = ReReplaceNoCase(qryGlobalAnnouncements.text, "<(.|\n)*?>", '', 'all') />
							#Left(cleanText, 150)#...
						</p>
						
					</div>
				
				</cfloop>
				
				<span id="spnCreateNewAnnouncement">Create New Announcement</span>
				
				<div class="clear"><br /></div>
			
			</div>
			
			<p>&nbsp;</p>
			
			<div id="admImageRotatorPanel" class="panel rounded shadow">
			
				<h3 class="panelHeading roundedSmall shadow">Image Rotator</h3>
				
				<cfloop query="qryImages">
				
					<div class="panelItem imageRotatorItem roundedSmall shadow">
					
						<h4 class="imageRotatorTitle">#qryImages.title#</h4>
						<p class="imageRotatorAbstract">
							#qryImages.description#
						</p>
						<div id="thumbNail#qryImages.CurrentRow#" class="divThumbnailPreview rounded" thumbnailPosition="#qryImages.thumbnailPosition#" backgroundImage="#qryImages.imageURL#"></div>
					
					</div>
				
				</cfloop>
				
				<div class="clear"><br /></div>
			
			</div>
	
	</cfoutput>
	
	<script>
	
		$(function() {
				   
			$('.divThumbnailPreview').each(function() {
				var thumbnailPosition = $(this).attr('thumbnailPosition');
				var backgroundImage = $(this).attr('backgroundImage');
				var positionArray = thumbnailPosition.split('|');
				console.log(backgroundImage);
				
				$(this).css({'background-image': 'url(' + backgroundImage + ')','background-position': '-' + positionArray[0] + 'px -' +  positionArray[1] + 'px'});
			});
			
			$('.announcementItem').click(function() {
				
				var announcementID = $(this).attr('announcementID');
				
				$('<div id="divAnnouncementDetails" class="lightBox"><iframe id="ifModuleEditor" frameborder="0" width="100%" height="100%" src="" class="evtIFrame" /></div>').appendTo(document.body);
				
				$.lightbox({
					divID: 		'divAnnouncementDetails',
					fadeSpeed:	'medium'
				})
				
					$('#ifModuleEditor').attr('src', URLRoot + 'helpers/content/CampusRec/GlobalAnnouncementsAdmin.cfm?announcementID=' + announcementID);
					
			});
			
			$('#spnCreateNewAnnouncement').click(function() {
				
				$('<div id="divAnnouncementDetails" class="lightBox"><iframe id="ifModuleEditor" frameborder="0" width="100%" height="100%" src="" class="evtIFrame" /></div>').appendTo(document.body);
				
				$.lightbox({
					divID: 		'divAnnouncementDetails',
					fadeSpeed:	'medium'
				})
				
				$('#ifModuleEditor').attr('src', URLRoot + 'helpers/content/CampusRec/GlobalAnnouncementsAdmin.cfm');
				
			});

		});
	
	</script>

</cf_AdminMasterPage>