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
ON ERROR  RESUME NEXT 
 
' PARAMETROS QUE RECIBE
table_name = URLDecode(TRIM(request.form("table_name")))
restrictions = URLDecode(TRIM(request.form("restrictions")))
'cn.BeginTrans
	strSQL = "DELETE FROM "&table_name&" WHERE "&restrictions&"" %>
<%' alert("<%= strSQL %%") %>
<%	'response.end
	cn.Execute(strSQL)

IF Err.Number<>0 THEN
	IF INSTR(UCASE(Err.Description), UCASE("restricción REFERENCE"))>0 THEN
		ErrorDesc="PRECAUCIÓN: No se puede eliminar el elemento porqué está en uso"
	ELSE
		ErrorDesc="El sistema no pudo completar el proceso y regreso el siguiente error, que debe reportar al administrador del sistema: \n\n"&Err.Description
	END IF
	IF UCASE(session("username"))="WEBMASTER" THEN ErrorDesc=ErrorDesc & ": " & "\n\n"& replace(Err.Description,"'","\'") &"\n\n" & request.form &"\n\n" & strSQL
%> 
alert("<%= REPLACE(ErrorDesc, """", "\""") %>");
oDestino.value=false;
<%
ELSE
%> 
try
	{
	if (oDestino.sourceObject.tagName=='SELECT')
		{
		oDestino.sourceObject.remove(oDestino.sourceObject.selectedIndex);
		if (oDestino.sourceObject.length==0)
			{
		   	oDestino[0]=new Option("No hay elementos", '');
			oDestino[0].id='opt_vacio'
			oDestino[0].style.color='red'
			}
		}
	else if (oDestino.sourceObject.tagName=='TR')
		{
		oTable=getParent('TABLE', oDestino);
		!(oTable.all(oDestino.sourceObject.id).length && oTable.all(oDestino.sourceObject.id).length>1)?addRow(oDestino):null; fix_rowId( removeRow(oDestino) );
		//oTable.deleteRow(oDestino.sourceObject.rowIndex)
		}
	else
		{
		oDestino.sourceObject.removeNode(true);
		}
	}
catch(e) {alert(e.description);}
oDestino.value=true;
<%
END IF
'cn.CommitTrans
'cn.RollBackTrans
 %>
