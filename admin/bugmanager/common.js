
// Popup Functions
function popwin() {		
	var popW = 400, popH = 400;
	var w = screen.availWidth;
	var h = screen.availHeight;
	var popName = "myWin";
	
	page = popwin.arguments[0];
	
	if(popwin.arguments[1]) popW = popwin.arguments[1];
	if(popwin.arguments[2]) popH = popwin.arguments[2];
	if(popwin.arguments[3]) popName = popwin.arguments[3];
	
	var leftPos = (w-popW)/2, topPos = (h-popH)/2;
	
	myWin = window.open(page,popName,"resizable=1,scrollbars=1,width="+popW+",height="+popH+",top="+topPos+",left="+leftPos)
	myWin.focus();
}

function MM_openBrWindow(theURL,winName,features) {
	window.open(theURL,winName,features);
}

function searchSelect(txt, el) {
	var field = eval("document.myform." + el);
	
	txt = txt.toLowerCase();
	txtLen = txt.length;
	
	if(txt.length == 0) {
		field.options[0].selected = true;
		return;
	}
	
	for(i=0; i < field.options.length; i++) {
		if(txt.substring(0,txtLen+1) == field.options[i].text.substring(0,txtLen).toLowerCase()) {
			field.options[i].selected = true;
			break;
		}
	}
}


//=========================================================
// FUNC:	getSelectMultIndex
// PARM:	input - ref to form select-multiple input
//  RES:	array containing selected indexes
//=========================================================
function getSelectMultIndex(input) {
	var aResult = new Array();

	for (var i=0; i < input.options.length; i++) {
		if(input.options[i].value == "-1") {input.options[i].selected = false}
		if (input.options[i].selected) aResult[aResult.length] = i;
	}	
	return aResult;
}

//=========================================================
// FUNC:	moveOption() - Moves clients from one select to the other
// PARM:	Direction (right or left)//  
//=========================================================
function moveOption(sBoxFrom, sBoxTo) {
	var tempVals
	var count
	var counter = 0
	var fields = document.myform
	var fromFieldCount = eval("fields." + sBoxFrom + ".length")
	
	tempVals = getSelectMultIndex(eval("fields." + sBoxFrom))
	count = tempVals.length
	
	for (i=0; i<count; i++) {
			//add item to the other side
			fieldCount = eval("fields." + sBoxTo + ".length")
			myVal = eval("fields." + sBoxFrom + ".options[" + (tempVals[i]-i) + "].value")
			myText = eval("fields." + sBoxFrom + ".options[" + (tempVals[i]-i) + "].text")
			eval("fields." + sBoxTo + ".options[fieldCount] = new Option(myText, myVal, false, false)")
			
			//delete the item
			eval("fields." + sBoxFrom + ".options[" + (tempVals[i]-i) + "] = null")
	}
}


function shiftOption(input, dir) {
	var field = eval("document.myform." + input);
	var tempVals = getSelectMultIndex(field);
	var aValues = new Array();

	for(i=0; i < field.options.length; i++) {
		//move the item
		if(field.options[i].selected && field.options[i].value != "-1") { 
		
			//is it out of bounds
			if(dir == 1 && i == field.options.length - 1) return;
			if(dir == -1 && i == 0) return;
			
			myVal = field.options[i].value.substring(0, field.options[i].value.indexOf("_"));
			//mySort = field.options[i].value.substring(field.options[i].value.indexOf("_") + 1);
			myText = field.options[i].text;
			
			myVal2 = field.options[i + dir].value.substring(0, field.options[i + dir].value.indexOf("_"));
			//mySort2 = field.options[i + dir].value.substring(field.options[i + dir].value.indexOf("_") + 1);
			myText2 = field.options[i + dir].text;
			
			myVal = myVal //+ "_" + mySort2;
			myVal2 = myVal2 //+ "_" + mySort;
			
			field.options[i] = new Option(myText2, myVal2);
			field.options[i + dir] = new Option(myText, myVal);				
			
			//add it to the array
			aValues[aValues.length] = field.options[i + dir].value;	
		}
	}		
	//go through and re-select them
	for(i=0; i < aValues.length; i++) {
		for(j=0; j < field.options.length; j++) {
			if(field.options[j].value == aValues[i]) field.options[j].selected = true;
		}
	}
}
	

function selectAll(input) {
	var field = eval("document.myform." + input);
		
	for(i=0; i < field.options.length; i++) {
		if(field.options[i].value == "-1") {field.options[i].selected = false;}
		else field.options[i].selected = true;
	}		
}

function limitTextarea(obj, maxlength, statusid) {
		if(obj.value.length > maxlength) obj.value = obj.value.substring(0, maxlength);
		document.getElementById(statusid).innerHTML = maxlength - obj.value.length;
}