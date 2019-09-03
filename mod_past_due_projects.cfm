<!--- projects past due --->
<Cfif past_due.recordcount gt 0>
	<cfif local_orderby contains "asc">
		<cfset local_sortdirection = "desc">
	<cfelse>
		<cfset local_sortdirection = "asc">
	</cfif>
	<!--- capture url used sorting modes --->
	<cfif isdefined("local_sortdirection")>
		<cfif local_sortdirection eq "asc">
			<cfset local_sortimage = "upsimple.png">
		<cfelseif local_sortdirection eq "desc">
			<cfset local_sortimage = "downsimple.png">
		</cfif>
	</cfif>
	<tr>
		<td>
		<table width=100% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
		<tr bgcolor="BC7F00">
			<td colspan=6><font face="arial,helvetica,sans-serif,verdana" size=+1>Open Projects</font></td>
		</tr>
		<tr bgcolor="B14030">
		<cfoutput>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Who</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=who&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=who&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			</th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>What</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=what&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=what&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			</th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Days Left</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=days_left&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=days_left&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			<!---
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Start</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=start&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=start&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			</th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Due</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=due_date&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=due_date&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			</th>
			--->
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>Priority</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=priority&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=priority&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			</th>
			<th><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>% Complete</font>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=percentage&sortdirection=desc"><img src="/images/downsimple.png" border=0 width=8 height=7 alt="Sort Descending"></a>
			&nbsp;<a href="http://www.scooby_doo.com/index.cfm?user_id=#local_userid#&sortfield=percentage&sortdirection=asc"><img src="/images/upsimple.png" border=0 width=8 height=7 alt="Sort Ascending"></a>
			</th>
		</cfoutput>
		</tr>
		<cfoutput query="past_due">
			<tr bgcolor="white" onclick="self.location.href='project_details.cfm?project_id=#past_due.project_id#&user_id=#local_userid#';" onMouseOver="this.bgColor = '7A4034';this.style.color='white';this.style.cursor='hand';" onMouseOut ="this.bgColor = 'FFFFFF';this.style.color='black';" bgcolor="FFFFFF">
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#first# #last#</font></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#name#</font></td>
				<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>#days_left#</font></td>
				<!---
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#dateformat(start_date,'mm/dd/yyyy')#</font></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#dateformat(due_date,'mm/dd/yyyy')#</font></td>
				--->
				<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>#priority#</font></td>
				<td align=center><font face="arial,helvetica,sans-serif,verdana" size=-1>#percentage#</font></td>
			</tr>
		</cfoutput>
		</table>
		</td>
	</tr>
<cfelse>
	<tr>
		<td><font face="arial,helvetica,sans-serif,verdana" size=-1>No projects, currently past due!</font><br><br></td>
	</tr>
</cfif>
