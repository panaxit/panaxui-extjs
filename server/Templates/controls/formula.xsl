<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="formula" match="*[@controlType='formula' or @controlType='default' and @formula]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
<xsl:param name="isSubmitable" select="@isSubmitable"/>

<xsl:param name="formula" select="@formula"/>
<xsl:param name="format" select="@format"/>
xtype: "displayfield",
renderer: <xsl:apply-templates select="." mode="control.renderer"/>
</xsl:template>
</xsl:stylesheet>
