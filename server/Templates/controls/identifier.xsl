<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="identifier" match="*[@controlType='identifier']">
	<xsl:variable name="dataRow" select="ancestor-or-self::dataRow"/>
	<xsl:variable name="table" select="$dataRow/../.."/>
	<input type="checkbox" id="identifier">
		<xsl:attribute name="value"><xsl:value-of select="$dataRow/@identity" /></xsl:attribute>
		<xsl:attribute name="name"><xsl:value-of select="$table/@primaryKey" /></xsl:attribute>
		<xsl:attribute name="otherFields"><xsl:choose><xsl:when test="@otherFields"><xsl:value-of select="@otherFields" disable-output-escaping="yes" /></xsl:when><xsl:otherwise>'<xsl:for-each select="../following-sibling::*[@mode='readonly']"><xsl:if test="position()>1">,</xsl:if><xsl:value-of select="name(.)"/>=<xsl:choose>
	<xsl:when test="*/@value=''">NULL</xsl:when>	
	<xsl:otherwise>\'<xsl:value-of select="*/@value"/>\'</xsl:otherwise>
</xsl:choose></xsl:for-each>'</xsl:otherwise>
</xsl:choose></xsl:attribute>
	</input>
</xsl:template>
</xsl:stylesheet>
