<!--#include file="../Scripts/IncludesAll.asp"-->
<% SERVER.SCRIPTTIMEOUT = 4800 %>
<html>
<head>
<!--#include file="../Scripts/librerias_js.asp"-->
<!--#include file="../Scripts/estilos.asp"-->
<style>
.mailBody th {background-color:navy; text-align:right; color:white;}
.mailBody td {margin:0;padding:3 6;}
.mailBody input {display:block; width: 100%; height:20; font-size:11pt;}
.mailBody strong {font-size:12pt;}
</style>
</head>
<%
Response.Charset="ISO-8859-1"
DIM sConn:	sConn=SESSION("StrCnn")
DIM oCn:	set oCn=server.createobject("adodb.connection")
oCn.open sConn
oCn.CommandTimeout = 120 

DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
rsRecordSet.CursorLocation 	= 3
rsRecordSet.CursorType 		= 3
DIM sParameter, sParameters
DIM i, sSessionVariable, sType 
DIM oMessage: Set oMessage = new Mail

'response.write request.querystring("action")&"<br>"
'response.write URLDecode(request.querystring("message"))&"<br>"
oMessage.Message.To=request.querystring("to")
oMessage.Message.Subject=request.querystring("subject")
oMessage.Message.HTMLBody=URLDecode(request.querystring("message"))
DIM messageURL: messageURL = URLDecode(request.querystring("messageURL"))
IF (oMessage.Message.To<>"" AND UCASE(request.querystring("action"))="ENVIAR") THEN
	'oMessage.Message.CreateHTMLBody "http://www.w3schools.com/asp/"
	IF TRIM(messageURL)<>"" THEN oMessage.Message.CreateHTMLBody (messageURL) END IF
	'oMessage.Message.AddAttachment "D:\DropBox\My Dropbox\Websites\Px\archivos_proyectos\Resultados Semanales 2010.xls"
	oMessage.Message.Send()
	response.end
END IF
%>
<body>
<form action="sendMail.asp" id="mailForm" method="get" target="_self">
<input type="hidden" name="messageURL" value="<%= messageURL %>" />
<table class="mailBody">
	<tr>
		<th>De:</th><td><input name="from" type="text" value="<%= oMessage.Message.from %>" readonly="readonly" class="readonly"/></td>
	</tr>
	<tr>
		<th>Para:</th><td><input name="to" type="text" value="<%= oMessage.Message.to %>"/></td>
	</tr>
	<tr>
		<th>Subject:</th><td><input name="subject" type="text" value="<%= oMessage.Message.subject %>"/></td>
	</tr>
	<tr>
		<th>&nbsp;</th><td><% IF messageURL<>"" THEN %><strong>El documento está listo para ser enviado</strong><% ELSE %><textarea name="message" style="width: 800; height: 300px; " id="message"><%= oMessage.Message.HTMLBody %></textarea><% END IF %></td>
	</tr>
	<tr>
		<td colspan="2"><button type="submit" name="action" onclick="document.all('mailForm').submit();">Enviar</button></td>
	</tr>
</table>
</form>
<script type="text/javascript">bkLib.onDomLoaded(nicEditors.allTextAreas);</script>
<script>
/*
var area1, area2;

function toggleArea1() {
	if(!area1) {
		area1 = new nicEditor({fullPanel : true}).panelInstance('message',{hasPanel : true});
	} else {
		area1.removeInstance('message');
		area1 = null;
	}
}

function addArea2() {
	area2 = new nicEditor({fullPanel : true}).panelInstance('myArea2');
}
function removeArea2() {
	area2.removeInstance('myArea2');
}

bkLib.onDomLoaded(function() { toggleArea1(); });*/
</script>	

</body>

<%response.end

'DIM sSQL:	sSQL="[$Table].[XmlData:"&APPLICATION("system_version")&"] @@IdUser="&SESSION("IdUsuario")&", @FullPath='"&sFullPath&"', @TableName='"&sCatalogName&"', @Mode="&sMode&", @PageIndex="&iPageIndex&", @PageSize="&iPageSize&", @MaxRecords="&iMaxRecords&", @Filters="&sFilters&", @Parameters="&sParameters&""
'	'IF UCASE(session("username"))="WEBMASTER" THEN 	response.write "<br/><br/>"&sSQL: response.end
'	set rsRecordSet=oCn.execute(sSQL)
'	SELECT CASE Err.Number
'	CASE -2147217900
'		IF request.querystring("app_retry")<>1 THEN 
'			DIM sCurrentLocation:	sCurrentLocation=Request.serverVariables("PATH_INFO")&"?"&Request.ServerVariables("QUERY_STRING")
'			'IF Request.ServerVariables("QUERY_STRING")<>"" THEN sCurrentLocation=sCurrentLocation&"&"
'			'response.write "<strong>REINTENTANDO... ("&sCurrentLocation&"&app_retry=1)</strong>"
'			response.redirect sCurrentLocation&"&app_retry=1"
'		END IF
'		response.write "<strong class=""error"">Error: "&REPLACE(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")&"</strong>"
'		IF UCASE(session("username"))="WEBMASTER" THEN 	response.write "<br/><br/>"&sSQL
'		response.end
'	CASE 0
'		'continue
'	CASE ELSE
'		response.write "Error "&Err.Number&"!, no se pudo recuperar la información.<br><br>"
'		IF UCASE(session("username"))="WEBMASTER" THEN 	response.write Err.Description&" <br><br>"&sSQL
'		response.end
'		Err.Clear
'	END SELECT
'ON ERROR  GOTO 0
oTimer.StopTimer()
DIM sQueryTime: sQueryTime=oTimer.ElapsedTime

oTimer.StartTimer()
DIM oXMLFile:	set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
    oXMLFile.Async = false
    oXMLFile.LoadXML(rsRecordSet(0))

IF (oXMLFile.documentElement.getAttribute("controlType")="fileTemplate") THEN 
	DIM Document:	Set Document=new FileTranslator
	ON ERROR RESUME NEXT
	DIM FileTemplate:	FileTemplate=oXMLFile.documentElement.selectSingleNode("//*[@fileTemplate]").getAttribute("fileTemplate")
		SELECT CASE Err.Number
		CASE 0
			'continue
		CASE ELSE
			response.write "Error "&Err.Number&"!, no está definido o se pudo recuperar el archivo plantilla.<br><br>"
			IF session("IdUsuario")=-1 THEN 	response.write Err.Description&" <br><br>"&sSQL
			response.end
			Err.Clear
		END SELECT
	ON ERROR  GOTO 0
	'response.write FileTemplate
	IF ISNULL(FileTemplate) THEN 
		response.write "<strong>EL NOMBRE DEL ARCHIVO NO ESTÁ DEFINIDO</strong>": response.end
	END IF
	Document.FileName=server.MapPath("..\..\..\..\Documentos\"&FileTemplate)
	Document.DataSource=oXMLFile
	Document.WriteCode()
ELSE
	DIM xslFile:	xslFile=server.MapPath("..\Templates\html.xsl")	'&request.querystring("xslFile"))
	TransformData oXMLFile, xslFile 
END IF
oTimer.StopTimer()
IF UCASE(session("username"))="WEBMASTER" THEN 
'	response.write "Query Time: <strong>"&sQueryTime&"</strong>; ": response.write "Transformation Time: <strong>"&oTimer.ElapsedTime&"</strong><br/>"': response.end
END IF
 %>
<!-- <div id="Output"></div> -->
</html>
