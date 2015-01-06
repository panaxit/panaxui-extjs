<% Response.Charset="ISO-8859-1"
DIM sSede: sSede = URLDecode(request.form("sede"))
SESSION("StrCnn")=application("StrCnn")&"database="&application("dataBaseName")'&sSede
Set oCn = Server.CreateObject("ADODB.Connection")
oCn.ConnectionTimeout = 10
oCn.CommandTimeout = 60
ON ERROR RESUME NEXT
oCn.Open SESSION("StrCnn")
IF Err.Number<>0 THEN %>
	{
	success: false,
	message: 'No se pudo establecer una conexión con la base de datos <%= application("dataBaseName")&sSede %>: <%= REPLACE(Err.Description,"'","\'") %>'
	}
<% 	response.end
END IF
oCn.Execute("SET LANGUAGE SPANISH")
%>
<!--#include file="vbscript.asp"-->
<%
ON ERROR RESUME NEXT
sUserName = URLDecode(request.form("UserName"))
sPassword = URLDecode(request.form("Password"))
sSede = URLDecode(request.form("Password"))
'strSQL="SELECT IdUsuario=[$Security].AuthenticateUser('" & sUserName & "', '"& sPassword &"')"
'Set rsSEG = Server.CreateObject("ADODB.RecordSet")
strSQL="EXEC [$Security].Authenticate '" & RTRIM(sUserName) & "', '"& RTRIM(sPassword) &"'"
Set rsSEG = Server.CreateObject("ADODB.RecordSet")
rsSEG.CursorLocation 	= 3
rsSEG.CursorType 		= 3
set rsSEG = oCn.Execute(strSQL)
IF Err.Number<>0 THEN %>
	{
	success: false,
	message: '<%= REPLACE(REPLACE(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]", ""),"'","\'") %>'
	}
<% 	response.end
END IF
'	alert('<%= REPLACE(strSQL, "'", "\'") %%')
'<%	'response.end
If rsSEG.BOF or rsSEG.EOF Then
	Session("AccessGranted") = FALSE
ELSE
	Session("AccessGranted") = FALSE
	IF NOT ISNULL(rsSEG("userId")) THEN
		'Guarda la cookie de que si tienen problemas con los PopUps
		Response.Cookies("AntiPopUps") = REQUEST.FORM("AntiPopUps")
		Response.Cookies("AntiPopUps").Expires = Date() + 1
		' con esto actualizamos las VC que tengan Aportacion=1 y que tengan más de 41 días ---------> (1)
'				strSQL="IF EXISTS (SELECT DISTINCT DATEDIFF(day, FechaVC, '"&date()&"') AS Dias FROM StatusVenta WHERE Aportacion=1 AND FechaVC<>'1/1/1900' AND DATEDIFF(day, FechaVC, '"&date()&"')>=42) INSERT INTO Regresadas SELECT Vendedores.IdInmobil, DetalleEtapa.IdDetalleEtapa, FechaRegreso='"&FormatDateTime(Now)&"', FechaVC FROM DetalleEtapa, StatusVenta, Ventas, Vendedores WHERE DetalleEtapa.IdDetalleEtapa=StatusVenta.IdDetalleEtapa AND Ventas.IdDetalleEtapa=DetalleEtapa.IdDetalleEtapa AND Ventas.IdVendedor=Vendedores.IdVendedor AND Aportacion=1 AND FechaVC<>'1/1/1900' AND DATEDIFF(day, FechaVC, '"&date()&"')>=42 UPDATE StatusVenta SET FechaVC='1/1/1900', VC=0, Aportacion=0 FROM StatusVenta WHERE Aportacion=1 AND FechaVC<>'1/1/1900' AND DATEDIFF(day, FechaVC, '"&date()&"')>=42"
'				Set rs = Server.CreateObject("ADODB.RecordSet")
'				rs.open strSQL, cn, 1, 1
		' <---------------------- (1)
		Session.Timeout = 600
		Session("AccessGranted") = TRUE
		Session("username")=sUserName
		Session("password")=sPassword
		Session("IdUsuario")=rsSEG("userId")
		oCn.execute "IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES IST WHERE routine_schema IN ('$Application') AND ROUTINE_NAME IN ('OnStartUp')) BEGIN EXEC [$Application].OnStartUp END"
		
		ON ERROR RESUME NEXT
			DIM sSQL:	sSQL="[$Security].UserSitemap @@IdUser="&SESSION("IdUsuario")
			IF session("lang")<>"" THEN sSQL = sSQL&", @lang="&session("lang") END IF
			Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
			rsRecordSet.CursorLocation 	= 3
			rsRecordSet.CursorType 		= 3
			set rsRecordSet=oCn.execute(sSQL)
			SELECT CASE Err.Number
			CASE -2147217900 %>
				{
				success: false,
				message: 'Error: <%= REPLACE(REPLACE(REPLACE(Err.Description,"\","\\"),"'","\'"), "[Microsoft][ODBC SQL Server Driver][SQL Server]", "") %><% IF session("IdUsuario")=1 THEN response.write " \n\n"&REPLACE(REPLACE(sSQL,"\","\\"),"'","\'") %>'
				}
<%			response.end
			CASE 0
				'continue
			CASE ELSE %>
				{
				success: false,
				message: 'Error <%= Err.Number %>!, no se pudo recuperar la información. \nINFORMACIÓN TÉCNICA: <%= REPLACE(REPLACE(Err.Description,"\","\\"),"'","\'") %>.\n" <%'"&REPLACE(REPLACE(sSQL,"\","\\"),"'","\'") %>'
				}
<%				response.end
				Err.Clear
			END SELECT
		ON ERROR  GOTO 0
		'response.write rsRecordSet(0): response.end
		IF not(rsRecordSet.BOF AND rsRecordSet.EOF) THEN %>
		<% DIM oSiteMap:	set oSiteMap = Server.CreateObject("Microsoft.XMLDOM"): oSiteMap.Async = false: oSiteMap.LoadXML(rsRecordSet(0)) %>
		<% SET SESSION("UserSiteMap")=oSiteMap 
		END IF
	END IF
End If %>
<% IF Session("AccessGranted") THEN %>
	{
	success: true
	}
<% ELSE %>
	{
	success: false,
	message: 'Nombre de usuario o contraseña inválidos'
	}
<% END IF %>