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
DIM sRoutineName: sRoutineName = URLDecode(request.form("RoutineName"))
DIM sParameters: sParameters = URLDecode(request.form("Parameters"))
DIM sSQLParams: sSQLParams="[$Tools].getOutputParameters '"&REPLACE(sRoutineName,"'","''")&"'"
DIM rsParameters: SET rsParameters = oCn.Execute(sSQLParams)
'response.write "error '284516': "&Server.HTMLEncode(sSQLParams): response.end

DIM xmlOutputParameters:	set xmlOutputParameters = Server.CreateObject("Microsoft.XMLDOM"): xmlOutputParameters.Async = false: 
IF NOT(rsParameters.BOF AND rsParameters.EOF) THEN
	xmlOutputParameters.LoadXML(rsParameters(0))
	DIM i, sOutputParams: i=0
	IF NOT(xmlOutputParameters.documentElement IS NOTHING) THEN
		DIM sOutputParamsDeclaration
		FOR EACH oNode IN xmlOutputParameters.documentElement.selectNodes("/*/*") 
			i=i+1
			IF i=1 THEN sOutputParamsDeclaration=sOutputParamsDeclaration&"DECLARE " ELSE sOutputParamsDeclaration=sOutputParamsDeclaration&"," END IF
			sOutputParamsDeclaration=sOutputParamsDeclaration& oNode.getAttribute("parameterName")&" "&oNode.getAttribute("dataType")
			IF i>1 OR rtrim(sParameters)<>"" THEN sParameters=sParameters&", " END IF
			sParameters=sParameters & oNode.getAttribute("parameterName")&"="&oNode.getAttribute("parameterName")&" OUTPUT"
			IF i>1 THEN sOutputParams=sOutputParams&", " END IF
			sOutputParams=sOutputParams& REPLACE(oNode.getAttribute("parameterName"), "@", "")&"=" & oNode.getAttribute("parameterName")
		NEXT
	END IF
	IF TRIM(sOutputParamsDeclaration)<>"" THEN sOutputParamsDeclaration=sOutputParamsDeclaration&";"
END IF
strSQL=""& sOutputParamsDeclaration &"SET NOCOUNT ON; EXEC "&sRoutineName&" "&sParameters&"; "
IF sOutputParams<>"" THEN strSQL=strSQL&"SET NOCOUNT ON; SELECT "&sOutputParams
'response.write "error '284516': "&Server.HTMLEncode(strSQL): response.end
%>
<% 'error '<%= REPLACE(strSQL, "'", "\'") %%' %>
<%	'response.end

ON ERROR  RESUME NEXT
DIM rsResult: SET rsResult = oCn.Execute(strSQL)
'strSQL="INSERT INTO Transacciones (Tabla, Columna, Condiciones, NuevoValor, ViejoValor, Operacion, IdUsuario) VALUES "
IF Err.Number<>0 THEN
	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede insertar un registro duplicado."
	ELSEIF INSTR(UCASE(Err.Description), UCASE("La columna no admite valores NULL"))>0 THEN
		sCampo=split(Err.Description, "'")
		ErrorDesc="El campo "&sCampo(1)&" no se puede quedar vacío"
	ELSE
		ErrorDesc="El sistema no pudo completar el proceso y regresó el siguiente error: <br/><br/><strong>"&Err.Description&"<br/>"&strSQL&"</strong>"
	END IF
'	IF application("debug_system") THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& strSQL
%>
Context.status='error'
Context.statusMessage="<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>"
//alert("<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>");
<% ELSEIF rsResult.fields.Count>0 THEN %>
	Context.status='success'
	Context.fields={};
	<% DIM oField, sType, sValue %>
	<% FOR EACH oField IN rsResult.fields %>
		<% IF TypeName(oField)="Field" THEN %><% sType=TypeName(oField.value): sValue=oField.value %><% ELSE %><% sType=TypeName(oField): sValue=oField %><% END IF %>
		Context.fields.<%= oField.name %>=<% SELECT CASE UCASE(sType): CASE "NULL": %>null<% CASE "BOOLEAN": %><% IF sValue THEN %>true<% ELSE %>false<% END IF %><% CASE ELSE %>"<%= RTRIM(REPLACE(replaceMatch(sValue, "["&chr(13)&""&chr(10)&""&vbcr&""&vbcrlf&"]", "\"&vbcrlf),"""", """""")) %>"<% END SELECT %>; 
	<% NEXT %>
<% rsResult.Close %>
<% ELSE %>
	Context.status='success'
	Context.value=true
<% END IF %>
<% oCn.close %>