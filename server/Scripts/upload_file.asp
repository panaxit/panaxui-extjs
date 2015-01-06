<!--#include file="uploader.asp"-->
<html>
<body>
<%
'ON ERROR RESUME NEXT
Response.Buffer = True 
' load object
Dim load
Set load = new Loader
' calling initialize method
load.initialize
Dim fileName
Dim relativeTargetPath, absoluteTargetPath
parentFolder=TRIM(load.getValue("parentFolder"))
fileName=TRIM(load.getValue("fileName"))

file = TRIM(load.getValue("file"))
IF TRIM(fileName)="" THEN
	fileName=TRIM(load.getFileName("file"))
END IF
relativeTargetPath=parentFolder & "/" & fileName

' Ruta donde se va a guardar el file
absoluteTargetPath = Server.mapPath("../../../../"&relativeTargetPath)
'response.write "absoluteTargetPath: "&absoluteTargetPath: response.end
' Guarda el archivo
Dim fileUploaded
fileUploaded = load.saveToFile ("file", absoluteTargetPath)

If fileUploaded = False Then
	Response.Write "<font color=""red"">Fallo la carga del archivo..."
	Response.Write "</font>"
%>
<script language="JavaScript">
    alert('Error al guardar el archivo')
	var resultObject = new Object();
	resultObject.status="error";
    window.close();
</script>
<% END IF
Set load = Nothing 
%>
</body>
</html>
<script language="JavaScript">
	var resultObject = new Object();
	resultObject.file="<%= relativeTargetPath %>"
	resultObject.fileName="<%= fileName %>"
	resultObject.parentFolder="<%= parentFolder %>"
	resultObject.status="success"
    window.returnValue = resultObject;
    window.close();
</script>
