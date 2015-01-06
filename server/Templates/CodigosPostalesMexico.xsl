<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:set="http://exslt.org/sets"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str"
	exclude-result-prefixes="set"
>
<xsl:import href="functions.xsl" /> 
<xsl:output method="html" omit-xml-declaration="yes"/> 
<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function escapeQuotes(sText){ var sNewText=sText; return sNewText.replace(/\"/gi, '\\"');}
]]>
</msxsl:script>
<xsl:template match="/">
	<!-- <xsl:value-of select="name(*/*[3])"/> - 
	<xsl:value-of select="count(*/*[3])"/> -
	<xsl:value-of select="name(*/*[*[local-name()='d_codigo'][.='78170']])"/>: <xsl:value-of select="*/*/*[local-name()='d_codigo'][.='78170']"/><br/> -->
	
<!-- 	<xsl:for-each select="*/*[not(*[local-name()='D_mnpio']=preceding-sibling::*/*[local-name()='D_mnpio'])]">
		<xsl:value-of select="*[local-name()='D_mnpio']"/><br/>
	</xsl:for-each><br/><br/> -->
	Municipios:
	<xsl:variable name="Municipios"><xsl:call-template name="set:distinct">
   	<xsl:with-param name="nodes" select="*/*[*[local-name()='d_codigo'][.='78170']]/*[local-name()='d_asenta']" />
</xsl:call-template></xsl:variable>
		<strong><xsl:for-each select="msxsl:node-set($Municipios)/*"><xsl:sort select="."/><xsl:value-of select="."/><br/></xsl:for-each>
<!-- <xsl:call-template name="join"><xsl:with-param name="nodes" select="msxsl:node-set($Municipios)/*"/><xsl:with-param name="separator" select="', '"/></xsl:call-template> --></strong><br/>
	<!-- <xsl:apply-templates select="*/*[*[local-name()='D_mnpio'][.='San Luis Potosí']]"/> --><!-- */*[*[local-name()='d_codigo'][.='78170']] -->
</xsl:template>

<xsl:template match="*[local-name()='table']">
	<xsl:for-each select="*">
		<xsl:value-of select="name(.)"/>: <xsl:value-of select="."/><br/>
	</xsl:for-each><br/><br/>


</xsl:template>

</xsl:stylesheet>