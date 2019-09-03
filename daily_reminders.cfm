<!--- username listing --->
<cfquery name="userlist" datasource="scooby_doo">
	select user_id, last + ', ' + first as fullname, email
	from users
	where user_id = 1
	order by last asc, first asc
</cfquery>

<cfloop query="userlist">

<cfquery name="projects" datasource="scooby_doo">
	select a.project_id, a.name, a.priority, a.start_date, a.due_date, datediff(day, getdate(), a.due_date) as days_left, a.group_id, a.status
	from project_details as a
	where a.currently_assigned_to = '#userlist.user_id#'
	and a.status < 3
	order by a.priority asc
</cfquery>


	<!--- send emails and then add to project notes --->
<cfmail to="#userlist.email#" from="#users.email#" subject="#form.subject#">
Daily Reminder to Update Project Notes:
---------------------------------------------------------------------#chr(10)#
<cfoutput query="projects">
Project: #name##chr(9)#Due Date:#dateformat(due_date,'mm/dd/yyyy')# Days Until Due: #days_left##chr(10)#
</cfoutput>
---------------------------------------------------------------------#chr(10)#
Please go to scooby, and make sure you've documented all changes/work done on each project.
</cfmail>

</cfloop>