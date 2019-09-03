<!--- global variables --->
<cfparam name="local_userid" default=0>
<cfparam name="local_projectid" default=0>
<cfparam name="local_fileupload" default="No">

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

<!--- if delete note --->
<cfif isdefined("url.delete_note") and isdefined("url.project_id")>
	<cfquery name="delete_note" datasource="scooby_doo">
		delete
		from project_notes
		where notes_id = <cfqueryparam value="#url.delete_note#" cfsqltype="CF_SQL_INTEGER">
		and sent_from = <cfqueryparam value="#local_userid#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
</cfif>

<!--- form update --->
<cfif isdefined("form.fieldnames")>
	<!--- capture form fieldnames into local ones --->
	<cfloop index="i" list="#form.fieldnames#">
		<cfset name="#lcase(i)#">
		<cfset value=evaluate(i)>
		<cfset "local_#name#" = value>
	</cfloop>
	<cfif isdefined("form.mode")>
		<cfswitch expression="#form.mode#">
			<cfcase value="update">
				<!--- update project header --->
				<cfquery name="update_projs" datasource="scooby_doo">
					update project_details
					set priority = #local_priority#,
					due_date = '#local_duedate#',
					description = '#local_description#',
					currently_assigned_to = '#local_assigned_to#',
					status = #local_status#,
					<cfif local_status eq 4>
					completed_date = getdate(),
					</cfif>
					percentage = #local_percentage#
					where project_id = #local_project_id#
				</cfquery>
			</cfcase>
			<cfcase value="add">
				<!--- check if fileupload or not --->
				<cfif isdefined("form.filename")>
					<cfif form.filename gt "">
						<cfset local_fileupload = "Yes">
					</cfif>
				</cfif>
				<!--- add project note --->
				<Cfif local_fileupload eq "Yes">
					<!--- handle file uploading --->
					<cffile action="upload" filefield="form.filename" destination="d:\websites\scooby_doo\attachments\"nameConflict = "MakeUnique">
					<!--- once uploaded rename to help link to project id --->
					<cffile action = "rename"  source = "d:\websites\scooby_doo\attachments\#form.filename#"    destination = "d:\websites\scooby_doo\attachments\#form.project_id#_#form.filename#">
					<!--- reset filename used --->
					<cfset local_filename = "#form.project_id#_#form.filename#">

					<cfquery name="add_note" datasource="scooby_doo">
						insert into project_notes (subject, sent_from, body, attachment, project_id)
						values ('#local_subject#',#local_userid#,'#local_body#','#local_filename#',#local_projectid#)
					</cfquery>
				<cfelse>
					<cfquery name="add_note" datasource="scooby_doo">
						insert into project_notes (subject, sent_from, body, project_id)
						values ('#local_subject#',#local_userid#,'#local_body#',#local_projectid#)
					</cfquery>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
</cfif>

<html>
<head>
<title>Scooby Doo - Project Details</title>
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
<script language="JavaScript1.2" src="maincode.js"></script>
</head>
<body bgcolor="white" text="black" link=blue alink=blue vlink=blue>

<!--- menu layout --->
<table width=100% cellspacing=0 cellpadding=0 border=0>
<tr valign=top>
	<cfinclude template="incl_topnav.cfm">
	<br>

	<!--- query project details for me --->
	<cfquery name="project_header" datasource="scooby_doo">
		select a.project_id, a.name, a.description, a.currently_assigned_to, a.priority, a.percentage, a.status, a.start_date, a.due_date, a.group_id
		from project_details as a
		where a.project_id = <cfqueryparam value=#local_projectid# cfsqltype="CF_SQL_INTEGER">
		order by a.priority asc
	</cfquery>

	<!--- grab notes for this project --->
	<cfquery name="project_notes" datasource="scooby_doo">
		select a.notes_id, a.subject, a.sent_from, a.body, a.attachment, a.create_date, a.last_updated, a.project_id, b.first
		from project_notes a inner join users b on b.user_id = a.sent_from
		where a.project_id = <cfqueryparam value=#local_projectid# cfsqltype="CF_SQL_INTEGER">
		order by a.create_date desc
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

	<!--- grab user information --->
	<cfquery name="users" datasource="scooby_doo">
		select first
		from users
		where user_id = <cfqueryparam value=#local_userid# cfsqltype="CF_SQL_INTEGER">
	</cfquery>

	<!--- username listing --->
	<cfquery name="userlist" datasource="scooby_doo">
		select user_id, first + ' ' + last as fullname
		from users
		order by last asc, first asc
	</cfquery>

	<!--- create breadcrumbs --->
	<cfoutput>
	<table width=82% cellspacing=0 cellpadding=2 border=0>
	<tr valign=top>
		<td nowrap>
		<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Home</font></a>
		<font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&gt;&nbsp;</font>
		<cfif project_header.group_id eq 1>
			<a href="http://www.scooby_doo.com/open_projects.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Bug Tracking</font></a>
		<cfelse>
			<a href="http://www.scooby_doo.com/open_projects.cfm?user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Projects</font></a>
		</cfif>
		<font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;&gt;&nbsp;</font>
		<font face="arial,helvetica,sans-serif,verdana" size=-1><b>#project_header.name#</b></font>
		</td>
		<td align=right><a href="email_project.cfm?project_id=#local_projectid#&user_id=#local_userid#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Email Project</font></a></td>
	</tr>
	</table>
	</cfoutput>
	<br>
	<!--- display current project details as toolbar --->
	<table width=82% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
	<tr valign=top bgcolor="BC7F00">
		<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Priority</font></th>
		<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Assigned To</font></th>
		<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Status</font></th>
		<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>% Complete</font></th>
		<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Due Date</font></th>
		<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Action</font></th>
	</tr>
	<cfoutput>
		<!--- calculate number of rows for textarea --->
		<cfset my_rows = decimalformat(len(project_header.description)/80) + 2>

		<form method=post action="project_details.cfm?project_id=#local_projectid#&user_id=#local_userid#" name=update1>
		<input type=hidden name=mode value="update">
		<input type=hidden name=project_id value=#local_projectid#>
		<tr>
			<td>&nbsp;<select name=priority size=1>
			<cfloop query="priority">
			<cfif project_header.priority eq priority.id>
				<cfif priority.name gt "">
					<option selected value=#priority.id#>#priority.id# - #priority.name#</option>
				<cfelse>
					<option selected value=#priority.id#>#priority.id#</option>
				</cfif>
			<cfelse>
				<cfif priority.name gt "">
					<option value=#priority.id#>#priority.id# - #priority.name#</option>
				<cfelse>
					<option value=#priority.id#>#priority.id#</option>
				</cfif>
			</cfif>
			</cfloop>
			</select>
			</td>
			<td><Cfset userlen = listlen(project_header.currently_assigned_to)><select size=#userlist.recordcount# name=assigned_to multiple>
			<cfloop query="userlist">
				<cfif userlen gt 1>
					<cfif listcontains(project_header.currently_assigned_to,userlist.user_id)>
						<option selected value=#userlist.user_id#>#userlist.fullname#</option>
					<cfelse>
						<option value=#userlist.user_id#>#userlist.fullname#</option>
					</cfif>
				<cfelse>
					<cfif userlist.user_id eq project_header.currently_assigned_to>
						<option selected value=#userlist.user_id#>#userlist.fullname#</option>
					<cfelse>
						<option value=#userlist.user_id#>#userlist.fullname#</option>
					</cfif>
				</cfif>
			</cfloop>
			</select>
			</td>
			<td><select name=status size=1>
			<cfloop query="status">
				<cfif status.id eq project_header.status>
					<option selected value=#status.id#>#status.name#</option>
				<cfelse>
					<option value=#status.id#>#status.name#</option>
				</cfif>
			</cfloop>
			</select></td>
			<td>&nbsp;<input type=text name=percentage size=2 value="#project_header.percentage#"><font face="arial,helvetica,sans-serif,verdana" size=-1>%</font></td>
			<td>&nbsp;<input type=text name=duedate size=10 value="#dateformat(project_header.due_date,'mm/dd/yyyy')#"></td>
			<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>[</font><A HREF="javascript:document.update1.submit()"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>Update</font></a><font face="arial,helvetica,sans-serif,verdana" size=-1>]</font></td>
		</tr>
		<tr>
			<td colspan=6><textarea onkeyup="sz(this);" name=description rows=#my_rows# cols=69 nowrap>#project_header.description#</textarea></td>
		</tr>
		</form>
	</cfoutput>
	</table>
	<!--- check if any notes for this project --->
	<cfif project_notes.recordcount lt 1>
		<font face="arial,helvetica,sans-serif,verdana" size=-1><b>No notes yet, feel free to add notes of what was done each day on this project.</b></font>
		<br><br>
	<cfelse>
		<br>
		<!--- display notes --->
		<table width=82% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
		<tr valign=top bgcolor="BC7F00">
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>From</font></th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Subject</font></th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Create Date</font></th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Last Updated</font></th>
		</tr>
		<cfoutput query="project_notes">

			<!--- calculate number of rows for textarea --->
			<cfset my_rows = decimalformat(len(project_notes.body)/80) + 2>

			<tr bordercolor="7A4034">
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;#project_notes.first#</font></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>&nbsp;#project_notes.subject#</font></td>
				<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>#dateformat(project_notes.create_date,'mm/dd/yyyy')# #timeformat(project_notes.create_date,'hh:mm:ss tt')#</font></td>
				<cfif project_notes.last_updated gt "">
					<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>#dateformat(project_notes.last_updated,'mm/dd/yyyy')#</font></td>
				<cfelse>
					<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>Not Updated</font></td>
				</cfif>
			</tr>
			<tr>
				<td colspan=4><textarea onkeyup="sz(this);" name=body rows=#my_rows# cols=69 nowrap style="overflow:auto;">#project_notes.body#</textarea></td>
			</tr>
			<cfif project_notes.attachment gt "">
				<tr>
					<td colspan=2 bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1>Attachment:</font></td>
					<td colspan=2><a href="http://www.scooby_doo.com/attachments/#project_notes.attachment#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=blue>#project_notes.attachment#</font></td>
				</tr>
			</cfif>
			<tr valign=top bgcolor="BC7F00" bordercolor="BC7F00">
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<Cfif project_notes.sent_from eq local_userid>
					<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>[</b></font><a href="project_details.cfm?project_id=#local_projectid#&user_id=#local_userid#&delete_note=#project_notes.notes_id#"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Delete</b></font></a><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>]</b></font></td>
				<cfelse>
					<td>&nbsp;</td>
				</cfif>
			</tr>
		</cfoutput>

		</table>
	</cfif>
	<!--- add note form --->
	<cfoutput>
		<form method=post action="project_details.cfm?project_id=#local_projectid#&user_id=#local_userid#" enctype="multipart/form-data" name=addnote>
		<input type=hidden name=mode value="add">
		<input type=hidden name=project_id value=#local_projectid#>
		<input type=hidden name=sent_from value=#local_userid#>

		<table width=82% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>From:</b></font></td>
			<td><input type=text name=sentfrom value="#users.first#" size=32 readonly></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Subject/Title:</b></font></td>
			<td><input type=text name=subject value="" size=32></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>Body:</b></font></td>
			<td><textarea onkeyup="sz(this);" name=body rows=5 cols=29 nowrap></textarea></td>
		</tr>
		<tr valign=top>
			<td bgcolor="BC7F00"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white><b>File Attachment:</b></font></td>
			<td><input type=file name=filename size=32></td>
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