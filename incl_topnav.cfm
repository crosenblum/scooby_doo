<td width=200><img src="/images/scooby04.jpg" border=0 width=278 height=182 alt="Scooby Doo Menu Header">
<iframe name="yourName" src="http://www.scooby_doo.com/dirbrowse/index.cfm" frameborder=0 border=0 scrolling=auto width=278 height=254></iframe>
<!--- music introduction --->
<cfinclude template="mod_music_player.cfm">
</td>
<td>
<table width=500 cellspacing=0 cellpadding=3 border=0>
<cfoutput>
	<tr>
		<td><a href="index.cfm?user_id=#local_userid#"><img src="/images/home.gif" border=0 width=77 height=46 class="shakeimage" onMouseover="init(this);rattleimage()" onMouseout="stoprattle(this);top.focus()" onClick="top.focus()"></a></td>
		<td><a href="open_projects.cfm?user_id=#local_userid#"><img src="/images/projects.gif" border=0 width=77 height=46 class="shakeimage" onMouseover="init(this);rattleimage()" onMouseout="stoprattle(this);top.focus()" onClick="top.focus()"></a></td>
		<td><a href="bug_tracking.cfm?user_id=#local_userid#"><img src="/images/bugs.gif" border=0 width=77 height=46 class="shakeimage" onMouseover="init(this);rattleimage()" onMouseout="stoprattle(this);top.focus()" onClick="top.focus()"></a></td>
		<td><a href="search_results.cfm?user_id=#local_userid#"><img src="/images/search.gif" border=0 width=77 height=46 class="shakeimage" onMouseover="init(this);rattleimage()" onMouseout="stoprattle(this);top.focus()" onClick="top.focus()"></a></td>
		<!---
		<td><a href="admin.cfm?user_id=#local_userid#"><img src="/images/admin.gif" border=0 width=77 height=46 class="shakeimage" onMouseover="init(this);rattleimage()" onMouseout="stoprattle(this);top.focus()" onClick="top.focus()"></a></td>
		--->
	</tr>
</cfoutput>
</table>
