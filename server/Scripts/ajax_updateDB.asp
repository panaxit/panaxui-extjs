<?xml version="1.0" encoding="ISO-8859-1"?>
<%
DIM sConn:	sConn=SESSION("StrCnn")
DIM oCn:	set oCn=server.createobject("adodb.connection")
oCn.open sConn
oCn.CommandTimeout = 120 

oCn.Execute("SET LANGUAGE SPANISH")
%>
<!--#include file="vbscript.asp"-->
<%
Response.Charset="ISO-8859-1"
ON ERROR  RESUME NEXT
DIM xmlDoc
Set xmlDoc=Server.CreateObject("Microsoft.XMLDOM")
xmlDoc.async="false"
xmlDoc.load(Request)
Response.ContentType = "text/xml" 
%>
<% IF NOT Session("AccessGranted") THEN %>
<results>
	<result status="error" statusMessage="TIENE QUE HACER LOGIN"/>
</results>
<% RESPONSE.END %>
<% END IF %>
<%
sSQL="EXEC [$Tables].UpdateDB @updateXML='"&REPLACE(REPLACE(URLDecode(xmlDoc.xml), "&", "&amp;"), "'", "''")&"', @IdUser="&SESSION("IdUsuario")
'IF UCASE(session("username"))="WEBMASTER" THEN response.write "error '284516': "&Server.HTMLEncode(sSQL): response.end

'sSQL="EXEC [$Tables].UpdateDB @updateXML='"&REPLACE("<dataTable name=""Proveedores"" primaryKey=""IdProveedor""><dataRow identityValue=""NULL"" sourceObjectId=""dataTable""><dataField name=""NombreProveedor"">'Borrar este elemento'</dataField> <dataField name=""RazonSocial"">'Borrar'</dataField> <dataField name=""IdRegimen"">NULL</dataField> <dataField name=""IdGiro"">NULL</dataField> <dataField name=""RFC""/> <dataField name=""Direccion""/> <dataField name=""Telefono""/> <dataField name=""Contacto""/> <dataField name=""Banco""/> <dataField name=""Sucursal""/> <dataField name=""Entidad""/> <dataField name=""CLABE""/> <dataField name=""NoCta""/> <dataField name=""Comentarios""/></dataRow></dataTable>", "'", "''")&"'"

DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
rsRecordSet.CursorLocation 	= 3
rsRecordSet.CursorType 		= 3
set rsRecordSet=oCn.execute(sSQL)
IF Err.Number<>0 THEN
	DIM ErrorDesc
	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede insertar un registro duplicado."
	ELSEIF INSTR(UCASE(Err.Description), UCASE("La columna no admite valores NULL"))>0 THEN
		sCampo=split(Err.Description, "'")
		ErrorDesc="El campo "&sCampo(1)&" no se puede quedar vacío"
	ELSE
		response.write "error '284516': El sistema no pudo completar el proceso y regresó el siguiente error: \n\n" & Err.Description  & "\n\n"& sSQL : response.end
	END IF
	'IF UCASE(session("username"))="WEBMASTER" THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& sSQL
%>
<results>
	<result status="error" statusMessage="<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "&quot;") %>"/>
</results>
<% response.end
ELSEIF rsRecordSet.BOF AND rsRecordSet.EOF THEN %>
<results/>
<%ELSE
'DIM xslFile:	xslFile=server.MapPath("..\Templates\updateResults.xsl")	'&request.querystring("xslFile"))
DIM oXMLFile:	set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
    oXMLFile.Async = false
    oXMLFile.LoadXML(rsRecordSet(0))
    'oXMLFile.LoadXML("<?xml version=""1.0"" encoding=""ISO-8859-1""?>"&rsRecordSet(0)): TransformData oXMLFile, xslFile
%>
	<% 'window.returnValue = "alert('')"; %>
<% 'try {campo=event.srcElement; if ($(event.srcElement).hasClass('commandButton')) {if (oTableLoader) { oTableLoader.isUpdated=false; } else { location.href=location.href;} } else { <% IF iNewId<>"" THEN %%for (c=0; c<(campo.length && campo(0).tagName!='OPTION'?campo.length:1); ++c) { campo_element=(campo.length && campo(0).tagName!='OPTION'?campo(c):campo); campo_element.options[campo_element.length]=new Option(\'Ultimo registro ingresado\', \'<%= TRIM(iNewId) %%\'); if (campo_element==event.srcElement) { campo_element[campo_element.length-1].selected=true; try {campo_element.cargarCatalogoForzado} catch(e){campo_element.fireEvent('onchange');}} } <% END IF %%(campo.type=='select-one' && (campo.className=='catalogo' || $(campo).hasClass('catalog')))?campo.isUpdated=false:null;} } catch(e) {alert(e.description)}  %>
<%= oXMLFile.xml %>
<% END IF %>