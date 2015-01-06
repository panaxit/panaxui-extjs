<!--#include file="../Scripts/IncludesAll.asp"-->
<html>
<head>
<!--#include file="../Scripts/librerias_js.asp"-->
<!--#include file="../Scripts/estilos.asp"-->
</head>
<body>
<select id="combo" onContextMenu="refreshData(this); return false;" templateName="ajaxCombo">
</select>
<div id="example" style="border:1pt;" onContextMenu="refreshData(this); return false;" pageIndex="3" onDblClick="this.innerHTML=''">
	Contenido
</div>

</body>
</html>