<!--#include file="../Scripts/IncludesAll.asp"-->
<%
Response.Charset="ISO-8859-1"
	DIM oXMLFile:	set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
	    oXMLFile.Async = false
	    oXMLFile.Load(Server.MapPath("../../../../Documentos/San Luis Potosi.xml"))'CodigosPostalesMexico.xml
			'response.write Server.MapPath("../../../../Documentos/San Luis Potosi.xml"): response.end
		'oXMLFile.save(Server.MapPath(".")&"/XMLTest.xml")
	DIM xslFile:	xslFile=server.MapPath("..\Templates\CodigosPostalesMexico.xsl")	'&request.querystring("xslFile"))

	'IF catalogName="ServiciosPrestados" THEN 
	'	
	'ELSE 
	'Response.ContentType = "text/xml" 
	'response.Write("<?xml version='1.0' encoding='ISO-8859-1'?>")
		'response.write oXMLFile.xml
	'END IF
%>
<% TransformData oXMLFile, xslFile %>

