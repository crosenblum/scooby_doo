<!--- global variables --->
<cfparam name="local_userid" default=0>
<cfparam name="local_projectid" default=0>

<cfif isdefined("url.user_id")>
	<cfset cookie.user_id = url.user_id>
</cfif>

<cfif isdefined("cookie.user_id")>
	<cfif cookie.user_id gt 0>
		<cfset local_userid = cookie.user_id>
	</cfif>
</cfif>

<cfif isdefined("url.project_id")>
	<cfset local_projectid = url.project_id>
</cfif>

<cfif isdefined("form.project_id")>
	<cfset local_projectid = form.project_id>
</cfif>

<!--- query project details for me --->
<cfquery name="project_header" datasource="scooby_doo">
	select a.project_id, a.name, a.description, a.priority, a.start_date, a.due_date, a.group_id
	from project_details as a
	where a.project_id = <cfqueryparam value=#local_projectid# cfsqltype="CF_SQL_INTEGER">
	order by a.priority asc
</cfquery>

<!--- grab user information --->
<cfquery name="users" datasource="scooby_doo">
	select first, last, email
	from users
	where user_id = <cfqueryparam value=#local_userid# cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- username listing --->
<cfquery name="userlist" datasource="scooby_doo">
	select user_id, first + ' ' + last as fullname, email
	from users
	order by last asc, first asc
</cfquery>

<!--- form update --->
<cfif isdefined("form.fieldnames")>
	<!--- capture form fieldnames into local ones --->
	<cfloop index="i" list="#form.fieldnames#">
		<cfset name="#lcase(i)#">
		<cfset value=evaluate(i)>
		<cfset "local_#name#" = value>
	</cfloop>
	<!--- send emails and then add to project notes --->
<cfmail to="#form.to#" from="#users.email#" subject="#form.subject#">
Note Sent from VCI Project Mgmt Intranet:
---------------------------------------------------------------------#chr(10)#
#form.body#
---------------------------------------------------------------------#chr(10)#
To reply, please go to http://www.scooby_doo.com/project_details.cfm?project_id=#local_projectid#
</cfmail>
	<!--- adjust body for project note --->
<cfset local_body = "
Note Sent from VCI Project Mgmt Intranet:
---------------------------------------------------------------------#chr(10)#
#form.body#
---------------------------------------------------------------------#chr(10)#
To reply, please go to http://www.scooby_doo.com/project_details.cfm?project_id=#local_projectid#
">
	<!--- add to project note --->
	<cfquery name="add_note" datasource="scooby_doo">
		insert into project_notes (subject, sent_from, body, project_id)
		values ('#form.subject#',#local_userid#,'#local_body#',#local_projectid#)
	</cfquery>
	<cflocation url="http://www.scooby_doo.com/project_details.cfm?project_id=#local_projectid#&user_id=#local_userid#" addtoken="No">
</cfif>

<html>
<head>
<title>Scooby Doo - Email Project</title>
<style>
.shakeimage{
position:relative
}
.bt3dbuttons {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 12px;
color:white;
border-color: #FFFFFF #666666 #666666 #FFFFFF;
background-color: #7A4034;
border-style: solid;
border-top-width: 1px;
border-right-width: 1px;
border-bottom-width: 1px;
border-left-width: 1px;
}

</style>
<script language="JavaScript1.2">

/*
Shake image script (onMouseover)-
© Dynamic Drive (www.dynamicdrive.com)
For full source code, usage terms, and 100's more DHTML scripts, visit http://dynamicdrive.com
*/

//configure shake degree (where larger # equals greater shake)
var rector=3

///////DONE EDITTING///////////
var stopit=0
var a=1

function init(which){
stopit=0
shake=which
shake.style.left=0
shake.style.top=0
}

function rattleimage(){
if ((!document.all&&!document.getElementById)||stopit==1)
return
if (a==1){
shake.style.top=parseInt(shake.style.top)+rector
}
else if (a==2){
shake.style.left=parseInt(shake.style.left)+rector
}
else if (a==3){
shake.style.top=parseInt(shake.style.top)-rector
}
else{
shake.style.left=parseInt(shake.style.left)-rector
}
if (a<4)
a++
else
a=1
setTimeout("rattleimage()",50)
}

function stoprattle(which){
stopit=1
which.style.left=0
which.style.top=0
}
var agt=navigator.userAgent.toLowerCase();
function sz(t) {
a = t.value.split('\n');
b=1;
for (x=0;x < a.length; x++) {
 if (a[x].length >= t.cols) b+= Math.ceil(a[x].length/t.cols);
 }
b+= a.length;
if (b > t.rows && agt.indexOf('opera') == -1) t.rows = b;
}
</script>
<SCRIPT LANGUAGE="JavaScript">
function small_window(myurl) {
var newWindow;
var props = 'scrollBars=no,resizable=no,toolbar=no,menubar=no,location=no,directories=no,width=310,height=200';
newWindow = window.open(myurl, "Add_from_Src_to_Dest", props);
}
// Adds the list of selected items selected in the child
// window to its list. It is called by child window to do so.
function addToParentList(sourceList) {
destinationList = window.document.forms[0].parentList;
for(var count = destinationList.options.length - 1; count >= 0; count--) {
destinationList.options[count] = null;
}
for(var i = 0; i < sourceList.options.length; i++) {
if (sourceList.options[i] != null)
destinationList.options[i] = new Option(sourceList.options[i].text, sourceList.options[i].value );
   }
}
// Marks all the items as selected for the submit button.
function selectList(sourceList) {
sourceList = window.document.forms[0].parentList;
for(var i = 0; i < sourceList.options.length; i++) {
if (sourceList.options[i] != null)
sourceList.options[i].selected = true;
}
return true;
}

// Deletes the selected items of supplied list.
function deleteSelectedItemsFromList(sourceList) {
var maxCnt = sourceList.options.length;
for(var i = maxCnt - 1; i >= 0; i--) {
if ((sourceList.options[i] != null) && (sourceList.options[i].selected == true)) {
sourceList.options[i] = null;
      }
   }
}
</script>

</head>
<body bgcolor="white" text="black" link=blue alink=blue vlink=blue>

<!--- menu layout --->
<table width=100% cellspacing=0 cellpadding=0 border=0>
<tr valign=top>
	<cfinclude template="incl_topnav.cfm">
	<br>


	<!--- create breadcrumbs --->
	<cfoutput>
	<table width=82% cellspacing=0 cellpadding=2 border=0>
	<tr valign=top>
		<td nowrap>
		<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Home</font></a>
		<font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&gt;&nbsp;</font>
		<a href="http://www.scooby_doo.com/open_projects.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Projects</font></a>
		<font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&gt;&nbsp;</font>
		<a href="project_details.cfm?project_id=#local_projectid#&user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>#project_header.name#</font></a>
		<font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&gt;&nbsp;</font>
		<font face="arial,helvetica,sans-serif,verdana" size=-1><b>Email Project</b></font>
		</td>
	</tr>
	</table>
	</cfoutput>
	<br>
	<!--- add note form --->
	<cfoutput>
		<form method=post action="email_project.cfm?project_id=#local_projectid#&user_id=#local_userid#" name=emailform>
		<input type=hidden name=project_id value=#local_projectid#>
		<input type=hidden name=sent_from value=#local_userid#>

		<table width=82% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>From:</b></font></td>
			<td><input type=text name=sentfrom value="#users.first#" size=32 readonly></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>To:</b></font></td>
			<td><input type=text name=to value="" size=32>&nbsp;&nbsp;&nbsp;&nbsp;<input type=button value="Address Book" onclick = "javascript:small_window('address_book.cfm?user_id=#local_userid#');">
</td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Subject/Title:</b></font></td>
			<td><input type=text name=subject value="RE: #project_header.name#" size=32></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Body:</b></font></td>
			<td><textarea onkeyup="sz(this);" name=body rows=5 cols=29 nowrap></textarea></td>
		</tr>
		<tr>
			<td colspan=2 align=center><input type=submit value="S U B M I T"></td>
		</tr>
		</table>
		<br>
		</form>
	</cfoutput>
	</td>
</tr>
</table>
</body>
</html>