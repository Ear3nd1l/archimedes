<cfparam name="Attributes.questionInfo" type="struct" default="StructNew()" />

<cfif Attributes.questionInfo.IsRequired>
	<cfset class = "questionDropdownList required span-9" />
<cfelse>
	<cfset class = "questionDropdownList span-9" />
</cfif>

<cfoutput>

	<div class="questionPanel">

		<label for="question#Attributes.questionInfo.QuestionID#" class="questionDropdownListLabel">#Attributes.questionInfo.QuestionTitle#</label>
		<select id="question#Attributes.questionInfo.QuestionID#" name="question#Attributes.questionInfo.QuestionID#" class="#class#">
			<cfloop from="1" to="#ArrayLen(Attributes.questionInfo.Answers)#" index="x">
				<option value="#Attributes.questionInfo.Answers[x].answerID#">#Attributes.questionInfo.Answers[x].Answer#</option>
			</cfloop>
		</select>
	
	</div>
	
</cfoutput>