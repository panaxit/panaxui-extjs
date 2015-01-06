<%@ Language=VBScript %>
<!--#include file="../Scripts/Classes/axe.asp"-->
<% Response.Charset="ISO-8859-1" %>
<!--#include file="../Scripts/vbscript.asp"-->
<!--#include file="../Custom/Scripts/vbscript.asp"-->
<!--#include file="../Scripts/Classes/StopWatch.asp"-->
<!--#include file="../Scripts/Classes/ArrayList.asp"-->
<!--#include file="../Scripts/Classes/FileTranslator.asp"-->
<!--#include file="../Scripts/Classes/MailMessage.asp"-->
<!--#include file="../Scripts/Classes/DataSource.asp"-->
<!--#include file="../Scripts/Classes/Panax.asp"-->
<!--#include file="../Scripts/Classes/UTF8.asp"-->
<!--#include file="../Scripts/Classes/json.asp"-->
<% 
DIM [#bAtRoot]:	[#bAtRoot]=(REPLACE(Server.MapPath("."), application("PhysicalRootFolder"), "")="")
DIM [#sPath]
IF NOT[#bAtRoot] THEN [#sPath]="../" ELSE [#sPath]=""
%>