<cfscript>
/**
 * Returns extension defined by all characters following last period.
 * v2 by Ray Camden
 *
 * @param name 	 File name to use. (Required)
 * @return Returns a string.
 * @author Alexander Sicular (as867@columbia.edu)
 * @version 2, May 9, 2003
 */
function getExtension(name) {
    if(find(".",name)) return listLast(name,".");
    else return "";
}
</cfscript>

<table width=100% cellspacing=0 cellpadding=2 border=1 bordercolor="7A4034">
<tr valign=top bgcolor="BC7F00">
	<td width="2%"><font face="Verdana"><b><font face="Verdana, Arial, Helvetica, sans-serif" size=-1 color=white>Type</font></b></font></td>
	<td width="16%"><font face="Arial, Helvetica, sans-serif" size=-1 color=white><b>Name</b></font></td>
</tr>

<cfoutput query="myList">
	<cfif name NEQ "." AND name NEQ ".." AND name NEQ "index.cfm" and name neq "application.cfm" and name neq "vssver.scc">
		<tr>
			<!--- display icon instead of text --->
			<cfset local_ext = lcase(getExtension(name))>
			<cfif type eq "Dir">
				<cfset local_ext = "Dir">
			</cfif>
			<td width="6%" align=center>
			<cfswitch expression="#local_ext#">
				<cfcase value="Dir">
					<img src="../icons/closed_folder.ico" border=0 height=16 alt="Directory">
				</cfcase>
				<cfcase value="exe">
					<img src="../icons/ms_dos_application.ico" border=0 height=16 alt="Application">
				</cfcase>
				<cfcase value="cfm">
					<img src="../icons/internet_document.ico" border=0 height=16 alt="ColdFusion File">
				</cfcase>
				<cfcase value="doc">
					<img src="../icons/write_document.ico" border=0 height=16 alt="Word Document">
				</cfcase>
				<cfcase value="htm">
					<img src="../icons/internet_document.ico" border=0 height=16 alt="HTML File">
				</cfcase>
				<cfcase value="html">
					<img src="../icons/internet_document.ico" border=0 height=16 alt="HTML File">
				</cfcase>
				<cfcase value="txt">
					<img src="../icons/text_document.ico" border=0 height=16 alt="Text File">
				</cfcase>
				<cfcase value="bmp">
					<img src="../icons/bitmap_image.ico" border=0 height=16 alt="BMP File">
				</cfcase>
				<cfcase value="gif">
					<img src="../icons/gif_image.ico" border=0 height=16 alt="GIF Image">
				</cfcase>
				<cfcase value="jpg">
					<img src="../icons/jpeg_image.ico" border=0 height=16 alt="JPEG Image">
				</cfcase>
				<cfcase value="pdf">
					<img src="../icons/rich_text_format.ico" border=0 height=16 alt="PDF Document">
				</cfcase>
				<cfcase value="ppt">
					<img src="../icons/rich_text_format.ico" border=0 height=16 alt="PowerPoint Document">
				</cfcase>
				<cfcase value="url">
					<img src="../icons/url_history.ico" border=0 height=16 alt="URL">
				</cfcase>
				<cfcase value="zip">
					<img src="../icons/zip_file.ico" border=0 height=16 alt="Zip File">
				</cfcase>
				<cfdefaultcase>
					<font face="Verdana" color="000066" size="-1"><b>#local_ext#</b></font>
				</cfdefaultcase>
			</cfswitch>
			</td>
			<!--- browse as a file or as a directory --->
			<cfif type eq "Dir">
				<td width="200"><a href="index.cfm?directorypath=#url.directorypath##name#\"><font face="Verdana" color="000066" size="-1"><b>#name#</b></font></a></td>
			<cfelse>
				<td style="width:200px;overflow:hidden;clip:auto;"><a href="#myserver##new_uncpath##name#" target="_new"><font face="Verdana" color="000066" size="-1"><b>#name#</b></font></a></td>
			</cfif>
		</tr>
	</cfif>
</cfoutput>
