<!--- username listing --->
<cfquery name="userlist" datasource="scooby_doo">
	select user_id, last + ', ' + first as fullname
	from users
	order by last asc, first asc
</cfquery>


<div style="width: 200px">
<ol style="
	height: 10em;
	overflow: auto;
	list-style-type:none;
	padding: 8px;
	margin:0;
	border: 4px ridge grey;
	" id="select">
	<cfoutput query="userlist">
	<li><label><input type="checkbox" name="assigned_to" value="#userlist.user_id#"> #userlist.fullname#</label></li>
	</cfoutput>
</ol>
</div>
<script language="javascript">
document.write('<input value="Open" type="button" onclick="javascript:document.getElementById(\'select\').style.height=\'25em\'">');
document.write('<input value="Close" type="button" onclick="javascript:document.getElementById(\'select\').style.height=\'10em\'">');
</script>