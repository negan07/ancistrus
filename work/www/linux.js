var separator = "\n";  // used for string=> multiple select list

// ====================================================== Submit Functions

function radioTable(fObj,radioObj,act_str)
{
	if (radioSelectedIndex(radioObj) > -1)
			stdAction(fObj,act_str);
	else alert(getErrorMsgByVar("gsm_msg_fw_no_select"));
}

function AncradioTable(fObj, radioObj, act_str)
{
	if (radioSelectedIndex(radioObj)>-1)
			AncstdAction(fObj, act_str);
	else alert(getErrorMsgByVar("gsm_msg_fw_no_select"));
}

function radioTable_USB(fObj,radioObj)
{
	if ( radioSelectedIndex(radioObj)< 0)
		alert(getErrorMsgByVar("gsm_msg_fw_no_select"));
}

function stdAction(fObj,act_str)
{
	fObj.todo.value = act_str;
	dataToHidden(fObj);
        fObj.submit();
}

function AncstdAction(fObj, file_str, old_file_str, job_str, act_str) {
	fObj.next_file.value=file_str;
	fObj.old_file.value=old_file_str;
	fObj.job.value=job_str;
	fObj.todo.value=act_str;
	AncdataToHidden(fObj);
        fObj.submit();
}

//========================================================= Data Transfer Functions

function optionSelected(sel_obj) // return true or false
{
	return (sel_obj.selectedIndex > -1 && sel_obj.selectedIndex< sel_obj.options.length) ? true : false;
}

function getSelIndex(sel_object, sel_text)
{
	if (sel_text.length == 0)
		return 0;
	var size = sel_object.options.length;
	for (var i = 0; i< size; i++)
	{
		if ( (sel_object.options[i].text == sel_text) || (sel_object.options[i].value == sel_text) )
			return(i);
	}
	return 0;  // if no match
}

function getSelected(sel_obj)  // single select. Returns value. If value blank, return text
{
	var index = sel_obj.selectedIndex;
	if (index >= 0)
		return (sel_obj.options[index].value != "") ? sel_obj.options[index].value : sel_obj.options[index].text;
	else return "";
}

function getMultiSelected(sel_obj)  // multi select. Always use text, not value
{
	var size = sel_obj.options.length;
	var i;
	var str = "";
	if(isNaN(size))
		return str;
	if(size == 0)
		return str;
	str = separator;
	for(i = 0; i< size; i++)
		if (sel_obj.options[i].selected)
			str+= sel_obj.options[i].text + separator;
	return str;
}

function AncgetMultiSelected(sel_obj, tag, textflag) {  // same as above with separator & text/value choice param & without separator beginning
	var size=sel_obj.options.length, i, str="";

	if(isNaN(size) || size==0) return str;
		for(i=0;i<size;i++) {
			if(sel_obj.options[i].selected) {
				if(!textflag) str+=tag+sel_obj.options[i].text;
				else str+=tag+sel_obj.options[i].value;
			}
		}
	return str.replace(tag, "");
}

function setSelected(sel_obj,list) // list has multiple items from select obj
{
	var selSize = sel_obj.options.length;
	var startTextPos;  	var startValuePos;
	var textChar; 	        var valueChar;
	for ( var i =0 ; i< selSize; i++)
	{
		startTextPos = -1;
		startValuePos = -1;
		sel_obj.options[i].selected = false;
		startTextPos = list.indexOf(separator + sel_obj.options[i].text + separator);
		if(sel_obj.options[i].value.length > 0)
			startValuePos = list.indexOf(separator + sel_obj.options[i].value + separator);
		if (startTextPos > -1)
			sel_obj.options[i].selected = true;
		if (startValuePos > -1)
			sel_obj.options[i].selected = true;
	}
}

function radioSelectedIndex(radio_object) // index of selected item, -1 if none
{
	if (!radio_object)
		return -1;
	var size = radio_object.length;
	if(isNaN(size))
	{
		if(radio_object.checked == true)
			return 0;
		else
			return -1;
	}
	for (var i = 0; i< size; i++)
	{
		if(!(radio_object[i]))
			return (radio_object.checked) ? 0 : -1;
		if (radio_object[i].checked)
			return(i);
	}
	if(radio_object.checked == true)
		return 0;
	else
		return -1;
}


function getRadioCheckedValue(radio_object)   // value of selected item, "" if none
{
	var index = 0;
	if (!radio_object)
		return "";
	var size = radio_object.length;
	if(isNaN(size))
	{
		if (radio_object.checked == true)
			return radio_object.value;
		else
			return "";
	}
	for (var i = 0; i< size; i++)
	{
		if(!(radio_object[i]))
			continue;
		if (radio_object[i].checked == true)
			return(radio_object[i].value);
	}
	if (radio_object.checked == true)
		return radio_object.value;
	else
		return "";
}

function getRadioIndex(radio_object, checked_value)  // find index matching checkecd_value, 0 if no match
{
	if (!radio_object)
		return 0;
	if(radio_object.value == checked_value)
		return 0;
	var size = radio_object.length;
	if(isNaN(size))
		return 0;
	for (var i = 0; i< size; i++)
	{
		if(!(radio_object[i]))
			continue;
		if (radio_object[i].value == checked_value)
			return  i;
	}
	return  0;   // if no match
}

function ip1to4(ipaddr,ip1,ip2,ip3,ip4)
{
	var len;
	var tmp;
	var all;
	all=ipaddr.value;

	//ip1
	len=all.length;
	tmp=all.indexOf(".");
	ip1.value=all.substring(0,tmp);

	//ip2
	all=all.substring(tmp+1,len);
	len=all.length;
	tmp=all.indexOf(".");
	ip2.value=all.substring(0,tmp);

	//ip3
	all=all.substring(tmp+1,len);
	len=all.length;
	tmp=all.indexOf(".");
	ip3.value=all.substring(0,tmp);

	//ip4
	all=all.substring(tmp+1,len);
	ip4.value=all;
}

function ip4to1(ipaddr,ip1,ip2,ip3,ip4)
{
	if (ip1.value.length>0)
		ipaddr.value=parseInt(ip1.value, 10)+"."+parseInt(ip2.value, 10)+"."+parseInt(ip3.value, 10)+"."+parseInt(ip4.value, 10);
	else
		ipaddr.value="";
}

function dataToVisible(form_obj)  // both hidden & visible fields in same form
{
	var form_size = form_obj.elements.length;
	var sourceField; 	var last_name; 	 var radioIndex;  var baseRef;

	for (var i = 0; i< form_size; i++)
	{
 		if (form_obj.elements[i].name.substr(0,3)=="c4_")
 		{
			baseRef = "form_obj." + form_obj.elements[i].name.substr(3);
 			ip1to4(form_obj.elements[i], eval(baseRef+"1"), eval(baseRef+"2"), eval(baseRef+"3"), eval(baseRef+"4"));
		}
		if (form_obj.elements[i].name.substr(0,3)=="c6_")
                {
                        macRef = "form_obj." + form_obj.elements[i].name.substr(3);
                        mac1to6(form_obj.elements[i], eval(macRef+"1"), eval(macRef+"2"), eval(macRef+"3"), eval(macRef+"4"), eval(macRef+"5"), eval(macRef+"6"));
                }
		sourceField = eval("form_obj.h_" + form_obj.elements[i].name);
		if(!(sourceField))
			continue;
		if(sourceField.value == "")
			continue;
		if (form_obj.elements[i].type=="select-one")
			form_obj.elements[i].selectedIndex = getSelIndex(form_obj.elements[i], sourceField.value);
		if (form_obj.elements[i].type=="select-multiple")
			setSelected(form_obj.elements[i],sourceField.value);
		if (form_obj.elements[i].type == "checkbox")
			form_obj.elements[i].checked = (sourceField.value == "enable");
		if (form_obj.elements[i].type == "radio")
		{
			if (last_name == form_obj.elements[i].name)
				continue; // already done this one
			last_name = form_obj.elements[i].name;
			radioIndex = getRadioIndex(form_obj.elements[form_obj.elements[i].name],sourceField.value);
			if(form_obj.elements[form_obj.elements[i].name][radioIndex])
				form_obj.elements[form_obj.elements[i].name][radioIndex].checked = true;
			else
				form_obj.elements[form_obj.elements[i].name].checked = true;
		}
	}
}

function AncdataToVisible(form_obj)  // both hidden & visible fields in same form: differs from above of checkbox value "enable" <==> "1"
{
	var form_size = form_obj.elements.length;
	var sourceField, last_name, radioIndex, baseRef;

	for (var i = 0; i< form_size; i++)
	{
 		if (form_obj.elements[i].name.substr(0,3)=="c4_")
 		{
			baseRef = "form_obj." + form_obj.elements[i].name.substr(3);
 			ip1to4(form_obj.elements[i], eval(baseRef+"1"), eval(baseRef+"2"), eval(baseRef+"3"), eval(baseRef+"4"));
		}
		if (form_obj.elements[i].name.substr(0,3)=="c6_")
                {
                        macRef = "form_obj." + form_obj.elements[i].name.substr(3);
                        mac1to6(form_obj.elements[i], eval(macRef+"1"), eval(macRef+"2"), eval(macRef+"3"), eval(macRef+"4"), eval(macRef+"5"), eval(macRef+"6"));
                }
		sourceField = eval("form_obj.h_" + form_obj.elements[i].name);
		if(!(sourceField))
			continue;
		if(sourceField.value == "")
			continue;
		if (form_obj.elements[i].type=="select-one")
			form_obj.elements[i].selectedIndex = getSelIndex(form_obj.elements[i], sourceField.value);
		if (form_obj.elements[i].type=="select-multiple")
			setSelected(form_obj.elements[i],sourceField.value);
		if (form_obj.elements[i].type == "checkbox")
			form_obj.elements[i].checked = (sourceField.value == "1");
		if (form_obj.elements[i].type == "radio")
		{
			if (last_name == form_obj.elements[i].name)
				continue; // already done this one
			last_name = form_obj.elements[i].name;
			radioIndex = getRadioIndex(form_obj.elements[form_obj.elements[i].name],sourceField.value);
			if(form_obj.elements[form_obj.elements[i].name][radioIndex])
				form_obj.elements[form_obj.elements[i].name][radioIndex].checked = true;
			else
				form_obj.elements[form_obj.elements[i].name].checked = true;
		}
	}
}

function dataToHidden(form_obj)  // both hidden & visible fields in same form
{
	var form_size = form_obj.elements.length;
	var destField; 	var last_name; 	 var radioIndex;  var baseRef;

	for (var i = 0; i< form_size; i++)
	{
 		if (form_obj.elements[i].name.substr(0,3)=="c4_")
 		{
			baseRef = "form_obj." + form_obj.elements[i].name.substr(3);
 			ip4to1(form_obj.elements[i], eval(baseRef+"1"), eval(baseRef+"2"), eval(baseRef+"3"), eval(baseRef+"4"));
		}
		if (form_obj.elements[i].name.substr(0,3)=="c6_")
		{
                        macRef = "form_obj." + form_obj.elements[i].name.substr(3);
                        mac6to1(form_obj.elements[i], eval(macRef+"1"), eval(macRef+"2"), eval(macRef+"3"), eval(macRef+"4"), eval(macRef+"5"), eval(macRef+"6"));
                }
		destField = eval("form_obj.h_" + form_obj.elements[i].name);
		if(!(destField))
			continue;
		if (form_obj.elements[i].type=="select-one")
			destField.value = getSelected(form_obj.elements[i]);
		if (form_obj.elements[i].type=="select-multiple")
			destField.value = getMultiSelected(form_obj.elements[i]);
		if (form_obj.elements[i].type == "checkbox")
			destField.value = (form_obj.elements[i].checked) ? "enable" : "disable";
		if (form_obj.elements[i].type == "radio")
		{
			if (last_name == form_obj.elements[i].name)
				continue; // already done this one
			last_name = form_obj.elements[i].name;
			destField.value =  getRadioCheckedValue(form_obj.elements[form_obj.elements[i].name]);
		}

	}
}

function AncdataToHidden(form_obj)  // both hidden & visible fields in same form: differs from above of "enable" : "disable" <==> "1" : "0"
{
	var form_size = form_obj.elements.length;
	var destField, last_name, radioIndex, baseRef;

	for (var i = 0; i< form_size; i++)
	{
 		if (form_obj.elements[i].name.substr(0,3)=="c4_")
 		{
			baseRef = "form_obj." + form_obj.elements[i].name.substr(3);
 			ip4to1(form_obj.elements[i], eval(baseRef+"1"), eval(baseRef+"2"), eval(baseRef+"3"), eval(baseRef+"4"));
		}
		if (form_obj.elements[i].name.substr(0,3)=="c6_")
		{
                        macRef = "form_obj." + form_obj.elements[i].name.substr(3);
                        mac6to1(form_obj.elements[i], eval(macRef+"1"), eval(macRef+"2"), eval(macRef+"3"), eval(macRef+"4"), eval(macRef+"5"), eval(macRef+"6"));
                }
		destField = eval("form_obj.h_" + form_obj.elements[i].name);
		if(!(destField))
			continue;
		if (form_obj.elements[i].type=="select-one")
			destField.value = getSelected(form_obj.elements[i]);
		if (form_obj.elements[i].type=="select-multiple")
			destField.value = getMultiSelected(form_obj.elements[i]);
		if (form_obj.elements[i].type == "checkbox")
			destField.value = (form_obj.elements[i].checked) ? "1" : "0";
		if (form_obj.elements[i].type == "radio")
		{
			if (last_name == form_obj.elements[i].name)
				continue; // already done this one
			last_name = form_obj.elements[i].name;
			destField.value =  getRadioCheckedValue(form_obj.elements[form_obj.elements[i].name]);
		}

	}
}

// =================================== Development ========================

function mac1to6(macaddr,mac1,mac2,mac3,mac4,mac5,mac6)
{
	var len;
        var tmp;
        var all;
        all=macaddr.value;

        //mac1
        len=all.length;
	tmp=all.indexOf(":");
        mac1.value=all.substring(0,tmp);

        //mac2
	all=all.substring(tmp+1,len);
        len=all.length;
        tmp=all.indexOf(":");
        mac2.value=all.substring(0,tmp);

        //mac3
        all=all.substring(tmp+1,len);
        len=all.length;
        tmp=all.indexOf(":");
        mac3.value=all.substring(0,tmp);

        //mac4
        all=all.substring(tmp+1,len);
        len=all.length;
        tmp=all.indexOf(":");
        mac4.value=all.substring(0,tmp);

        //mac5
        all=all.substring(tmp+1,len);
        len=all.length;
        tmp=all.indexOf(":");
        mac5.value=all.substring(0,tmp);

        //mac6
        all=all.substring(tmp+1,len);
        mac6.value=all;
}

function mac6to1(macaddr,mac1,mac2,mac3,mac4,mac5,mac6)
{
        if (mac1.value.length>0)
                macaddr.value=mac1.value+":"+mac2.value+":"+mac3.value+":"+mac4.value+":"+mac5.value+":"+mac6.value;
        else
                macaddr.value="";
}

function value_enable_disable(str)
{
    if(str == "disable")
        str = 0;
    else
        str = 1;

    return str;
}

function buttonToDisabled(form_obj)
{
    var form_size = form_obj.elements.length;
    for (var i = 0; i< form_size; i++)
    {
        if (form_obj.elements[i].type.toLowerCase()=="submit"
        || form_obj.elements[i].type.toLowerCase()=="button"
        || form_obj.elements[i].type.toLowerCase()== "reset")
        {
            form_obj.elements[i].disabled = true;
        }
    }
}

/* Complementary of above: hidden types remain enabled */
function notbuttonToDisabled(form_obj) {
	
	var form_size=form_obj.elements.length;
		for(var i=0;i<form_size;i++) {
		if(form_obj.elements[i].type=="select-one"
		|| form_obj.elements[i].type=="select-multiple"
		|| form_obj.elements[i].type=="checkbox"
		|| form_obj.elements[i].type=="radio"
		|| form_obj.elements[i].type=="text")
		form_obj.elements[i].disabled=true;
		}
}

/* All things disabled */
function allToDisabled(form_obj) {

	var form_size=form_obj.elements.length;
	for(var i=0;i<form_size;i++) form_obj.elements[i].disabled=true;
}

/* All things enabled */
function allToEnabled(form_obj) {

	var form_size=form_obj.elements.length;
	for(var i=0;i<form_size;i++) form_obj.elements[i].disabled=false;
}

/* Redirect to wiki page sections */
function gotoWiki(section) {
	var wikiurl='https://github.com/negan07/ancistrus/wiki/';
	
	var url=wikiurl+section;

	window.open(url);
}

/* Print fixed help code */
function printHelp() {
document.write('<div id="help" style="display: none"><iframe name="help_iframe" id="helpframe" src="anc_help.htm" allowtransparency="true" width="100%" frameborder="0"></iframe></div><div id="help_switch" class="close_help"><img class="help_switch_img" src="image/help/help-bar.gif">\n<script>\nvar help_flag=0;\nif(isIE()){\nshow_hidden_help_top_button(1);\nvar frame_div = top.document.getElementById("formframe_div");\nframe_div.onresize = function(){\nif(help_flag == 0) show_hidden_help_top_button(1);\nelse{show_hidden_help_top_button(--help_flag);help_flag++;}\n};}\nif(get_browser() == "Opera"){\nwindow.onresize = function(){\nif(help_flag == 0) show_hidden_help_top_button(1);\nelse{show_hidden_help_top_button(--help_flag);help_flag++;}\n};}\n</script>\n<div id="help_space" onClick="show_hidden_help_top_button(help_flag); help_flag++;"></div><div id="help_center"><span languageCode="3016">Help Center</span></div><div id="help_button" onClick="show_hidden_help_top_button(help_flag); help_flag++;"></div><div id="help_show_hidden"><a href="javascript:void(0)" onClick="show_hidden_help_top_button(help_flag); help_flag++;"><span languageCode="3017">Show/Hide Help Center</span></a></div></div><script language="javascript" type="text/javascript" src="langs.js"></script>');
}
