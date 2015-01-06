<!--#include file="../Scripts/IncludesAll.asp"-->
<% SERVER.SCRIPTTIMEOUT = 4800 %>
<html>
<head>
</HEAD>
<BODY>
<% ON ERROR RESUME NEXT
DIM tag: tag=request.querystring("tag"):' IF tag="" THEN tag="document" END IF
DIM oXMLSource:	SET oXMLSource=XMLReader(server.MapPath("..\Scripts\contextMenu.xml")).documentElement.selectSingleNode("/contextMenus/contextMenu[@for='"&tag&"']") %>
<% IF oXMLSource IS NOTHING THEN SET oXMLSource=XMLReader(server.MapPath("..\Custom\Scripts\contextMenu.xml")).documentElement.selectSingleNode("/contextMenus/contextMenu[@for='"&tag&"']") END IF %>
<%= transformXML(oXMLSource, server.MapPath("..\templates\contextMenu.xsl")) %>
</BODY>
</HTML>