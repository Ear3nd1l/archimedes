<cfparam name="Attributes.questionInfo" type="struct" default="StructNew()" />

<!--- <cfdump var="#Attributes.questionInfo#" /> --->

<cfif Attributes.questionInfo.IsRequired>
	<cfset class = "questionTextbox required" />
<cfelse>
	<cfset class = "questionTextbox" />
</cfif>

<!--- Escape \'s and /'s in the Regular Expression so it can be used in JavaScript. --->
<cfset jsRegularExpression = ReplaceNoCase(ReplaceNoCase(Attributes.QuestionInfo.RegularExpression, "\", "\\", "all"), "/", "\/", "all")  />

<cfoutput>

	<div class="questionPanel">

		<label for="question#Attributes.questionInfo.QuestionID#" class="questionTextboxLabel">#Attributes.questionInfo.QuestionTitle#</label>
		<input type="text" id="question#Attributes.questionInfo.QuestionID#" name="question#Attributes.questionInfo.QuestionID#" class="#class#" <cfif Attributes.questionInfo.txtCols gt 0>maxlength="#Attributes.questionInfo.txtCols#"</cfif> />
		<span class="questionInstructions">
			Numeric entry only.
			<cfif Attributes.questionInfo.txtCols gt 0>
				 #Attributes.questionInfo.txtCols# character maximum.
			</cfif>
		</span>
	</div>

	<script>
	
		$(function() {
			$('##question#Attributes.questionInfo.QuestionID#').blur(function() {
				var fieldValue = $('##question#Attributes.questionInfo.QuestionID#').val();
				if (fieldValue.length > 0)
				{
					var re = new RegExp('#jsRegularExpression#');
					if(fieldValue.match(re))
					{
						
					}
					else
					{
						setTimeout(function () { $('##question#Attributes.questionInfo.QuestionID#').focus() }, 50);
						$alertDialog.html('<p class="dialogText" id="pDialogText"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span><strong>#Attributes.questionInfo.QuestionTitle#</strong> must be a number.</p>').dialog('open');
					}
				}
			});
		});
	
	</script>
	
</cfoutput>