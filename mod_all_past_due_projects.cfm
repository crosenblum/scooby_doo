<!--- projects past due --->
<Cfif past_due.recordcount gt 0>
	<tr>
		<td>
		<table width=100% cellspacing=0 cellpadding=2 border=1>
		<tr bgcolor="BC7F00">
			<td colspan=4><font face="arial,helvetica,sans-serif,verdana" size=+1>Open Projects</font></td>
		</tr>
		<cfoutput query="past_due">
			<tr bgcolor="white" onclick="self.location.href='project_details.cfm?project_id=#past_due.project_id#&user_id=#local_userid#';" onMouseOver="this.bgColor = '7A4034';this.style.color='white';this.style.cursor='hand';" onMouseOut ="this.bgColor = 'FFFFFF';this.style.color='black';" bgcolor="FFFFFF">
				<td valign=middle><font face="arial,helvetica,sans-serif,verdana" size=+1><b>&nbsp;&middot;&nbsp;</b></font></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#dateformat(due_date,'mm/dd/yyyy')#</font></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#first# #last#</font></td>
				<td><font face="arial,helvetica,sans-serif,verdana" size=-1>#name#</font></td>
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
