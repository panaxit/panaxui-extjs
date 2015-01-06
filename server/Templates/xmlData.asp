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
DIM sViewMode:	sViewMode = request.querystring("ViewMode")
IF sViewMode<>"" THEN sViewMode="'"&sViewMode&"'" ELSE sViewMode="DEFAULT" END IF
DIM iPageIndex:	iPageIndex = CINT(request.querystring("PageIndex"))
IF iPageIndex=0 THEN iPageIndex="DEFAULT" END IF
DIM iPageSize:	iPageSize = CINT(request.querystring("PageSize"))
IF iPageSize=0 THEN 
	IF request.querystring("ViewMode")="DetailsView" THEN 
		iPageSize=1
	ELSE 
		iPageSize="DEFAULT" 
	END IF
END IF

DIM sSQL:	sSQL="ReporteProspectosXML "&sViewMode&", "&iPageIndex&", "&iPageSize&""
set rsRecordSet=oCn.execute(sSQL)

DIM oXMLFile:	set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
    oXMLFile.Async = false
    oXMLFile.LoadXML(rsRecordSet("XMLData"))

Response.ContentType = "text/xml" 
response.Write("<?xml version='1.0' encoding='ISO-8859-1'?>")
response.write oXMLFile.xml
response.end
%>