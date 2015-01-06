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
'ON ERROR  RESUME NEXT
strSQL = request.form("strSQL")

strSQL=URLDecode(strSQL)
'strSQL=REPLACE(strSQL, "'NULL'", "NULL")
'strSQL=REPLACE(strSQL, "''", "NULL")
strSQL="SELECT Result="&strSQL
%>
//	alert('<%= REPLACE(strSQL, "'", "\'") %>')
<%	'response.end

SET rsResult = oCn.Execute(strSQL)
'strSQL="INSERT INTO Transacciones (Tabla, Columna, Condiciones, NuevoValor, ViejoValor, Operacion, IdUsuario) VALUES "

'strSQL="INSERT INTO Transacciones (Tabla, Columna, Condiciones, NuevoValor, ViejoValor, Operacion, IdUsuario) VALUES "
IF Err.Number<>0 THEN
	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede insertar un registro duplicado."
	ELSEIF INSTR(UCASE(Err.Description), UCASE("La columna no admite valores NULL"))>0 THEN
		sCampo=split(Err.Description, "'")
		ErrorDesc="El campo "&sCampo(1)&" no se puede quedar vacío"
	ELSE
		ErrorDesc="El sistema no pudo completar el proceso y regresó el siguiente error: <br/><br/><strong>"&Err.Description&"</strong>"
	END IF
'	IF application("debug_system") THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& strSQL
%>
Context.status='error'
Context.statusMessage="<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>"
//alert("<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>");
<% ELSE %>
	Context.status='success'
	Context.value=<% DIM result: result=rsResult("Result") %><% SELECT CASE UCASE(TypeName(result)): CASE "NULL": %>null<% CASE "BOOLEAN": %><% IF result THEN %>true<% ELSE %>false<% END IF %><% CASE ELSE %>"<%= RTRIM(result) %>"<% END SELECT %>
<% END IF %>
<% rsResult.Close %>
<% oCn.close %>