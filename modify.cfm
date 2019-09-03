<html>
<head>
<title>Address Book</title>
<!--- username listing --->
<cfquery name="userlist" datasource="scooby_doo">
	select user_id, first + ' ' + last as fullname, email
	from users
	order by last asc, first asc
</cfquery>
<SCRIPT LANGUAGE="JavaScript" SRC="OptionTransfer.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
var opt = new OptionTransfer("list1","list2");
opt.setAutoSort(true);
opt.setDelimiter(",");
opt.setStaticOptionRegex("^(Bill|Bob|Matt)$");
opt.saveRemovedLeftOptions("removedLeft");
opt.saveRemovedRightOptions("removedRight");
opt.saveAddedLeftOptions("addedLeft");
opt.saveAddedRightOptions("addedRight");
opt.saveNewLeftOptions("newLeft");
opt.saveNewRightOptions("newRight");
</SCRIPT>
</HEAD>
<BODY BGCOLOR=#FFFFFF LINK="#00615F" VLINK="#00615F" ALINK="#00615F" onLoad="opt.init(document.forms[0])">
<FORM>

<TABLE BORDER=0>
<TR>
	<TD>
	<SELECT NAME="list1" MULTIPLE SIZE=10 onDblClick="opt.transferRight()">
	<cfoutput query="userlist">
	<option value="#userlist.email#">#userlist.fullname#</option>
	</cfoutput>
	</SELECT>
	</TD>
	<TD VALIGN=MIDDLE ALIGN=CENTER>
		<INPUT TYPE="button" NAME="right" VALUE="&gt;&gt;" ONCLICK="opt.transferRight()"><BR><BR>
		<INPUT TYPE="button" NAME="right" VALUE="All &gt;&gt;" ONCLICK="opt.transferAllRight()"><BR><BR>
		<INPUT TYPE="button" NAME="left" VALUE="&lt;&lt;" ONCLICK="opt.transferLeft()"><BR><BR>
		<INPUT TYPE="button" NAME="left" VALUE="All &lt;&lt;" ONCLICK="opt.transferAllLeft()">
	</TD>
	<TD>
	<SELECT NAME="list2" MULTIPLE SIZE=10 onDblClick="opt.transferLeft()">
		<OPTION VALUE="George">George</OPTION>
		<OPTION VALUE="Fred">Fred</OPTION>
		<OPTION VALUE="Ryan">Ryan</OPTION>
		<OPTION VALUE="Angela">Angela</OPTION>
		<OPTION VALUE="Jill">Jill</OPTION>
	</SELECT>
	</TD>
</TR>
</TABLE>
These options are configurable in the source:<br>
Delimiter: <INPUT TYPE="text" NAME="delimiter" VALUE="," SIZE=2 MAXLENGTH=1 onChange="opt.setDelimiter(this.value);opt.update()"><br>
AutoSort: <SELECT NAME="autosort" onChange="opt.setAutoSort(this.selectedIndex==0?true:false);opt.update()"><OPTION VALUE="Y">Yes<OPTION VALUE="N">No</SELECT><br>
Options that Match this regular expression cannot be moved: <INPUT TYPE="text" NAME="regex" SIZE="15" VALUE="^(Bill|Bob|Matt)$" onChange="opt.setStaticOptionRegex(this.value);opt.update()">
<BR><BR>
The fields below show the status of the list boxes as items are passed back and forth. Normally these would be hidden fields which you would then use to process the changes on the server-side. Your form doesn't have to include all the fields below - you can choose to store only the items added to the right list, for example.
<BR><BR>
Removed from Left: <INPUT TYPE="text" NAME="removedLeft" VALUE="" SIZE=70><BR>
Removed from Right: <INPUT TYPE="text" NAME="removedRight" VALUE="" SIZE=70><BR>
Added to Left: <INPUT TYPE="text" NAME="addedLeft" VALUE="" SIZE=70><BR>
Added to Right: <INPUT TYPE="text" NAME="addedRight" VALUE="" SIZE=70><BR>
Left list contents: <INPUT TYPE="text" NAME="newLeft" VALUE="" SIZE=70><BR>
Right list contents: <INPUT TYPE="text" NAME="newRight" VALUE="" SIZE=70><BR>

</FORM>

</TD><TD VALIGN="TOP">
</TD></TR></TABLE>


</BODY>
</HTML>
