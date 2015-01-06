<%
'application("serverName")="URIEL-LAP\TEST"
'application("dataBaseName")="CRMHorizontes"
'SESSION("StrCnn") = "driver={SQL Server};server="&application("serverName")&";uid=sa;pwd=zama;database="&application("dataBaseName")

DIM sConn:	sConn=SESSION("StrCnn")
DIM oCn:	set oCn=server.createobject("adodb.connection")
oCn.open sConn
oCn.CommandTimeout = 120 

DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
rsRecordSet.CursorLocation 	= 3
rsRecordSet.CursorType 		= 3

DIM sSQL:	sSQL="ReporteProspectosXML 20, 40"

set rsRecordSet=oCn.execute(sSQL)

DIM oXML:	set oXML = Server.CreateObject("Microsoft.XMLDOM")
    oXML.Async = false
    oXML.LoadXML(rsRecordSet("XMLData"))

Response.ContentType = "text/xml" 
response.write oXML.xml
response.end
%>

