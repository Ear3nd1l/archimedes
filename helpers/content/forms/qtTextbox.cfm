<cfparam name="Attributes.questionInfo" type="struct" default="StructNew()" />

<cfif Attributes.questionInfo.IsRequired>
	<cfset class = "questionTextbox span-9 required" />
<cfelse>
	<cfset class = "questionTextbox span-9" />
</cfif>

<cfoutput>

	<div class="questionPanel">

		<label for="question#Attributes.questionInfo.QuestionID#" class="questionTextboxLabel">#Attributes.questionInfo.QuestionTitle#</label>
		<input type="text" id="question#Attributes.questionInfo.QuestionID#" name="question#Attributes.questionInfo.QuestionID#" class="#class#" <cfif Attributes.questionInfo.txtCols gt 0>maxlength="#Attributes.questionInfo.txtCols#"</cfif> />
		<cfif Attributes.questionInfo.txtCols gt 0>
			<span class="questionInstructions">
				#Attributes.questionInfo.txtCols# character maximum (including letters, punctuation, spaces).
			</span>
		</cfif>
	
	</div>
	
</cfoutput>