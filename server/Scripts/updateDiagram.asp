<!--#include file="../Scripts/IncludesAll.asp"-->
<%
Response.Charset="ISO-8859-1"
'ON ERROR  RESUME NEXT
DIM xmlDoc
Set xmlDoc=Server.CreateObject("Microsoft.XMLDOM")
xmlDoc.async="false"
xmlDoc.load(Request)
'Response.ContentType = "text/xml" 
%>
<% IF NOT Session("AccessGranted") THEN %>
{
	success: false,
	message: "TIENE QUE HACER LOGIN"
}
<% RESPONSE.END %>
<% END IF %>
<%
DIM oDataSource:	Set oDataSource = New DataSource
oDataSource.CommandText = "EXEC [$Tables].UpdateDB @updateXML='"&REPLACE(REPLACE(URLDecode(xmlDoc.xml), "&", "&amp;"), "'", "''")&"', @IdUser="&SESSION("IdUsuario")
'RESPONSE.WRITE "//"&oDataSource.CommandText&vbcrlf
'response.write "error '284516': "&Server.HTMLEncode(sSQL): response.end
oDataSource.DataBind()
IF Err.Number<>0 THEN
	DIM ErrorDesc
	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede insertar un registro duplicado."
	ELSEIF INSTR(UCASE(Err.Description), UCASE("La columna no admite valores NULL"))>0 THEN
		DIM sCampo:	sCampo=split(Err.Description, "'")
		ErrorDesc="El campo "&sCampo(1)&" no se puede quedar vacío"
	ELSE %>
{
	success: false,
	message: "error '284516': El sistema no pudo completar el proceso y regresó el siguiente error: \n\n<%= REPLACE(REPLACE(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>"
}
	<% response.end %>
<%	END IF %>
{
	success: false,
	message: "<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>"
}
	<% response.end 
ELSE
	DIM xslFile:	xslFile=server.MapPath("..\Templates\updateResultsToJSON.xsl")	'&request.querystring("xslFile"))
	DIM oXMLFile:	set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
    oXMLFile.Async = false
    oXMLFile.LoadXML(oDataSource.RecordSet()(0))
    TransformData oXMLFile, xslFile
END IF %>