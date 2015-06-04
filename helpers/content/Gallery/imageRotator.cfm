<cfobject component="#Application.Site.SiteHelpers.ImageRotator.cfcPath#" name="ImageRotator" />
<cfset qryImages = ImageRotator.GetImages(-1) />

<cfoutput>

	<div id="imageRotatorContainer">
	
		<div id="imageRotatorText">
			<div id="imageRotatorTextContainer">
				<h3 id="imageRotatorTitle">#qryImages.title#</h3>
				<p id="imageRotatorDescription">
					#qryImages.description#
				</p>
			</div>
		</div>
		
		<div id="imageRotatorImageContainer">
			<img src="#qryImages.imageURL#" id="imageRotatorImage" />
		</div>
		
		<div id="imageRotatorNextImage">
			<div id="divThumbnailPreview"></div>
		</div>
	
	</div>

	<script src="#Application.HelperPath#/content/Gallery/imageRotator.js"></script>

</cfoutput>
