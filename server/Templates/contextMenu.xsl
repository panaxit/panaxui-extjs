<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>

<xsl:import href="html.xsl" />
<xsl:import href="attributeSets.xsl" />
<xsl:include href="../custom/templates/mapSite.xsl" /> 
<xsl:output method="html" omit-xml-declaration="yes"/> 

<xsl:template match="/">
</xsl:template>

<xsl:template match="contextMenu" priority="-1">
<table oncontextmenu="javascript: return false;" class="contextMenu" width="600"><xsl:apply-templates select="*" /></table>
</xsl:template>

<xsl:template match="option" priority="-1">
<xsl:element name="tr">
	<xsl:attribute name="onmouseover">with (window.parent) {$(this).addClass('mouseover').siblings('.option').removeClass('mouseover')}</xsl:attribute>
	<xsl:attribute name="onmouseout">with (window.parent) {$(this).siblings('.option').andSelf().removeClass('mouseover')}</xsl:attribute>
	<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
	<xsl:attribute name="class">option <xsl:value-of select="@class"/></xsl:attribute>
	<xsl:attribute name="onclick">with (window.parent) {<xsl:value-of select="script"/>}; with (window.parent) {contextmenu.hide();}
</xsl:attribute>
	<xsl:element name="td">
		<xsl:attribute name="width">600</xsl:attribute>
		<xsl:attribute name="nowrap">nowrap</xsl:attribute>
		<xsl:value-of select="$nbsp"/><nobr><img src="../../../../{@source}" WIDTH="20" HEIGHT="20" BORDER="0" HSPACE="0" VSPACE="0" ALIGN="absmiddle"/><span class="legend"><xsl:value-of select="@legend"/><xsl:value-of select="$nbsp"/></span></nobr>
	</xsl:element>
</xsl:element>
</xsl:template>

</xsl:stylesheet>
