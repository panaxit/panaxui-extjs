<!--#include file="../Scripts/IncludesAll.asp"-->
<%
Response.Charset="UTF-8"
'ON ERROR  RESUME NEXT
DIM xmlDoc
Set xmlDoc=Server.CreateObject("Microsoft.XMLDOM")
xmlDoc.async="false"
xmlDoc.load(Request)
'Response.ContentType = "text/xml" 
%>
<% IF NOT Session("AccessGranted") THEN %>
{
	success: false,
	message: "TIENE QUE HACER LOGIN"
}
<% RESPONSE.END %>
<% END IF %>
{
success: true,
xmlData: '<%= REPLACE(REPLACE(REPLACE(URLDecode(xmlDoc.xml), "&", "&amp;"), "'", "\'"),vbcrlf,"")  %>'
}