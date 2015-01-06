<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:template name="textArea" match="node()[@controlType='textArea' or @controlType='default' and (
@dataType='nvarchar' or @dataType='varchar' or @dataType='text') and (@length&gt;=256 or @length=-1 )
]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
xtype: 'textareafield'
, grow: true
, width: 400
, name: '<xsl:value-of select="$name"/>'
, value: '<xsl:value-of select="@text"/>'
<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	, readOnly: true
	</xsl:when>
<!-- EDITABLE -->
	<xsl:otherwise>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
