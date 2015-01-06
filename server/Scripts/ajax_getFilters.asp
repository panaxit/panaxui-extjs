
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
sSQL="SELECT [$Tools].getFilterString('"&REPLACE(xmlDoc.xml, "'", "''")&"')"
'sSQL="EXEC [$Tables].UpdateDB @updateXML='"&REPLACE("<dataTable name=""Proveedores"" primaryKey=""IdProveedor""><dataRow identityValue=""NULL"" sourceObjectId=""dataTable""><dataField name=""NombreProveedor"">'Borrar este elemento'</dataField> <dataField name=""RazonSocial"">'Borrar'</dataField> <dataField name=""IdRegimen"">NULL</dataField> <dataField name=""IdGiro"">NULL</dataField> <dataField name=""RFC""/> <dataField name=""Direccion""/> <dataField name=""Telefono""/> <dataField name=""Contacto""/> <dataField name=""Banco""/> <dataField name=""Sucursal""/> <dataField name=""Entidad""/> <dataField name=""CLABE""/> <dataField name=""NoCta""/> <dataField name=""Comentarios""/></dataRow></dataTable>", "'", "''")&"'"

DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
rsRecordSet.CursorLocation 	= 3
rsRecordSet.CursorType 		= 3
set rsRecordSet=oCn.execute(sSQL)
IF Err.Number<>0 THEN
	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede insertar un registro duplicado."
	ELSEIF INSTR(UCASE(Err.Description), UCASE("La columna no admite valores NULL"))>0 THEN
		sCampo=split(Err.Description, "'")
		ErrorDesc="El campo "&sCampo(1)&" no se puede quedar vacío"
	ELSE
		ErrorDesc="El sistema no pudo completar el proceso y regreso el siguiente error: \n\n"&Err.Description
	END IF
	IF SESSION("IdUsuario")=-1 THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& sSQL
%>
<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %><% 
END IF %>
<%= rsRecordSet(0) %>