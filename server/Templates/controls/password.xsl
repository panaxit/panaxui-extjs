<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="password" match="node()[@controlType='password' or @controlType='default' and (
@dataType='varbinary'
)]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="@id"/>
<xsl:param name="value">
	<xsl:choose>
	<xsl:when test=".!=''"><xsl:value-of select="."/></xsl:when>	
	<xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
</xsl:choose>
</xsl:param>
<xsl:param name="mode" select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/>
xtype: 'passwordfield'
, name: '<xsl:value-of select="$name"/>'
, defaultValue: '<xsl:value-of select="@text"/>'
, enforceMaxLength: true
</xsl:template>
</xsl:stylesheet>
