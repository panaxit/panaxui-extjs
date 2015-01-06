<%
Set cn = Server.CreateObject("ADODB.Connection")
cn.ConnectionTimeout = 0
cn.CommandTimeout = 0
cn.Open SESSION("StrCnn")
cn.Execute("SET LANGUAGE SPANISH")
%>
<!--#include file="vbscript.asp"-->
<%
Response.Charset="ISO-8859-1"
FUNCTION caracteresEspeciales(frase)
	frase=REPLACE(frase, "<space>", " ")
	frase=REPLACE(frase, "<a-acento>", "á")
	frase=REPLACE(frase, "<e-acento>", "é")
	frase=REPLACE(frase, "<i-acento>", "í")
	frase=REPLACE(frase, "<o-acento>", "ó")
	frase=REPLACE(frase, "<u-acento>", "ú")
	caracteresEspeciales=frase
END FUNCTION

ON ERROR  RESUME NEXT
query_operation = request.form("query_operation")
table_name = caracteresEspeciales(request.form("table_name"))
bReturnInsertedRow = FALSE
columns = caracteresEspeciales(request.form("columns"))
column_values = caracteresEspeciales(request.form("column_values")) 'para insert
conditions = caracteresEspeciales(request.form("conditions"))

sDisplayColumn=Application("DisplayColumn_"&TRIM(table_name))
IF column_values<>"" THEN
	IF query_operation="UPDATE" THEN
		sConditions="NOT("&URLDecode(conditions)&") AND"
		strSQL = "UPDATE "&table_name&" SET "&column_values&" WHERE "&conditions
		strSQL=URLDecode(strSQL)
	ELSEIF query_operation="INSERT" THEN
		sConditions=""
		strSQL = "SET NOCOUNT ON; SET DATEFORMAT DMY;"
		strSQL = strSQL & "INSERT INTO "&table_name&" ("&columns&") SELECT "&column_values&"; "
		strSQL=URLDecode(strSQL)
		IF bReturnInsertedRow AND NOT(ISNULL(sDisplayColumn)) THEN ' OR ISNULL(sIdentityColumn)) THEN
			strSQL = strSQL & "SELECT SCOPE_IDENTITY() AS NewID, "&sDisplayColumn&" [DisplayColumn] FROM "&table_name&" WHERE $Identity=SCOPE_IDENTITY();" 
		ELSE
			strSQL = strSQL & "SELECT SCOPE_IDENTITY() AS NewID, 'Registro Ingresado' [DisplayColumn]"
		END IF
	END IF 
END IF
	
IF 1=0 AND NOT(ISNULL(sDisplayColumn)) THEN
	strDuplicado = "SELECT "&sDisplayColumn&" [RegistroDuplicado] FROM "&table_name&" WHERE "&sConditions&" EXISTS(SELECT * FROM ( SELECT "&sDisplayColumn&" [CompareKeys] FROM (SELECT "&URLDecode(column_values)&" ) SQLQuery ) CompareQuery WHERE "&sDisplayColumn&" LIKE CompareQuery.[CompareKeys])" 
	strDuplicado=REPLACE(strDuplicado, "'NULL'", "'%'")
	strDuplicado=REPLACE(strDuplicado, "''", "'%'") %>
//	document.write ('<%= REPLACE(strDuplicado, "'", "\'") %>')
<%	'response.end
	SET rsDuplicado = cn.Execute(strDuplicado)
	IF NOT(rsDuplicado.BOF AND rsDuplicado.EOF) THEN
	'	IF INSTR(UCASE(Err.Description), UCASE("clave duplicada"))>0 THEN
	'		ErrorDesc="No se puede insertar un registro duplicado"
	'	ELSE
			ErrorDesc="Se ha encontrado el siguiente registro duplicado: "&rsDuplicado("RegistroDuplicado")
	'	END IF %>
		setAttribute("hasError", true);
		alert('Error: <%= REPLACE(ErrorDesc, "'", "\'") %>');
<%		RESPONSE.END
	END IF
END IF
strSQL=REPLACE(strSQL, "'NULL'", "NULL")
strSQL=REPLACE(strSQL, ",[object]=UNDEFINED", "")
strSQL=REPLACE(strSQL, ",[object]", "")
%>
//document.write('<%= REPLACE(strSQL, "'", "\'") %>')
<% IF session("IdUsuario")=-1 THEN %>	/*alert('<%= REPLACE(strSQL, "'", "\'") %>')*/<% END IF %>
<%	'response.end
'END IF
IF strSQL<>"" THEN SET rsNewID = cn.Execute(strSQL)
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
	IF ABS(SESSION("IdUsuario"))=1 THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& strSQL
%>
setAttribute("hasError", true);
//document.write("<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>")
alert("<%= REPLACE(REPLACE(ErrorDesc, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""), """", "\""") %>");
<% 
ELSE 
 	IF query_operation="INSERT" THEN 
		iNewId=rsNewID("NewID") %>
		//alert("Guardado con éxito nuevo registro con ID: <%= iNewId %>")
		oDestino.value=<%= iNewId %>
<% 	END IF %>

identifier_elements=getElementsByIdentifier(oDestino);
for (var f=identifier_elements.length-1; f>=0; --f)
	{
	if (identifier_elements[f].id=='identifier')
		{
<% 	IF query_operation="INSERT" THEN %>
//		identifier_elements[f].submitChildren();
<% 	END IF %>
		}
	else
		{
		if (identifier_elements[f].hasChanged && eval(identifier_elements[f].hasChanged)) identifier_elements[f].setAttribute("hasChanged", false);
		identifier_elements[f].defaultValue=getVal(identifier_elements[f])
		}
	}
	<% 	IF 1=1 OR query_operation="INSERT" THEN %>
//		oDestino.submitChildren();
		window.returnValue = "try {campo=event.srcElement; if ($(event.srcElement).hasClass('commandButton')) {if (oTableLoader) { oTableLoader.isUpdated=false; } else { location.href=location.href;} } else { <% IF iNewId<>"" THEN %>for (c=0; c<(campo.length && campo(0).tagName!='OPTION'?campo.length:1); ++c) { campo_element=(campo.length && campo(0).tagName!='OPTION'?campo(c):campo); campo_element.options[campo_element.length]=new Option(\'Ultimo registro ingresado\', \'<%= TRIM(iNewId) %>\'); if (campo_element==event.srcElement) { campo_element[campo_element.length-1].selected=true; try {campo_element.cargarCatalogoForzado} catch(e){campo_element.fireEvent('onchange');}} } <% END IF %>(campo.type=='select-one' && (campo.className=='catalogo' || $(campo).hasClass('catalog')))?campo.isUpdated=false:null;} } catch(e) {alert(e.description)} ";
	<% 	END IF %>
	if ((typeof self.parent.window.dialogArguments)=='object') self.parent.close();<% 
END IF %>
