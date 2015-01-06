<%
Set cn = Server.CreateObject("ADODB.Connection")
cn.ConnectionTimeout = 0
cn.CommandTimeout = 0
cn.Open SESSION("StrCnn")
cn.Execute("SET LANGUAGE SPANISH")
%>
<!--#include file="funciones_vbscript.asp"-->
<%
Response.Charset="ISO-8859-1"
'ON ERROR  RESUME NEXT
strSQL = request.form("strSQL")

strSQL=URLDecode(strSQL)
strSQL=REPLACE(strSQL, "'NULL'", "NULL")
strSQL=REPLACE(strSQL, "''", "NULL")
strSQL="SELECT Result="&strSQL
%>
//	alert('<%= REPLACE(strSQL, "'", "\'") %>')
<%	'response.end

SET rsResult = cn.Execute(strSQL)
'strSQL="INSERT INTO Transacciones (Tabla, Columna, Condiciones, NuevoValor, ViejoValor, Operacion, IdUsuario) VALUES "

IF Err.Number<>0 THEN
	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede insertar un registro duplicado."
	ELSEIF INSTR(UCASE(Err.Description), UCASE("La columna no admite valores NULL"))>0 THEN
		sCampo=split(Err.Description, "'")
		ErrorDesc="El campo "&sCampo(1)&" no se puede quedar vacío"
	ELSE
		ErrorDesc="El sistema no pudo completar el proceso y regreso el siguiente error: \n\n"&Err.Description
	END IF
'	IF application("debug_system") THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& strSQL
%>
setAttribute("hasError", true);
alert("<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>");

<% ELSE %>
//	alert(oDestino.value)
	oDestino.value="<%= RTRIM(rsResult("Result")) %>"
//	alert(oDestino.value)
<% END IF %>
