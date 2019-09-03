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

<cfdirectory action="list" directory="d:\websites\scooby_doo\music\" filter="*.wav" sort="name" name=music>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
songNum = new Array();
songNum[0] = "#";
<cfoutput query="music">
songNum[#music.currentrow#] = "http://www.scooby_doo.com/music/#music.name#";
</cfoutput>


var music = null;
var track = 0;
var ver = navigator.appName;
function audioCheck(plugName) {
for (var i = 0; i < navigator.plugins.length; i++) {
if (navigator.plugins[i].name.toLowerCase() == plugName.toLowerCase()) {
for (var j = 0; j < navigator.plugins[i].length; j++) {
if (navigator.plugins[i][j].enabledPlugin) {
return true;
   }
}
return false;
   }
}
return false;
}
function chooseSong(s) { // ie
track = s.options[s.selectedIndex].value;
if (ver == "Microsoft Internet Explorer") {
document.all.music.src = songNum[track];
} else {
songPlay('play');
   }
}
function songPlay(cmd) { // netscape
if (audioCheck("LiveAudio")) {
if (cmd == 'play') {
document.musicSource.play(false, songNum[track]);
   }
} else {
alert("You Do Not Have The Correct Plugin");
   }
}
//  End -->
</script>

<center>
<form name=choose>
<select size=1 name=track onChange="chooseSong(this);" style="width:220px;">
<option value="0">Select Tune.Or Stop Music</option>
<cfoutput query="music">
<cfset ext = getExtension(music.name)>
<cfset song = left(music.name,len(music.name)-len(ext)-1)>
<option value="#music.currentrow#">#song#</option>
</cfoutput>
</select>
</form>

<script language="JavaScript">
<!-- Begin
var ver = navigator.appName;
if (ver == "Microsoft Internet Explorer") {
document.write('<bgsound src="#" ID=music loop=1 AUTOSTART=FALSE>');
} else {
document.write('<embed type="audio/midi" src="http://www.broadwaymidi.com/down/Camelot-Camelot.mid" AUTOSTART=false hidden=true VOLUME="90" name="musicSource" MASTERSOUND></EMBED>');
}
// End -->
</script>
</center>