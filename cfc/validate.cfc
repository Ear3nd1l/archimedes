<cfcomponent displayname="Validate" hint="Validates data" output="no" extends="archimedesCFC.common">
	
	<!--- 
		AUTHOR: 	Chris Hampton, based on functions created by Kristian Ranstrom
		PURPOSE:	form validation routines
			
		FUNCTIONS:
			errorMsg			(msg, formfield, formid)
			isValidForm			()
			getErrors			()
			stripToAlphaNumeric	(str)
			stripToGuid			(str)
			isPattern			(str,pattern)
			isAlpha				(str)
			isPhone				(str)
			isPhone3			(str)
			isPhone4			(str)
			isPhoneAreaCode		(str)
		  	formatPhone			(str)
			isThereSpaces		(str)
			isEmpty				(str)
			isOnlyLetters		(str)
			isSearchEngine      ()
			isUsername			(str)
			isZip4				(str)
			isZip				(str)
			isEmail				(str)
			isWebsite			(str)
			trimStruct			(struct)
			structToQuery		(struct)
			fixWebsite			(str)
	 --->
	
	<!--- 
		component variable definitions
	 --->
	 
	<cfparam name="THIS.NumberOfErrors" default="#NullInt#" /> <!--- number of errors --->
	<cfparam name="THIS.ErrorMessage" default="#NullString#" /> <!--- printed error messages to the user --->
	<cfparam name="THIS.ErrorList" default="#NullString#" /> <!--- error fieldname list --->
	<cfparam name="THIS.IDList" default="#NullString#" /> <!--- error field id list --->
	<cfparam name="THIS.DefaultMessage" default="The following fields have errors: " />
	<cfparam name="THIS.ListDelimiter" default="," />
	<cfparam name="THIS.MessageDelimiter" default="<br />" />
	
	
	<!------------------------------------------------------------------------------------------------------
	
		ERROR MESSAGE FUNCTIONS
	
	 ------------------------------------------------------------------------------------------------------>	
	
	<!--- 
		keeps hold of the error messages while validating
	 --->
	<cffunction name="ErrorMsg" access="public" returntype="void">
		<cfargument name="Message" type="string" required="yes" default="#NullString#" />
		<cfargument name="FormID" type="string" required="no" default="#NullString#">
		<cfargument name="FormField" type="string" required="no" default="#NullString#">		
		
		<cfset THIS.ErrorMessage = THIS.ErrorMessage & Arguments.Message & THIS.MessageDelimiter>		
		<cfset THIS.ErrorList = ListAppend(THIS.ErrorList, Arguments.FormField, THIS.ListDelimiter)>
		<cfset THIS.IDList = ListAppend(THIS.IDList, Arguments.FormID, THIS.ListDelimiter)>
		<cfset THIS.NumberOfErrors = THIS.NumberOfErrors + 1>
	</cffunction>	 
	
	
	<!--- 
		returns if there are any errors or not
	 --->
	<cffunction name="IsValidForm" access="public" returntype="boolean">
		<cfreturn THIS.NumberOfErrors eq NullInt>
	</cffunction>  
	
	
	<!--- 
		returns the error messages
	 --->
	<cffunction name="GetErrors" access="public" returntype="string">
		<cfreturn THIS.DfaultMessage & THIS.MessageDelimiter & THIS.ErrorMessage>
	</cffunction> 
	
	<!------------------------------------------------------------------------------------------------------
	
		VALIDATING FUNCTIONS
	
	 ------------------------------------------------------------------------------------------------------>
	
	<!--- 
		strips a string of all chars except alphanumeric ones
	--->
	<cffunction name="StripToAlphaNumeric" access="public" returntype="string">
		<cfargument name="str" type="string" required="yes" default="#NullString#">
		
		<cfset temp = "">
			
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z0-9]", mid(Arguments.str, i, 1)) gt 0>
				<cfset temp = temp & mid(Arguments.str, i, 1)>
			</cfif>
		</cfloop>
		
		<cfreturn temp>
	</cffunction> 

	<!--- 
		strips a string of all chars except numeric ones
	--->
	<cffunction name="StripToNumeric" access="public" returntype="string">
		<cfargument name="str" type="string" required="yes" default="#NullString#">
		
		<cfset temp = "">
			
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[0-9]", mid(Arguments.str, i, 1)) gt 0>
				<cfset temp = temp & mid(Arguments.str, i, 1)>
			</cfif>
		</cfloop>
		
		<cfreturn temp>
	</cffunction> 
		
	<!---
		strips a string to a guid
	--->
	<cffunction name="StripToGuid" access="public" returntype="string">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfset temp = "">
			
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z0-9\-]", mid(Arguments.str, i, 1)) gt 0>
				<cfset temp = temp & mid(Arguments.str, i, 1)>
			</cfif>
		</cfloop>
		
		<cfreturn temp>
	</cffunction>
	
	<!---
		checks to see if a string is a guid
	--->
	<cffunction name="IsGuid" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfreturn isPattern(Arguments.str, "^[{|\(]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[\)|}]?$")>
		
	</cffunction>
	
	<!--- 
		checks to see if a string validats for a pattern
	 --->
	<cffunction name="IsPattern" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		<cfargument name="pattern" type="string" required="yes" default="#NullString#" />
		
		<cfset p = "">
		<cfset s = "">

		<cfif len(Arguments.str) neq len(Arguments.pattern)>
			<cfreturn false>
		</cfif>
		
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			
			<cfset p = mid(Arguments.pattern, i, 1)>
			<cfset s = mid(Arguments.str, i, 1)>
			
			<cfif p eq "9" and (s lt 0 and s gt 9)><cfreturn false>
			<cfelseif p eq "a" and reFindNoCase("[a-zA-Z]", s) eq 0><cfreturn false>
			<cfelseif p neq 9 and (p neq "a" and p neq s)><cfreturn false>
			</cfif>			
		</cfloop>
		
		<cfreturn true>
	</cffunction> 
	
	
	<!--- 
		checks a string to see if it's only a-z
	 --->
	<cffunction name="IsAlpha" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z]", mid(Arguments.str, i, 1)) eq 0>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
	</cffunction> 
	
	<cffunction name="IsAlphaOrSpace" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z ]", mid(Arguments.str, i, 1)) eq 0>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
	</cffunction> 
	
	
	<!--- 
		checks a phone value for common patterns (us and can only)
	 --->
	<cffunction name="IsPhone" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfset str = trim(Arguments.str)>

		<cfreturn isPattern(Arguments.str, "(999) 999-9999") OR
			isPattern(Arguments.str, "(999) 999.9999") OR
			isPattern(Arguments.str, "999 999 9999") OR
			isPattern(Arguments.str, "999-999-9999") OR
			isPattern(Arguments.str, "999.999.9999") OR
			isPattern(Arguments.str, "9999999999") OR
			isPattern(Arguments.str, "999-9999") OR
			isPattern(Arguments.str, "999.9999") OR
			isPattern(Arguments.str, "999 9999") OR
			isPattern(Arguments.str, "9999999")>
	</cffunction> 
	
	
	<!--- 
		checks the 3 digit part of a phone to see if it's valid
	 --->
	<cffunction name="IsPhone3" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
				
		<cfreturn isPattern(Arguments.str, "999")>
	</cffunction> 
	
	
	<!--- 
		checks the 4 digit part of a phone to see if it's valid
	 --->
	<cffunction name="IsPhone4" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfreturn isPattern(Arguments.str, "9999")>
	</cffunction> 
	
	
	<!--- 
		checks the 3 digit area code to see if it's valid
	 --->
	<cffunction name="IsPhoneAreaCode" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
				
		<cfreturn isPattern(Arguments.str, "999") OR isPattern(Arguments.str, "(999)")>
	</cffunction>
	
	<!--- 
		formats a phone number
	 --->
	<cffunction name="FormatPhone" access="public" returntype="string">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		<cfargument name="delim1" type="string" required="no" default=" " />
		<cfargument name="delim2" type="string" required="no" default="-" />
		
		<!--- get rid of random characters --->
		<cfset Arguments.str = stripToAlphaNumeric(Arguments.str)>
		
		<cfswitch expression="#len(Arguments.str)#">
			<cfcase value="7">
				<cfset Arguments.str = left(Arguments.str, 3) + delim2 + right(Arguments.str, 4)>
			</cfcase>
			
			<cfcase value="10">
				<cfif delim1 eq " ">
					<cfset Arguments.str = "(" & left(Arguments.str, 3) & ")" & delim1 & mid(Arguments.str, 4, 3) & delim2 & right(Arguments.str, 4)>
				<cfelse>
					<cfset Arguments.str = left(Arguments.str, 3) & delim1 & mid(Arguments.str, 4, 3) & delim2 & right(Arguments.str, 4)>
				</cfif>				
			</cfcase>
		</cfswitch>
		
		<cfreturn Arguments.str>
	</cffunction>
	
	
	<!--- 
		returns if the string contains spaces
	 --->
	<cffunction name="IsThereSpaces" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
				
		<cfreturn find(" ", Arguments.str) gt 0>
	</cffunction>
	
	<!---
		returns if the string is empty
	--->
	<cffunction name="IsEmpty" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
			<cfif Len(Arguments.str) lt 1>
				<cfreturn false>
			</cfif>
			<cfreturn true>
	</cffunction>
	
	<!--- 
		return if the string contains just alphanumeric characters
	 --->
	<cffunction name="IsAlphaNumeric" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z0-9\s]", mid(Arguments.str, i, 1)) eq 0>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
	</cffunction>
	
	<!--- 
		return if the string contains alphanumeric characters only
	 --->
	<cffunction name="IsPartialAlphaNumeric" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z0-9_,'.!?\s]", mid(Arguments.str, i, 1)) eq 0>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
	</cffunction>
	
	<!--- 
		return if the string contains on letters, numbers, and underscores
	 --->
	<cffunction name="IsOnlyLetters" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfloop from="1" to="#len(Arguments.str)#" index="i">
			<cfif refindNoCase("[a-zA-Z0-9_]", mid(Arguments.str, i, 1)) eq 0>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
	</cffunction>
	
	<!---
		checks if page request is from a search engine or not
	 --->
	<cffunction name="IsSearchEngine" access="public" returntype="boolean">
		<cfargument name="referrer" required="no" default="#lcase(cgi.HTTP_REFERER)#">
		<cfargument name="useragent" required="no" default="#lcase(cgi.HTTP_USER_AGENT)#">

		<cfif
			<!--- If coming from a google ad ---> 
			Arguments.referrer contains "google.com"
			OR Arguments.referrer contains "googlesyndication.com"
			OR Arguments.referrer contains "pagead"
			<!--- Or if user is a search engine or spider --->
			OR Arguments.useragent contains "bot" 
			OR Arguments.useragent contains "slurp" 
			OR Arguments.useragent contains "jeeves" 
			OR Arguments.useragent contains "inktomi"
			OR Arguments.useragent contains "msnbot"
			OR Arguments.useragent contains "crawler"
			OR Arguments.useragent contains "archiver"
		>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	
	<!--- 
		checks to see if a string is spaceless and contains only letters, numbers, and underscores
	 --->
	<cffunction name="IsUsername" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
			
		<cfreturn not isThereSpaces(Arguments.str) and isOnlyLetters(Arguments.str)>
	</cffunction>
	
		
	<!--- 
		checks string for valid zip codes (us & can)
	 --->	
	<cffunction name="IsZip" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
			
		<cfreturn isPattern(Arguments.str, "99999") OR
				isPattern(Arguments.str, "99999-9999") OR
				isPattern(Arguments.str, "a9a9a9") OR
				isPattern(Arguments.str, "a9a 9a9")>
	</cffunction>
	
	<!--- 
		checks string for last 4 zip code
	 --->	
	<cffunction name="IsZip4" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
			
		<cfreturn isPattern(Arguments.str, "9999")>
	</cffunction>
	
	
	<!--- 
		validates an email address
	 --->
	<cffunction name="IsEmail" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfreturn reFindNoCase("^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.([a-zA-Z]{2}|com|net|org|edu|mil|biz|gov|info|museum|name|coop|int)$", Arguments.str) gt 0>
	</cffunction>
	
	<!--- 
		validates an website url
	 --->
	<cffunction name="IsWebsite" access="public" returntype="boolean">
		<cfargument name="str" type="string" required="yes" default="#NullString#" />
		
		<cfreturn reFindNoCase("^(http(s?)\:\/\/)?[\w-]*(\.?[\w-]+)*(\.([a-zA-Z0-9]{2}|(com|net|org|edu|mil|biz|gov|info|museum))){1}(/[\w- ./?%&##=]*)?$", Arguments.str) gt 0>
	</cffunction>
	
	
	
	<!------------------------------------------------------------------------------------------------------
	
		UTILITY FUNCTIONS
	
	 ------------------------------------------------------------------------------------------------------>
	
	<!--- 
		trims all the values of the structure (form or url or other)
	 --->
	<cffunction name="TrimStruct" access="public" returntype="struct">
		<cfargument name="Object" type="struct" required="yes">
		
		<cfset keys = StructKeyArray(Arguments.Object)>
		
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<cfset Arguments.Object[keys[i]] = trim(Arguments.Object[keys[i]])>
		</cfloop>
			
		<cfreturn Arguments.Object>
	</cffunction>
	
	
	<!--- 
		transfers the struct scope (form/url/struct) to a query scope
	 --->
	<cffunction name="StructToQuery" access="public" returntype="query">
		<cfargument name="Object" type="struct" required="yes">
		
		<!--- create a list of columns --->
		<cfset keys = ArrayToList(StructKeyArray(Arguments.Object))>
		
		<!--- create the query --->
		<cfset objQuery = queryNew(keys)>
		<cfset temp = queryAddRow(objQuery)>
		
		<!--- populate the query --->
		<cfloop list="#keys#" index="i">
			<cfset temp = querySetCell(objQuery, i, Arguments.Object[i])>
		</cfloop>
			
		<cfreturn objQuery>
	</cffunction>
	
	<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		FixWebsite
			* adds the http:// if it doens't exist
	 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--->
	<cffunction name="FixWebsite" access="public" returntype="string">
		<cfargument name="WebURL" type="string" required="yes">
		
		<cfset Arguments.WebURL = trim(Arguments.WebURL)>
		
		<!--- make sure the url has a full link --->
		<cfif left(Arguments.WebURL, 7) neq "http://" and left(Arguments.WebURL, 8) neq "https://">
			<cfset Arguments.WebURL = "http://" & Arguments.WebURL>
		</cfif>
		
		<cfreturn Arguments.WebURL>
	</cffunction>
	
</cfcomponent>