<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:template mode="itemWidth" match="*[@controlType='timeBox'
or @controlType='default' and (@dataType='time')
]" priority="-1">100</xsl:template>

<xsl:template name="timeBox" match="*[@controlType='timeBox'
or @controlType='default' and (@dataType='time')]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
xtype: 'timepicker'
<xsl:choose>
<!-- READONLY -->
<xsl:when test="$mode='readonly'">
,readOnly: true, hideTrigger: true
</xsl:when>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
