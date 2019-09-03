<CFsetting showdebugoutput="No">
<!--- global variables --->
<cfparam name="local_userid" default=0>

<!--- check if logged in/has cookie --->
<cfif isdefined("cookie.user_id")>
	<cfset local_userid = cookie.user_id>
</cfif>
<cfif isdefined("url.user_id")>
	<cfcookie name="user_id" value=#url.user_id# expires="NEVER">
	<cfset cookie.user_id = url.user_id>
</cfif>

<cfif not isdefined("cookie.user_id")>
	<cflocation url="http://www.scooby_doo.com/login/index.cfm" addtoken="No">
</cfif>