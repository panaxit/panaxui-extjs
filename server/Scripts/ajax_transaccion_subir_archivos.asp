<!--#include file="Classes/Classes.asp"-->
<!--#include file="uploader.asp"-->
<head>
	<title>Promociones HABI</title>
<LINK REL=stylesheet HREF="estilo.css" TYPE="text/css">
<%
Response.Buffer = True 
' load object
Dim load
Set load = new Loader
' calling initialize method
load.initialize
%>
</head>
<body bgcolor="#FFFFFF" text="#000000" link="#000000" vlink="#000000" alink="#FF0000">
<%
' PARAMETROS QUE RECIBE
titulo = TRIM(load.getValue("titulo_archivo"))
observaciones = TRIM(load.getValue("observaciones"))
pathFile=TRIM(load.getValue("pathFile"))

archivo = TRIM(load.getValue("archivo"))
NombreArchivo=TRIM(load.getFileName("archivo"))

Dim fileName
Dim pathToFile

fileName = NombreArchivo

' Ruta donde se va a guardar el archivo
pathToFile = pathFile & "/" & fileName
' Guarda el archivo
Dim fileUploaded
fileUploaded = load.saveToFile ("archivo", pathToFile)

If fileUploaded = False Then
	Response.Write "<font color=""red"">Fallo la carga del archivo..."
	Response.Write "</font>"
%>
<script language="JavaScript">
    alert('Error al guardar el archivo')
	window.returnValue = "error";
    window.close();
</script>
<% END IF
Set load = Nothing 
%>
</body>
</html>
<script language="JavaScript">
    window.returnValue = "value='<%= REPLACE(REPLACE("/"&application("rootFolder")&"\FilesRepository"& "/" & fileName, "\", "/"), "'", "\'") %>'";
    window.close();
</script>
