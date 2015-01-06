<!--#include file="../Scripts/includes.asp"-->
<% Response.Charset="UTF-8" %>
<% 'Session("AccessGranted")=false %>
<% IF NOT Session("AccessGranted") THEN %>
<% SELECT CASE UCASE(request.querystring("output"))
CASE "JSON" %>
{
success: false,
message: "ES NECESARIO INICIAR SESIÓN",
callback: function(config){
		var login = Ext.create(Ext.ClassManager.getNameByAlias("widget.login"));
		if (config.onSuccess) login.onSuccess=config.onSuccess;
		login.show();
	}
}
<% CASE "EXTJS" %>
Ext.Msg.alert("Sesión caducada", "La sesión caducó y es necesario iniciar sesión de nuevo");
<% CASE ELSE %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Sistema</title>
    <link rel="stylesheet" type="text/css" href="../../../../resources/extjs/extjs-current/resources/css/ext-all.css"/>
	<link rel="stylesheet" type="text/css" href="../styles/layout-browser.css"/>
	<link rel="stylesheet" type="text/css" href="../custom/styles/custom.css" />
	<link rel="stylesheet" type="text/css" href="../custom/styles/login.css" />
	<link rel="stylesheet" type="text/css" href="../styles/styles.css" />

	<!-- <script type="text/javascript" src="../../../../resources/extjs/extjs-current/ext-debug.js"></script> -->
    <!-- <script type="text/javascript" src="../app/all-classes.js"></script> -->
	<script type="text/javascript" src="../../../../resources/extjs/extjs-current/ext-all.js"></script>
	<script type="text/javascript" src="../Scripts/overrides.js"></script>
    <script type="text/javascript" src="../../../../resources/extjs/extjs-current/locale/ext-lang-es.js"></script> 
    <script type="text/javascript" src="../Scripts/app.js"></script>
	<script type="text/javascript" src="../Scripts/md5.js"></script>
</head>
<body class="{*/@mode}">
<script language="javascript">
Ext.onReady(function(){
	var login = app.login;
	app.login.onSuccess = function() {
		location.href=location.href
	}
	login.show();
});

</script>
</body>
</html>
<% END SELECT %>
<% response.end
END IF %>
