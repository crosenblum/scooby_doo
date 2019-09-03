<html>
<head>
<title>Address Book</title>
<!--- username listing --->
<cfquery name="userlist" datasource="scooby_doo">
	select user_id, first + ' ' + last as fullname, email
	from users
	order by last asc, first asc
</cfquery>
<SCRIPT LANGUAGE="JavaScript" SRC="../OptionTransfer.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	var opt = new OptionTransfer("list1","list2");
	opt.setAutoSort(true);
	opt.setDelimiter(";");
	opt.saveNewRightOptions("newRight");
	function sendhome() {
		opener.document.emailform.to.value = document.myform.newRight.value;
		window.close();
		return false;

	}

</script>
</head>
<body leftmargin=0 topmargin=0 bgcolor=ffffff link="00615f" vlink="00615f" alink="00615f" onload="opt.init(document.forms[0])">

<form name=myform>
<INPUT TYPE="hidden" NAME="newRight" VALUE="" SIZE=10>
<table bgcolor="BC7F00" cellspacing=0 cellpadding=4 border=0 width=82%>
<tr bgcolor="7A4034">
	<td width="74"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>&nbsp;Addresses:</font></td>
	<td> </td>
	<td width="69"><font face="arial,helvetica,sans-serif,verdana" size=-1 color=white>To:</font></td>
</tr>
<TR>
	<TD>
	<SELECT NAME="list1" MULTIPLE SIZE=10 onDblClick="opt.transferRight()">
	<cfoutput query="userlist">
	<option value="#userlist.fullname# <#userlist.email#>">#userlist.fullname#</option>
	</cfoutput>
	</SELECT>
	</TD>
	<TD VALIGN=MIDDLE ALIGN=CENTER>
	<INPUT TYPE="button" NAME="right" VALUE="&gt;&gt;" ONCLICK="opt.transferRight()"><BR><BR>
	<INPUT TYPE="button" NAME="left" VALUE="&lt;&lt;" ONCLICK="opt.transferLeft()"><BR><BR>
	<input type="button" name="done" value="Done" onclick="sendhome();"><br><br>
	</TD>
	<TD>
	<SELECT NAME="list2" MULTIPLE SIZE=10 onDblClick="opt.transferLeft()">
	</SELECT>
	</TD>
</TR>
</TABLE>

</FORM>


</BODY>
</HTML>
