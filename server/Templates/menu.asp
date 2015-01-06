<!--#include file="../Scripts/IncludesAll.asp"-->
<% SERVER.SCRIPTTIMEOUT = 4800 %>
<% 
DIM oCn:	set oCn=server.createobject("adodb.connection")
oCn.open SESSION("StrCnn")
oCn.CommandTimeout = 120 

DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
rsRecordSet.CursorLocation 	= 3
rsRecordSet.CursorType 		= 3

IF SESSION("UserSiteMap") is nothing THEN
	ON ERROR RESUME NEXT
		DIM sSQL:	sSQL="[$Security].UserSitemap @@IdUser="&SESSION("IdUsuario")
		IF session("lang")<>"" THEN sSQL = sSQL&", @lang="&session("lang") END IF
		set rsRecordSet=oCn.execute(sSQL)
		SELECT CASE Err.Number
		CASE -2147217900 %>
			{
			success: false,
			message: "Error: <%= REPLACE(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]", "") %><% IF session("IdUsuario")=1 THEN response.write " \n\n"&sSQL %>"
			}
<%			CASE 0
			'continue
		CASE ELSE %>
			{
			success: false,
			message: "Error <%= Err.Number %>!, no se pudo recuperar la información.<% IF session("IdUsuario")=1 THEN response.write Err.Description&" <br><br>"&sSQL %>"
			}
<%				response.end
			Err.Clear
		END SELECT
	ON ERROR  GOTO 0
	'response.write rsRecordSet(0): response.end
	 %>
	<% DIM oSiteMap:	set oSiteMap = Server.CreateObject("Microsoft.XMLDOM"): oSiteMap.Async = false: oSiteMap.LoadXML(rsRecordSet(0)) %>
	<% SET SESSION("UserSiteMap")=oSiteMap 
END IF %>
<%= transformXML(SESSION("UserSiteMap"), server.MapPath("..\templates\mapSite.xsl")) %>
<% oCn.close %>
<% SET rsRecordSet = NOTHING %>
<% SET oCn = NOTHING %>
