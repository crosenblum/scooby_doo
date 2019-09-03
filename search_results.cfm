<!--- global variables --->
<cfparam name="local_userid" default=0>
<cfparam name="local_filter" default="new">
<cfparam name="local_currentpage" default=1>

<cfif isdefined("url.user_id")>
	<cfset cookie.user_id = url.user_id>
</cfif>

<cfif isdefined("form.filter")>
	<cfset local_filter = form.filter>
</cfif>

<cfif isdefined("cookie.user_id")>
	<cfif cookie.user_id gt 0>
		<cfset local_userid = cookie.user_id>
	</cfif>
</cfif>

<cfif isdefined("form.project_id")>
	<cfset local_projectid = form.project_id>
</cfif>

<html>
<head>
<title>Scooby Doo - Search Results</title>
<!-- calendar stylesheet -->
<link rel="stylesheet" type="text/css" media="all" href="/jscalendar-0.9.6/calendar-win2k-cold-1.css" title="win2k-cold-1" />

<!-- main calendar program -->
<script type="text/javascript" src="/jscalendar-0.9.6/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="/jscalendar-0.9.6/lang/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
   adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="/jscalendar-0.9.6/calendar-setup.js"></script>
<script language="JavaScript1.2" src="maincode.js"></script>

<style>
.shakeimage{
position:relative
}
</style>
</head>
<body bgcolor="white" text="black" link=blue alink=blue vlink=blue>

<!--- menu layout --->
<table width=100% cellspacing=0 cellpadding=0 border=0>
<tr valign=top>
	<cfinclude template="incl_topnav.cfm">
	<br>
	<!--- create breadcrumbs --->
	<cfoutput>
	<form method=post action="search_results.cfm?user_id=#local_userid#">
	<table width=500 cellspacing=0 cellpadding=2 border=0>
	<tr valign=top>
		<td nowrap>
		<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Home</font></a>
		<font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&gt;&nbsp;</font>
		<font face="arial,helvetica,sans-serif,verdana" size=-1><b>Search Results</b></font>
		</td>
		<td align=right><font face="arial,helvetica,sans-serif,verdana" size=-1><b>Search: </b></font><INPUT type="text" name="filter" size=10 value="#local_filter#"><input type=submit value="Go"></td>
	</tr>
	</table>
	</form>
	</cfoutput>
	<br>

	<!--- username listing --->
	<cfquery name="userlist" datasource="scooby_doo">
		select user_id, first + ' ' + last as fullname
		from users
		order by last asc, first asc
	</cfquery>

	<!--- query to look up search results --->
	<cfquery name="search" datasource="scooby_doo">
		Select a.project_id, a.name, a.description, a.currently_assigned_to, a.percentage, a.start_date, a.due_date, a.completed_date,a.group_id, b.rank
		from project_details a inner join freetexttable(project_details, *, '#local_filter#',80) as b on b.[key] = a.project_id
		order by b.rank desc
	</cfquery>

	<cfif search.recordcount gt 0>
		<!--- display pagethru --->
		<cf_pagethru totalrecords="#search.recordcount#" currentpage="#local_currentpage#" templateurl="#cgi.script_name#" addedpath="&filter=#local_filter#" displaycount="50" pagegroup="15" imagepath="none" hilightcolor="00ff00" previousstr="[prev]" nextstr="[next]" previousgroupstr="[rew]" nextgroupstr="[ff]">

		<cfoutput>
			<table width="500" cellpadding="0" cellspacing="0" border="0">
			<tr bgcolor="999999">
				<td colspan="2"><img src="/images/spacer.gif" width="1" height="1" border="0"></td>
			</tr>
			<tr>
				<td><font face="Arial, Helvetica, sans-serif" size="2"><b>Displaying #PT_StartRow# - #PT_EndRow# of #search.recordcount#</b></font></td>
				<td align="right"><font face="Arial, Helvetica, sans-serif" size="2">#pt_pagethru#</font></td>
			</tr>
			<tr bgcolor="999999">
				<td colspan="2"><img src="/images/spacer.gif" width="1" height="1" border="0"></td>
			</tr>
			</table>
		</cfoutput>
		<br>
		<!--- display results --->
		<cfoutput query="search">
		<table width=500 cellspacing=0 cellpadding=2 border=1 bordercolor="BC7F00">
			<cfset local_proddesc = "#left(search.description,200)#...">
			<tr valign=top bgcolor="BC7F00">
				<td align=left><a href="project_details.cfm?user_id=#local_userid#&project_id=#search.project_id#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>#search.name#</font></a></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>
				<cfloop query="userlist">
					<cfif listlen(search.currently_assigned_to) gt 1>
						<cfif listcontains(search.currently_assigned_to,userlist.user_id)>
							#userlist.fullname#
						</cfif>
					<cfelse>
						<cfif userlist.user_id eq search.currently_assigned_to>
							#userlist.fullname#
						</cfif>
					</cfif>
				</cfloop>
				</select>
				</td>
				<td align=right><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>#search.rank# %</font></td>
			</tr>
			<tr>
				<td colspan=3><font face="arial,helvetica,sans-serif,verdana" size=-1>#local_proddesc#</font><br><br>
				<table width=82% cellspacing=0 cellpadding=2 border=0>
				<tr valign=top>
					<td nowrap colspan=3>
					<font face="arial, helvetica, verdna" size=-1 color=6F6F6F>
					&raquo;Found in  <img src='/images/nav_arrow_tran.gif' width='20' height='7' border='0'>
					</font>
					<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Home</font></a>
					<img src='/images/nav_arrow_tran.gif' width='20' height='7' border='0'>
					<cfif search.group_id eq 1>
						<a href="http://www.scooby_doo.com/open_projects.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Bug Tracking</font></a>
					<cfelse>
						<a href="http://www.scooby_doo.com/open_projects.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Projects</font></a>
					</cfif>
					<img src='/images/nav_arrow_tran.gif' width='20' height='7' border='0'>
					<font face="arial,helvetica,sans-serif,verdana" size=-1><b>#search.name#</b></font>
					</td>
				</tr>
				</table>
				</td>
			</tr>
			</table>
			<br>
			</cfoutput>
		<cfelse>
			<font face="Arial, Helvetica, sans-serif" size="+1" color="003366">
			<b>The search for <font color=red><cfoutput>#local_filter#</cfoutput></font> found no matches.</b>
			</font>
			<br><Br>
			<font face="Verdana, Arial, Helvetica, sans-serif" color="#336699">
			<b>Search Tips</b>
			</font>
			<br><Br>
			<font face="Verdana, Arial, Helvetica, sans-serif" size="-1"><b>
			Choose Words Carefully</b><br>
			Use specific words to describe exactly what you&#146;re looking for.<br> More
			general terms will give a larger number of results, so try to narrow your
			search.</font>
			<br><Br>
		</cfif>
	</td>
</tr>
</table>
</body>
</html>