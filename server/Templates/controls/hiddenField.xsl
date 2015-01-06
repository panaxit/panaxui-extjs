<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="hiddenField" match="*[@controlType='hiddenField' or @mode='hidden' and @controlType='default']">
<xsl:param name="name" select="@Column_Name"/>
<xsl:param name="id" select="@id"/>
<xsl:param name="value" select="@value"/>
<xsl:param name="format" select="@format"/>
<xsl:param name="dataField"><xsl:value-of select="name(ancestor-or-self::*[parent::dataRow][1])" /></xsl:param>
<xsl:param name="isSubmitable" select="@isSubmitable"/>
<xsl:param name="mode" select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/>
<xsl:param name="syncElement"/>
<!-- READONLY --><!-- EDITABLE -->
xtype: 'hiddenfield',
name: '<xsl:value-of select="$name"/>',
value: '<xsl:value-of select="$value"/>'
</xsl:template>
</xsl:stylesheet>
