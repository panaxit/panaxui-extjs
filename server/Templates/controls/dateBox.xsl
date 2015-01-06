<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:template mode="itemWidth" match="*[(@controlType='dateBox'
or @controlType='default' and (@dataType='date' or @dataType='datetime' or @dataType='smalldatetime'))
]" priority="-1">100</xsl:template>
<xsl:template mode="itemWidth" match="*[@dataType='datetime']" priority="-1">220</xsl:template>

<xsl:template name="dateBox" match="*[(@controlType='dateBox'
or @controlType='default' and (@dataType='date' or @dataType='datetime' or @dataType='smalldatetime'))
]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
xtype: '<xsl:choose><xsl:when test="@dataType='datetime'">datetimefield</xsl:when><xsl:otherwise>datefield</xsl:otherwise></xsl:choose>'
<xsl:choose>
<!-- READONLY -->
<xsl:when test="$mode='readonly'">
,readOnly: true, hideTrigger: true
</xsl:when>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
