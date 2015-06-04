<cfscript>

	// Define contants
	NullInt = -2147483648;
	NullGuid = '00000000-0000-0000-0000-000000000000';
	NullDate = '01/01/1900';
	NullTime = '00:00:00';
	NullString = '';
	NullBool = False;
	
	/* 
		Define RequiredRole variable.
		This variable will be used in the verifyAccess template to grant access to users that possess this role, regardless of their highest rank.
	 */
	RequiredRole = '';
	
	function TrueFalseFormat(value)
	{
		var retVal = NullBool;
		if(Arguments.value == 1)
		{
			retVal = True;
		}
		else if(Arguments.value == 'yes')
		{
			retVal = True;
		}
		
		return retVal;
		
	}
	
	function BitFormat(value)
	{
		var retVal = 0;
		if(Arguments.value == 'True')
		{
			retVal = 1;
		}
		else if(Arguments.value == 'yes')
		{
			retVal = 1;
		}
		
		return retVal;
		
	}
	
	function YesNo(value)
	{
		var retVal = 'No';
		if(Arguments.value == 1)
		{
			retVal = 'Yes';
		}
		else if(Arguments.value == 'True')
		{
			retVal = 'Yes';
		}
		
		return retVal;
	}
	
	function GetString(value)
	{
		var retVal = NullString;
		try
		{
			if(Len(Trim(Arguments.value)) gt 0)
			{
				retVal = Trim(Arguments.value);
			}
		}
		catch(any excpt)
		{
		}
		
		return retVal;
	}
	
	function GetInt(value)
	{
		var retVal = NullInt;
		try
		{
			if(isNumeric(Arguments.value))
			{
				retVal = Arguments.value;
			}
		}
		catch(any excpt)
		{
		}
		
		return retVal;
	}
	
	function GetBool(value)
	{
		var retVal = False;
		try
		{
			retVal = TrueFalseFormat(Arguments.value);
		}
		catch(any excpt)
		{
		}
		
		return retVal;
	}
	
	function GetGuid(value)
	{
		var retVal = NullGuid;
		//use regex to find out of the value is a guid
		try
		{
			if(IsGuid(Arguments.value))
			{
				retVal = Arguments.value;
			}
		}
		catch(any excpt)
		{
		}
		
		return retVal;
	}
	
	function GetDate(value)
	{
		var retVal = NullDate;
		
		try
		{
			if(IsDate(Arguments.value))
			{
				retVal = Arguments.value;
			}
		}
		catch(any excpt)
		{
		}
		
		return retVal;
	}
	
	function SetIsPostback()
	{
		var retVal = False;
		try
		{
			if(isDefined('form') AND StructCount(form) gt 0)
			{
				retVal = True;
			} 
		}
		catch(any excpt)
		{
		}
		
		return retVal;
	}
	
	/*
		Validation Functions
	*/
	
	// Strips a string of all chars except alphanumeric ones.
	function StripToAlphaNumeric(str)
	{
		var temp = '';
		
		str = trim(Arguments.str);
		
		for (i=1; i LTE Len(Arguments.str); i=i+1)
		{
			if(refindNoCase("[a-zA-Z0-9]", mid(Arguments.str, i, 1)) gt 0)
			{
				temp = temp & mid(Arguments.str, i, 1);
			}
		}
		
		return temp;
	}
	
	// Strips a string of all chars except numeric ones.
	function StripToNumeric(str)
	{
		var temp = '';
		
		str = trim(Arguments.str);
		
		for (i=1; i LTE Len(Arguments.str); i=i+1)
		{
			if(refindNoCase("[0-9]", mid(Arguments.str, i, 1)) gt 0)
			{
				temp = temp & mid(Arguments.str, i, 1);
			}
		}
		
		return temp;
	}
	
	// Strips a string to a guid.
	function StripToGuid(str)
	{
		var temp = '';
		
		str = trim(Arguments.str);
		
		for (i=1; i LTE Len(Arguments.str); i=i+1)
		{
			if(refindNoCase("[a-zA-Z0-9\-]", mid(Arguments.str, i, 1)) gt 0)
			{
				temp = temp & mid(Arguments.str, i, 1);
			}
		}
		
		return temp;
	}
	
	// Checks to see if a string validates for a pattern.
	function IsPattern(str, pattern)
	{
		var p = '';
		var s = '';
		
		str = trim(Arguments.str);
		
		if(len(Arguments.str) neq len(Arguments.pattern))
		{
			return false;
		}
		
		for (i=1; i LTE Len(Arguments.str); i=i+1)
		{
			p = mid(Arguments.pattern, i, 1);
			s = mid(Arguments.str, i, 1);
			
			if(p eq "9" and (s lt 0 and s gt 9))
			{
				return false;
			}
			else if(p eq "a" and reFindNoCase("[a-zA-Z]", s) eq 0)
			{
				return false;
			}
			else if(p neq 9 and (p neq "a" and p neq s))
			{
				return false;
			}
		}
		
		return true;
	}
	
	// Checks to see if a string is a guid.
	function IsGuid(str)
	{
		return refindNoCase('^[{|\(]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[\)|}]?$', Arguments.str);
	}
	
	// Checks a phone value for common patterns (us and can only).
	function IsPhone(str)
	{
		return IsPattern(Arguments.str, "(999) 999-9999") OR IsPattern(Arguments.str, "(999) 999.9999") OR IsPattern(Arguments.str, "999 999 9999") OR IsPattern(Arguments.str, "999-999-9999") OR IsPattern(Arguments.str, "999.999.9999") OR IsPattern(Arguments.str, "9999999999") OR IsPattern(Arguments.str, "999-9999") OR IsPattern(Arguments.str, "999.9999") OR IsPattern(Arguments.str, "999 9999") OR IsPattern(Arguments.str, "9999999");
	}
	
	// Checks to see if a string is a date.
	/*function IsDate(str)
	{
		return ReFindNoCase('^\d{1,2}\/\d{1,2}\/\d{4}$', Arguments.str);
	}*/
	
	// Return if the string contains just alphanumeric characters.
	function IsAlphaNumeric(str)
	{
		str = trim(Arguments.str);
		
		for (i=1; i LTE Len(Arguments.str); i=i+1)
		{
			if(refindNoCase("[a-zA-Z0-9\s]", mid(Arguments.str, i, 1)) eq 0)
			{
				return false;
			}
		}
		
		return true;
	}
	
	// Return if the string is empty.
	function IsEmpty(str)
	{
		if(Len(Trim(Arguments.str)) lt 1)
		{
			return true;
		}
		
		return false;
	}
	
	// Return if the string contains only letters, numbers, and underscores.
	function IsOnlyLetters(str)
	{
		str = trim(Arguments.str);
		
		for (i=1; i LTE Len(Arguments.str); i=i+1)
		{
			if(refindNoCase("[a-zA-Z0-9_]", mid(Arguments.str, i, 1)) eq 0)
			{
				return false;
			}
		}
		
		return true;
	}
	
	// Validates an email address.
	function IsEmail(str)
	{
		str = trim(Arguments.str);
		
		return reFindNoCase("^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.([a-zA-Z]{2}|com|net|org|edu|mil|biz|gov|info|museum|name|coop|int)$", Arguments.str) gt 0;
	}
	
	// Validates an website URL.
	function IsWebsite(str)
	{
		str = trim(Arguments.str);
		
		return reFindNoCase("^(http(s?)\:\/\/)?[\w-]*(\.?[\w-]+)*(\.([a-zA-Z0-9]{2}|(com|net|org|edu|mil|biz|gov|info|museum))){1}(/[\w- ./?%&##=]*)?$", Arguments.str) gt 0;
	}
	
	// 
	
</cfscript>