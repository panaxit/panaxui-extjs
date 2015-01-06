<%@ Language=VBScript %>
<% Response.Charset="ISO-8859-1" %>
<!-- #include file="..\UIClasses\UIClasses.asp" -->
<!-- #include file="..\Generic_Code\Classes\Classes.asp" -->
<!-- #include file="..\Generic_Code\funciones_vbscript.asp" -->
<% 
DIM [#bAtRoot]:	[#bAtRoot]=(REPLACE(Server.MapPath("."), application("PhysicalRootFolder"), "")="")
DIM [#sPath]
IF NOT[#bAtRoot] THEN [#sPath]="..\" ELSE [#sPath]=""

DIM cn
Set cn = Server.CreateObject("ADODB.Connection")
cn.ConnectionTimeout = 0
cn.CommandTimeout = 0
cn.Open SESSION("StrCnn")
%>