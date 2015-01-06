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
%>
//	alert('<%= REPLACE(strSQL, "'", "\'") %>')
<%	'response.end

SET rsNewID = cn.Execute(strSQL)
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
	<% IF query_operation="INSERT" THEN %>
//		alert("Guardado con éxito nuevo registro con ID: <%= rsNewID("NewID") %>")
		oDestino.value=<%= rsNewID("NewID") %>
	<% END IF %>

identifier_elements=getElementsByIdentifier(oDestino);
for (f=identifier_elements.length-1; f>=0; --f)
	{
	if (identifier_elements[f].id=='identifier')
		{
	<% IF query_operation="INSERT" THEN %>
//		identifier_elements[f].submitChildren();
	<% END IF %>
		}
	else
		{
		identifier_elements[f].setAttribute(<% IF NOT(rsNewID.BOF AND rsNewID.EOF) THEN %>"hasChanged", 'false'<% ELSE %>"hasError", 'true'<% END IF %>);
		identifier_elements[f].defaultValue=getVal(identifier_elements[f])
		}
	}
	<% IF query_operation="INSERT" THEN %>
//		oDestino.submitChildren();
		window.returnValue = "try {campo=event.srcElement; for (c=0; c<(campo.length && campo(0).tagName!='OPTION'?campo.length:1); ++c) { campo_element=(campo.length && campo(0).tagName!='OPTION'?campo(c):campo); campo_element.options[campo_element.length]=new Option(\'<%= TRIM(rsNewID("DisplayColumn")) %>\', \'<%= TRIM(rsNewID("NewID")) %>\'); if (campo_element==event.srcElement) { campo_element[campo_element.length-1].selected=true; campo_element.fireEvent('onchange');} } } catch(e) {} ";
	<% END IF %>
	if ((typeof self.parent.window.dialogArguments)=='object') self.parent.close();
<% END IF %>
