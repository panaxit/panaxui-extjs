<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<xsl:for-each select="options/option">
		options[length]=new Option("<xsl:value-of select="@text" disable-output-escaping="yes" />", "<xsl:value-of select="@value" disable-output-escaping="yes" />"); 
		<xsl:if test="@color!=''">options[length-1].style.color='<xsl:value-of select="@color" />';</xsl:if>
		<xsl:if test="@className!=''">options[length-1].className='<xsl:value-of select="@className" />';</xsl:if>
		options[length-1].id='opt_<xsl:value-of select="@value"/>';
		<xsl:if test="not(preceding-sibling::*[@value!='NULL'] or following-sibling::*[@value!='NULL'])">options[length-1].selected=true;</xsl:if>
	</xsl:for-each>
	<xsl:for-each select="DEBUG/sqlQuery">
		alert('<xsl:value-of select="."/>')
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>