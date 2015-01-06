<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str">

<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function replace(str, sSearch, sReplace){ return str.replace(sSearch, sReplace);}
]]>
</msxsl:script>

</xsl:stylesheet>