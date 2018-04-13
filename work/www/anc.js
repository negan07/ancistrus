var single_items=["home","opkg"];
var menu_list=["setup","admin","net","storage","misc"];

/* read a file containings tags for submenus */
function readFileTags(filename) {
var xmlhttp;
	
if(window.ActiveXObject) xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	if(!xmlhttp && typeof XMLHttpRequest!='undefined') {
		try {
		xmlhttp = new XMLHttpRequest();
		}
		catch(e) {
		xmlhttp=false;
		alert('XHR error: '+e);
		}
	}
xmlhttp.open("GET", filename, false);
xmlhttp.send(null);
return xmlhttp;
}

/* dynamically populate a submenu */
function populate_submenu(sub_men_name) {
var pkg="Package: ";
var sec="Section: ";
var xmlhttp=readFileTags("opkgstatus");

	if(xmlhttp.readyState==4 && xmlhttp.status==200) {
	var str=xmlhttp.responseText;
	var line=str.split('\n');
	var linelen=line.length;
		for(var i=0;i<linelen;i++) {
			if(line[i].indexOf(pkg)>-1) var pkgname=line[i].replace(pkg, "");
			else if(line[i].indexOf(sec)>-1 && line[i].replace(sec, "")==sub_men_name) {
			var submenu="<dt id=\""+pkgname+"\" class=\"sub_back\"><a target=\"formframe\" onclick=\"linksetup('"+pkgname+"', 'ipk')\"><b><span>"+pkgname.toUpperCase()+"</span></b></a></dt>\n";
			document.write(submenu);
			}
		}
	}
}

/* fold all menus, except the menu which user click */
function close_all_sub(click_name) {
	var len=menu_list.length;

	for(var i=0;i<len;i++) {
	var button_name = menu_list[i]+"_bt";
	var sub_name = menu_list[i]+"_sub";
		if( sub_name != click_name ) {
		var div_name = top.document.getElementById(button_name);
		var content_length = div_name.getElementsByTagName("span")[0].innerHTML.length;
	settingClass(div_name, content_length, "advanced_white_close_button", top.region_class.white_triple, top.region_class.white_double);
		top.document.getElementById(sub_name).style.display="none";
		}
	}
}

function open_or_close_sub(name) {
	/* to fix bug 23268, when user want to unfold one menus, fold the other menus. */
	var button_name= name+"_bt";
	var sub_name= name+"_sub";
	var open_flag= top.document.getElementById(sub_name).style.display;

	/* fold all menus first, except the menu which user click */
	close_all_sub(sub_name);

	var button_div = top.document.getElementById(button_name);
	var content_length = button_div.getElementsByTagName("span")[0].innerHTML.length;

	if( open_flag == "none") {
	settingClass(button_div, content_length, "advanced_white_open_button", top.region_class.white_triple, top.region_class.white_double);
	top.document.getElementById(sub_name).style.display="";
	}
	else {
	settingClass(button_div, content_length, "advanced_white_close_button", top.region_class.white_triple, top.region_class.white_double);
	top.document.getElementById(sub_name).style.display="none";
	}
	change_menu_height();
}

/* change the min-height of the formframe if unfold the last extensible menu */
function change_menu_height() {
	var footer_div = document.getElementById("footer");
	var is_double = (footer_div.className == "footer_double");
	var menu_height = document.getElementById("menu").clientHeight > 410 ? document.getElementById("menu").clientHeight : 410;

		if(isIE_or_Opera()) {
		var height = is_double ? document.documentElement.clientHeight - 190 : document.documentElement.clientHeight - 147;
		menu_height = height > menu_height ? height : menu_height;
		document.getElementById("container").style.height = is_double ? menu_height+93 : menu_height+ 50;
		document.getElementById("middle").style.height = is_double ?  menu_height+87+20+"px" : menu_height+ 45+20+"px";
		document.getElementById("formframe_div").style.height = menu_height;
		}
		else document.getElementById("middle").style.minHeight = is_double ? (menu_height + 87)+"px" : (menu_height+ 45)+"px";
}

function change_size() {
	setFooterClass();
	var footer_div = document.getElementById("footer");
	var is_double = (footer_div.className == "footer_double");

		if(isIE_or_Opera()) {
		/* to calculate the width */
		var width = document.documentElement.clientWidth - 40;
		document.getElementById("top").style.width = width > 820 ? width : "820px" ;
		document.getElementById("container").style.width = width > 820 ? width : "820px" ;
		document.getElementById("formframe_div").style.width = width > 820 ? width - 195 : "625px";
		}
	document.getElementById("formframe_div").style.bottom = is_double ? "88px" : "45px";
	change_menu_height();
}

/* according to the content length in a div,  change the div class type parameter: div name, div content length, class name to set, minimum length for triple class, ... */
function settingClass(obj, len, class_name) {
	var triple_len, double_len;

	switch(arguments.length) {
		case 4://four parameter, take the last on as double_len 
			triple_len = 9999;
			double_len = arguments[3];
			break;
		case 5:
			triple_len = arguments[3];
			double_len = arguments[4];
			break;
		default:
			triple_len = top.region_class.adv_btn_triple;
			double_len = top.region_class.adv_btn_double;
			break;
	}

	if(len >= triple_len)
		obj.className = class_name + "_triple";
	else if(len >= double_len)
		obj.className = class_name + "_double";
	else
		obj.className = class_name;
}

function subItemsClass() {
	var words_length, i, num;

	for(num=0;num<menu_list.length;num++) {
		var sub_item=menu_list[num]+"_sub";
		var sub_menu=top.document.getElementById(sub_item);
		var items=sub_menu.getElementsByTagName("dt");

		for(i=0;i<items.length;i++) {
			words_length=items[i].getElementsByTagName("span")[0].innerHTML.length;
			if(words_length>=20)
				items[i].className="long_name";
			else
				items[i].className="sub_back";
		}
	}
}

function menu_class_default() {
	var i, menu_div, content_length, extensible_item;

	for(i=0;i<single_items.length;i++) {
	menu_div = top.document.getElementById(single_items[i]);
	content_length = menu_div.getElementsByTagName("span")[0].innerHTML.length;
	settingClass(menu_div, content_length, "advanced_black_button");
	}

	for(i=0;i<menu_list.length;i++) {
	extensible_item=menu_list[i]+"_bt";
	menu_div = top.document.getElementById(extensible_item);
	content_length = menu_div.getElementsByTagName("span")[0].innerHTML.length;
	settingClass(menu_div, content_length, "advanced_white_close_button", top.region_class.white_triple, top.region_class.white_double);
	}

	subItemsClass();
}

function menu_color_change( change_id ) {
	var i, found=0;
	var current_div=top.document.getElementById(change_id);
	var content_length=current_div.getElementsByTagName("span")[0].innerHTML.length;

	menu_class_default();
	
	for(i=0;i<single_items.length;i++) 
		if(change_id==single_items[i]) {
		settingClass(current_div, content_length, "advanced_purple_button");
		found=1;
		}
	if(found==0) {
		//the parent button class should be kept
		var parent_id=top.document.getElementById(change_id).parentNode.parentNode.id;
		var btn_id= parent_id.replace('sub', 'bt');
		var btn_div=top.document.getElementById(btn_id);

		var words_len=btn_div.getElementsByTagName("span")[0].innerHTML.length;
		settingClass(btn_div, words_len, "advanced_white_open_button", top.region_class.white_triple, top.region_class.white_double);

		content_length=current_div.getElementsByTagName("span")[0].innerHTML.length;
		settingClass(current_div, content_length, "sub_back_purple", top.region_class.sub_triple, top.region_class.sub_double);
	}
}
