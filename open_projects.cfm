<!--- global variables --->
<cfparam name="local_userid" default=0>

<cfif isdefined("url.user_id")>
	<cfset cookie.user_id = url.user_id>
</cfif>

<cfif isdefined("cookie.user_id")>
	<cfif cookie.user_id gt 0>
		<cfset local_userid = cookie.user_id>
	</cfif>
</cfif>

<cfif isdefined("form.project_id")>
	<cfset local_projectid = form.project_id>
</cfif>

<!--- form update --->
<cfif isdefined("form.fieldnames")>
	<!--- capture form fieldnames into local ones --->
	<cfloop index="i" list="#form.fieldnames#">
		<cfset name="#lcase(i)#">
		<cfset value=evaluate(i)>
		<cfset "local_#name#" = value>
	</cfloop>
	<!--- add new project --->
	<cfquery name="add_project" datasource="scooby_doo">
		insert into project_details (name, description, originally_assigned_to, currently_assigned_to, assigned_by, priority, due_date, start_date, group_id)
		values ('#form.name#','#local_description#',#local_assigned_to#,#local_assigned_to#,#local_assigned_by#,#local_priority#,'#form.due_date#','#form.start_date#',#local_group_id#)
	</cfquery>
	<cfquery name="to" datasource="scooby_doo">
		select user_id, first, last, email
		from users
		where user_id = <cfqueryparam value=#local_assigned_to# cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	<cfquery name="sentfrom" datasource="scooby_doo">
		select user_id, first, last, email
		from users
		where user_id = <cfqueryparam value=#local_assigned_by# cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	<cfquery name="group" datasource="scooby_doo">
		select name
		from project_groups
		where group_id = <cfqueryparam value=#local_group_id# cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	<!--- send emails to help get people into using pmi --->
<Cfif to.recordcount gt 0>
<cfmail to="#to.email#" from="#sentfrom.email#" subject="Scooby Doo: #form.name# has been assigned to you.">
A new project/bug was assigned to you in Scooby Doo:

Assigned To: #to.first# #to.last#
Assigned By: #sentfrom.first# #sentfrom.last#
Title: #form.name#
Group: #group.name#
Priority: #local_priority#
---------------------------------------------------------------------#chr(10)#
#local_description#
---------------------------------------------------------------------#chr(10)#
</cfmail>
</cfif>
</cfif>
<html>
<head>
<title>Scooby Doo - Open Projects</title>
<!-- calendar stylesheet -->
<link rel="stylesheet" type="text/css" media="all" href="/jscalendar-0.9.6/calendar-win2k-cold-1.css" title="win2k-cold-1" />

<!-- main calendar program -->
<script type="text/javascript" src="/jscalendar-0.9.6/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="/jscalendar-0.9.6/lang/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
   adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="/jscalendar-0.9.6/calendar-setup.js"></script>
<style>
.shakeimage{
position:relative
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
		<font face="arial,helvetica,sans-serif,verdana" size=-1><b>Projects</b></font>
		</td>
	</tr>
	</table>
	</cfoutput>
	<br>

	<cfquery name="groups" datasource="scooby_doo">
		select a.group_id, a.name, a.description
		from project_groups as a inner join user_groups as b on a.group_id = b.group_id
		where b.user_id = <cfqueryparam value="#local_userid#" cfsqltype="CF_SQL_INTEGER">
		order by a.group_id asc
	</cfquery>

	<!--- grab user information --->
	<cfquery name="users" datasource="scooby_doo">
		select first
		from users
		where user_id = <cfqueryparam value=#local_userid# cfsqltype="CF_SQL_INTEGER">
	</cfquery>

	<!--- username listing --->
	<cfquery name="userlist" datasource="scooby_doo">
		select user_id, last + ', ' + first as fullname
		from users
		order by last asc, first asc
	</cfquery>

	<!--- query priority for priority dropdown --->
	<cfquery name="priority" datasource="scooby_doo">
		select id, name
		from priority
	</cfquery>

	<!--- grab all statuses --->
	<cfquery name="status" datasource="scooby_doo">
		select id, name
		from statuses
	</cfquery>

	<cfquery name="all_groups" datasource="scooby_doo">
		select a.group_id, a.name
		from project_groups a
		order by a.name asc
	</cfquery>

	<table width=82% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">

	<cfoutput query="groups">

		<!--- query to get list of projects --->

		<cfquery name="projects" datasource="scooby_doo">
			select a.project_id, a.name, a.priority, a.start_date, a.due_date, a.group_id, a.status
			from project_details as a
			where a.group_id = #groups.group_id#
			and a.currently_assigned_to = '#local_userid#'
			and a.status < 3
			order by a.priority asc
		</cfquery>
		<cfif projects.recordcount gt 0>
			<tr bgcolor="7A4034">
				<td colspan=1><font face="arial,helvetica,sans-serif,verdana" color="white" size=-1><b>#name#</b></font></td>
				<td colspan=3 align=left><font face="arial,helvetica,sans-serif,verdana" color="white" size=-1><b>#description#</b></font></td>
			</tr>
			<tr bgcolor="BC7F00">
				<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Priority</font></th>
				<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Name</font></th>
				<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Status</font></th>
				<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Due Date</font></th>
			</tr>
			<cfloop query="projects">
				<tr bgcolor="white" onclick="self.location.href='project_details.cfm?project_id=#projects.project_id#&user_id=#local_userid#';" onMouseOver="this.bgColor = '7A4034';this.style.color='white';this.style.cursor='hand';" onMouseOut ="this.bgColor = 'FFFFFF';this.style.color='black';" bgcolor="FFFFFF">
					<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>#projects.priority#</font></td>
					<td><font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;#projects.name#</font></td>
					<td><font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;#status.name[projects.status]#</font></td>
					<cfif projects.due_date lte now()>
						<td><font face="arial,helvetica,sans-serif,verdana" size=-1 color=red>&nbsp;#dateformat(projects.due_date,'mm/dd/yyyy')#</font></td>
					<cfelse>
						<td><font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;#dateformat(projects.due_date,'mm/dd/yyyy')#</font></td>
					</cfif>
				</tr>
			</cfloop>
		</cfif>
	</cfoutput>
	</table>

	<!--- form to add new projects --->
	<cfoutput>
		<form method=post action="open_projects.cfm?user_id=#local_userid#" name=addproject>
		<input type=hidden name=assigned_by value=#local_userid#>
		<table width=82% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
		<tr bgcolor="7A4034">
			<td colspan=2><font face="arial,helvetica,sans-serif,verdana" color="white"><b>Add new projects</b></font></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Project Area:</b></font></td>
			<td><select name=group_id size=1 style="width:200px;">
			<cfloop query="all_groups">
				<option value=#all_groups.group_id#>#all_groups.name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Assigned To:</b></font></td>
			<td><select name=assigned_to size=1 style="width:200px;">
			<option value=0>Unassigned</option>
			<cfloop query="userlist">
				<option value=#userlist.user_id#>#userlist.fullname#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Priority:</b></font></td>
			<td><select name=priority size=1 style="width:200px;">
			<cfloop query="priority">
				<cfif priority.name gt "">
					<option value=#priority.id#>#priority.id# - #priority.name#</option>
				<cfelse>
					<option value=#priority.id#>#priority.id#</option>
				</cfif>
			</cfloop>
			</select>
			</td>

		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Start Date:</b></font></td>
			<td><input type=text name=start_date size=32 value="#dateformat(now(),'mm/dd/yyyy')#"><img src="/jscalendar-0.9.6/img.gif" id="f_trigger_c" style="cursor: pointer; border: 1px solid red;" title="Date selector"
      onmouseover="this.style.background='red';" onmouseout="this.style.background=''" /></td>
		</tr>
		<script type="text/javascript">
			Calendar.setup({
				inputField     :    "start_date",     // id of the input field
				ifFormat       :    "%m/%d/%Y",      // format of the input field
				button         :    "f_trigger_c",  // trigger for the calendar (button ID)
				align          :    "Tl",           // alignment (defaults to "Bl")
				singleClick    :    true
			});
		</script>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Due Date:</b></font></td>
			<td><input type=text name=due_date size=32 value="#dateformat(now()+14,'mm/dd/yyyy')#"><img src="/jscalendar-0.9.6/img.gif" id="f_trigger_d" style="cursor: pointer; border: 1px solid red;" title="Date selector"
      onmouseover="this.style.background='red';" onmouseout="this.style.background=''" /></td>
		</tr>
		<script type="text/javascript">
			Calendar.setup({
				inputField     :    "due_date",     // id of the input field
				ifFormat       :    "%m/%d/%Y",      // format of the input field
				button         :    "f_trigger_d",  // trigger for the calendar (button ID)
				align          :    "Tl",           // alignment (defaults to "Bl")
				singleClick    :    true
			});
		</script>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Name:</b></font></td>
			<td><input type=text name=name value="" size=32><font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&nbsp;&nbsp;&nbsp;Please be concise:</font></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Description:</b></font><br><br><font face="arial,helvetica,sans-serif,verdana" size=-2 color=white>The more details we put in here, the better it will be in the long haul. </td>
			<td><textarea onkeyup="sz(this);" name=description rows=10 cols=45 nowrap></textarea></td>
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