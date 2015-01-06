<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str"
>
<xsl:output method="text" omit-xml-declaration="yes"/> 
<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function escapeQuotes(sText){ var sNewText=sText; return sNewText.replace(/\"/gi, '\\"');}
]]>
</msxsl:script>
<xsl:template match="/">
<xsl:choose>
	<xsl:when test="count(options/option)=0">
		options[length]=new Option("No hay opciones", "NULL"); 
		options[length-1].style.color='red';
	</xsl:when>
	<xsl:otherwise>
		<xsl:if test="(string(/options/@allowNulls)='true' or string(/options/@value)='') and string(/options/@searchText)=''">options[length]=new Option("", ""); options[length-1].selected=true;</xsl:if>
		<xsl:for-each select="options/option">
			<xsl:variable name="texto" select="@text"/>
			options[length]=new Option("<xsl:choose><xsl:when test="@text=''">(Sin texto)</xsl:when><xsl:otherwise><xsl:value-of select="str:escapeQuotes(string(@text))" disable-output-escaping="yes" /></xsl:otherwise>
</xsl:choose>", "<xsl:value-of select="@value" disable-output-escaping="yes" />"); 
			<xsl:if test="@color!=''">options[length-1].style.color='<xsl:value-of select="@color" />';</xsl:if>
			<xsl:if test="@className!=''">options[length-1].className='<xsl:value-of select="@className" />';</xsl:if>
			options[length-1].id='opt_<xsl:value-of select="@value"/>';
			<xsl:if test="string(@value)=string(/options/@value)">options[length-1].selected=true;</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="DEBUG/sqlQuery">
			alert('<xsl:value-of select="."/>')
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>