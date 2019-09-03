<!--- global variables --->
<cfparam name="local_userid" default=0>
<cfparam name="local_securitylevel" default="">
<cfparam name="local_sortfield" default="due_date">
<cfparam name="local_sortdirection" default="asc">
<cfparam name="local_orderby" default="order by a.due_date asc">
<cfparam name="local_sortimage" default="upsimple.png">

<Cfif isdefined("url.sortdirection")>
	<cfset local_sortdirection = url.sortdirection>
</cfif>

<cfif isdefined("url.sortfield")>
	<cfswitch expression="#url.sortfield#">
		<cfcase value="who">
			<cfset local_orderby = "order by b.last #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
		<cfcase value="what">
			<cfset local_orderby = "order by a.name #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
		<cfcase value="days_left">
			<cfset local_orderby = "order by datediff(day, getdate(), a.due_date) #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
		<cfcase value="start">
			<cfset local_orderby = "order by a.start_date #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
		<cfcase value="due_date">
			<cfset local_orderby = "order by a.due_date #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
		<cfcase value="priority">
			<cfset local_orderby = "order by a.priority #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
		<cfcase value="percentage">
			<cfset local_orderby = "order by a.percentage #local_sortdirection#">
			<cfset local_sortfield = url.sortfield>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isdefined("url.user_id")>
	<cfcookie name="user_id" value=#url.user_id# expires="#dateformat(now()+30,'mm/dd/yyyy')#">
	<cfset cookie.user_id = url.user_id>
</cfif>

<cfif isdefined("cookie.user_id")>
	<cfif cookie.user_id gt 0>
		<cfset local_userid = cookie.user_id>
	</cfif>
</cfif>


<html>
<head>
<title>Scooby Doo - Project Management Intranet</title>
<style>
.shakeimage{
position:relative
}
a.button {
font-weight: bold;
font-size: 9px;
font-family: Verdana, Arial, Helvetica, sans-serif;
padding: 4px 8px;
border-top: 1px solid white;
border-right: 1px solid black;
border-bottom: 1px solid black;
border-left: 1px solid white;
text-align: center;
min-width: 75px;
text-transform: uppercase;
}
a.button:link {
background-color: #060;
color: #FFF;
text-decoration: none;
}
a.button:visited {
background-color: #060;
color: #fff;
text-decoration: none;
}
a.button:hover {
background-color: #060;
color: red;
border-color: black white white black;
text-decoration: none;
}
a.button:active {
background-color: #369;
color: #ccc;
text-decoration: none;
}
</style>
<script language="JavaScript1.2" src="maincode.js"></script>
</head>
<body bgcolor="white" text="black" link=blue alink=blue vlink=blue>
<!--- grab user information --->
<cfquery name="users" datasource="scooby_doo">
	select first, last, securitylevel
	from users
	where user_id = <cfqueryparam value=#local_userid# cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfif users.recordcount gt 0>
	<cfset local_securitylevel = users.securitylevel>
</cfif>
<!--- username listing --->
<cfquery name="userlist" datasource="scooby_doo">
	select user_id, last + ', ' + first as fullname
	from users
	order by last asc, first asc
</cfquery>

<cfswitch expression="#local_securitylevel#">
	<cfdefaultcase>
		<!--- queries for reports --->
		<cfquery name="today_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id
			from project_details a
			where a.currently_assigned_to = <cfqueryparam value="#local_userid#" cfsqltype="CF_SQL_INTEGER">
			and datediff(day, getdate(), a.due_date) < 1
			and a.status < 2
			#local_orderby#
		</cfquery>

		<cfquery name="past_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id
			from project_details a
			where a.currently_assigned_to = <cfqueryparam value="#local_userid#" cfsqltype="CF_SQL_INTEGER">
			and a.due_date >= getdate()
			and a.status < 2
			#local_orderby#
		</cfquery>
	</cfdefaultcase>
	<cfcase value="">
		<!--- queries for reports --->
		<cfquery name="today_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id
			from project_details a
			where a.currently_assigned_to = <cfqueryparam value="#local_userid#" cfsqltype="CF_SQL_INTEGER">
			and datediff(day, getdate(), a.due_date) < 1
			and a.status < 2
			#local_orderby#
		</cfquery>

		<cfquery name="past_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id
			from project_details a
			where a.currently_assigned_to = <cfqueryparam value="#local_userid#" cfsqltype="CF_SQL_INTEGER">
			and a.due_date >= getdate()
			and a.status < 2
			#local_orderby#
		</cfquery>
	</cfcase>
	<cfcase value="Manager">
		<!--- queries for reports --->
		<cfquery name="today_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id, b.first, b.last
			from users b inner join project_details a on b.user_id=a.originally_assigned_to
			where datediff(day, getdate(), a.due_date) < 1
			and a.status < 2
			#local_orderby#
		</cfquery>

		<cfquery name="past_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id, b.first, b.last
			from users b inner join project_details a on b.user_id=a.originally_assigned_to
			where a.due_date >= getdate()
			and a.status < 2
			#local_orderby#
		</cfquery>
	</cfcase>
	<cfcase value="Administrator">
		<!--- queries for reports --->
		<cfquery name="today_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id, b.first, b.last
			from users b inner join project_details a on b.user_id=a.originally_assigned_to
			where datediff(day, getdate(), a.due_date) < 1
			and a.status < 2
			#local_orderby#
		</cfquery>

		<cfquery name="past_due" datasource="scooby_doo">
			select a.project_id, a.name,a.currently_assigned_to, a.priority, a.percentage, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id, b.first, b.last
			from users b inner join project_details a on b.user_id=a.originally_assigned_to
			where a.due_date >= getdate()
			and a.status < 2
			#local_orderby#
		</cfquery>
	</cfcase>
</cfswitch>

<!--- menu layout --->
<table width=100% cellspacing=0 cellpadding=0 border=0>
<tr valign=top>

	<cfinclude template="incl_topnav.cfm">
	<br>

	<table width=82% cellspacing=0 cellpadding=3 border=0>
	<cfinclude template="mod_todays_projects.cfm">
	<cfinclude template="mod_past_due_projects.cfm">
	</table>

	</td>
</tr>
</table>
</body>
</html>