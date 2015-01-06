<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template match="*[@template]">
	<xsl:call-template name="translateTemplate">
		<xsl:with-param name="nodes" select="*"/>
		<xsl:with-param name="inputString" select="@template"/>
	</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
