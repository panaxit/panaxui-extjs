<html>
<head>
<!--#include file="../Scripts/librerias_js.asp"-->
</head>
<body>
<script language="JavaScript">
alert(calcMD5(''))
</script>
</body>
</html>
<% 
IF NOT Session("AccessGranted") THEN %>
	<script language="JavaScript">
	var myObject = new Object();
	var resultados=window.showModalDialog("../App_Layout/Login.asp?sid="+Math.random(), myObject, "help:no; status=yes; resizable:yes; unadorned:yes; center:yes; dialogHeight:230px; dialogWidth:490px;"); // dialogLeft:114px; dialogTop:160px; 
	if (resultados==undefined)
		window.close()
	else
		location.href=location.href
		//refreshPage(self.parent.window);
	</script>
<% response.end
END IF
 %>