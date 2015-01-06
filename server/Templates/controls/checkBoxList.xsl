<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<xsl:for-each select="options/option"><input type="checkbox" name="{ancestor-or-self::options/@catalogName}" id="{@value}" value="{@value}" />&#160;<label for="{@value}"><xsl:value-of select="@text" disable-output-escaping="yes" /></label><br/><!-- <xsl:choose>
	<xsl:when test="(position() mod (count(ancestor-or-self::options/option) div 3))=0"><br/></xsl:when>	
	<xsl:otherwise>&#160;</xsl:otherwise>
</xsl:choose> -->
	</xsl:for-each>
	<xsl:for-each select="DEBUG/sqlQuery">
		alert('<xsl:value-of select="."/>')
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>