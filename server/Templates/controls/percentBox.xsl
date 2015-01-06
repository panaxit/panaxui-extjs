<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="percentBox" match="*[@dataType='float' and (@format='Percent' or @format='percent')]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
	<xsl:call-template name="textBox">
		<xsl:with-param name="name" select="$name"/>
		<xsl:with-param name="id" select="$id"/>
		<xsl:with-param name="text"><xsl:call-template name="formatPercent"><xsl:with-param name="percent" select="$text"/></xsl:call-template></xsl:with-param>
		<xsl:with-param name="size">7</xsl:with-param>
		<xsl:with-param name="cssClass">percent</xsl:with-param>
		<xsl:with-param name="required" select="$required"/>
		<xsl:with-param name="mode" select="$mode"/>
	</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
