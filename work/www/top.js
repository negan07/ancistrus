function languageShowlist()
{
	document.write('<option value=Auto>Auto</option>');
	if (language_oriArray != "")
	{
		for (j=0; j<language_oriArray.length; j++)
		{
			document.write('<option value='+language_oriArray[j]+'>'+language_showArray[j]+'</option>');
		}
	}
	else
		document.write('<option value=English>'+language_oriArray[0]+'</option>');
}

function change_container_posision()
{
	if( document.body.clientWidth < document.body.scrollWidth )
		document.getElementById("container").className="container_left";
	else
		document.getElementById("container").className="container_center";
}

function goto_top( page)
{
	top.location.href=page;
}

function change_select()
{
	form=document.forms[0];

        if( form.lang_avi.value == lang_select && !(lang_select == "Auto" && browser_lang != gui_region))
        {
                if(jp_multiPPPoE == "1" && form.lang_avi.value != "Japanese")
                {
                        form.hidden_lang_avi.value=form.lang_avi.value;
                        form.action="/apply.cgi?/index.htm timestamp="+ts;
                        form.submit_flag.value="change_multiPPPoE_status";
                        //form.submit();
			top.location.href="index.htm";
                }else
                        location.reload();
        }
        else
        {
                form.lang_avi.disabled=true;
                form.hidden_lang_avi.value=form.lang_avi.value;
		form.target="formframe";
                //form.submit();
		top.formframe.location.href="lang_check.html";
        }
}

function firmwareUpgrade()
{
	goto_formframe('setup.cgi?todo=upg_detfw');
}

function do_search()
{
	var key = document.forms[0].search.value.replace(/ /g,"%20");
	var winoptions = "width=960,height=800,menubar=yes,scrollbars=yes,toolbar=yes,status=yes,location=yes,resizable=yes";
	var url="http://kb.netgear.com/app/answers/list/kw/"+key;

	window.open(url,null,winoptions);
}

function setLabelClass(label, className)
{
	var words_len = label.getElementsByTagName("span")[0].innerHTML.length;

	if(words_len >= 16)
		label.className = className + "_longest";
	else if(words_len >= 12)
		label.className = className + "_long";
	else if(words_len >= 10)
		label.className = className + "_middle";
	else
		label.className = className;
}

function load_top_value()
{
	form=document.forms[0];

	var width = top.document.documentElement.clientWidth;
	var upgrade_div = document.getElementById("update_info");
	if(upgrade_div != null)
	{
		if(wan_status==1 && config_status==9999 && updateFirmware==1)
			upgrade_div.style.display = "inline";
		else
			upgrade_div.style.display = "none";
	}
	
	var basic_label = document.getElementById("basic_label");
	var advanced_label = document.getElementById("advanced_label");
	var anc_label = document.getElementById("anc_label");

	if(type == "basic")
	{
		setLabelClass(basic_label, "label_click");
		setLabelClass(advanced_label, "label_unclick");
		setLabelClass(anc_label, "label_unclick");
	}
	else if(type == "advanced")
	{
		setLabelClass(basic_label, "label_unclick");
		setLabelClass(advanced_label, "label_click");
		setLabelClass(anc_label, "label_unclick");
	}
	else if(type == "anc")
	{
		setLabelClass(basic_label, "label_unclick");
		setLabelClass(advanced_label, "label_unclick");
		setLabelClass(anc_label, "label_click");
	}

	/* to fix bug 25107 */
	if( upgrade_div != null && upgrade_div.style.display != "none")
	{
		var upgrade_mess = upgrade_div.getElementsByTagName("i")[0];
		var left = document.getElementById("labels").clientWidth + 20;
		var free_width = width - left - 181;
		var info_width = document.getElementById("update_info_middle").clientWidth + 34;

		if( free_width > info_width )
		{
			var upgrade_left = (free_width - info_width)/2 > 20 ? 20 : (free_width - info_width)/2;
			upgrade_div.className = "update_info_down";
			upgrade_div.style.left = (left + upgrade_left) + "px";
		}
		else
		{
			upgrade_div.className="update_info_up";
			upgrade_div.style.left="270px";
		}
	}
}


function detectEnter(type, e)
{
     var keycode, event;
	 if (window.event)
        {
                event = window.event;
                keycode = window.event.keyCode;
        }
        else if (e)
        {
                event = e;
                keycode = e.which;
        }
        else 
			return true;
			
		if(type == "num")
		{
	  if(keycode==13)
			do_search();
		}
		else
		return false;
}
