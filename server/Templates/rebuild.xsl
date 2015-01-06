<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	>

<xsl:import href="html/global_variables.xsl" />
<xsl:import href="stylesheets.xsl" />
<xsl:import href="html/list.controls.xsl" />
<xsl:import href="customStylesheets.xsl" />

<xsl:template name="none" match="*[@mode='none']"><!-- ancestor-or-self::*[@mode!='inherit'][1]/@mode='readonly' or  -->
	<xsl:value-of select="$nbsp"/>
</xsl:template>

<xsl:template name="pageManager" match="/">
<xsl:apply-templates select="*" />
</xsl:template>
</xsl:stylesheet>