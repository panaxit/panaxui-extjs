<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="radioButtonList" match="*[@controlType='radioButtonList']">
<xsl:param name="separator" select="@separator"/>
	<xsl:for-each select="options/option">
		<xsl:call-template name="radioButton" />
		<xsl:value-of select="$separator" />
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
