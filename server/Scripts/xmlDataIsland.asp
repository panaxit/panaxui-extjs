<%
Response.Charset="ISO-8859-1"

DIM sConn:	sConn=SESSION("StrCnn")
DIM oCn:	set oCn=server.createobject("adodb.connection")
oCn.open sConn
oCn.CommandTimeout = 120 

DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
rsRecordSet.CursorLocation 	= 3
rsRecordSet.CursorType 		= 3
DIM sDataValue:	sDataValue = request.querystring("dataValue")
DIM sDataText:	sDataText = REPLACE(request.querystring("dataText"), "'", "''")
DIM catalogName:	catalogName=request.querystring("catalogName")
DIM bOptNull:	bOptNull=TRIM(request.querystring("OptNull"))
DIM bOptAll:	bOptAll=TRIM(request.querystring("OptAll"))
DIM bOptChoose:	bOptChoose=TRIM(request.querystring("OptChoose"))
DIM filters:	filters=request.querystring("filters")
'IF filters="" THEN filters="DEFAULT" ELSE filters="'"&REPLACE(replaceMatch(filters, "^\s*AND\s*", ""), "'", "''")&"'"
IF filters="" THEN filters="DEFAULT" ELSE filters="'"&REPLACE(filters, "'", "''")&"'"

IF bOptNull<>"" THEN 
	'IF LCASE(bOptNull)="true" THEN
		sExtraOptions=sExtraOptions&"<option value=""NULL"" text=""- -"" className=""null systemOption"" />"
	'END IF
END IF
IF bOptAll<>"" THEN 
	IF LCASE(bOptAll)="true" THEN
		sExtraOptions=sExtraOptions&"<option value=""<all>"" text=""--Todos--"" className=""all systemOption"" />"
	END IF
END IF
'IF bOptChoose<>"" THEN 
'	IF LCASE(bOptChoose)="true" THEN
'		sExtraOptions=sExtraOptions&"<option value=""NULL"" text=""[Elige...]"" color=""red"" />"
'	END IF
'END IF
'DIM sSQL:	sSQL="SELECT XMLData=(SELECT value=IdMedio, text=NombreMedio, color=CASE WHEN IdMedio<20 THEN 'aqua' WHEN IdMedio<40 THEN 'lime' ELSE 'yellow' END, selected=CASE WHEN IdMedio=23 THEN 'true' ELSE 'false' END FROM Medio FOR XML AUTO, ROOT('options'))"
'DIM sSQL:	sSQL="Tools.GetDataForCombo @FullPath='', @catalogName='"&catalogName&"', @dataValue='GridView', @Mode='update', @ValueColumn=DEFAULT, @TextColumn=DEFAULT, @Filters="&filters&", @Parameters=DEFAULT, @extraOptions='<option value=""NULL"" text=""- -"" color=""red"" /><option value=""<all>"" text=""Todas las opciones"" color=""blue"" />'"
ON ERROR RESUME NEXT
DIM sSQL:	sSQL="[$Table].getXmlChunk"
set rsRecordSet=oCn.execute(sSQL)
IF Err.Number<>0 THEN%>
error '284516':
<%= Err.Description %>
<% IF UCASE(session("username"))="WEBMASTER" THEN %>
Query: <%= REPLACE(sSQL, "'", "\'") %>
<% END IF %>
<%
ELSE
	DIM oXMLFile:	set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
	    oXMLFile.Async = false
	    oXMLFile.LoadXML(rsRecordSet(0))
		'oXMLFile.save(Server.MapPath(".")&"/XMLTest.xml")
	IF oXMLFile.selectNodes("options/option").length>3000 THEN %>
error '284516': Hay demasiados resultados (<%= oXMLFile.selectNodes("options/option").length %>)
<%	ELSE
		Response.ContentType = "text/xml" 
		response.Write("<?xml version='1.0' encoding='ISO-8859-1'?>")
		response.write oXMLFile.xml'.selectNodes("options").xml
	END IF
END IF
%>
