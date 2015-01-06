<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:template mode="itemWidth" match="*[@dataType='foreignKey' and (@controlType='default' or @controlType='combobox' or @controlType='selectBox')]">300</xsl:template>
<xsl:template mode="itemHeight" match="*[@dataType='foreignKey' and (@controlType='default' or @controlType='combobox' or @controlType='selectBox')]"></xsl:template>

<xsl:template name="ForeignKey" match="*[@dataType='foreignKey' and (@controlType='default' or @controlType='combobox' or @controlType='selectBox')]">
	<xsl:param name="required"/>
	<xsl:param name="mode"/>
	<xsl:param name="scope" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
<xsl:param name="itemWidth"><xsl:apply-templates mode="itemWidth" select="."/></xsl:param>
<xsl:param name="itemHeight"><xsl:apply-templates mode="itemHeight" select="."/></xsl:param>
	xtype: "cascadeddropdown"
	, layout: 'anchor'
	, defaults: { hideLabel: true, anchor: 'none', flex: 0, <xsl:apply-templates select="." mode="field.items.defaultConfig"/> }
	<!-- , <xsl:apply-templates select="." mode="container.attributes"/> -->
	<xsl:if test="string($itemHeight)!=''">, height: <xsl:value-of select="$itemHeight"/></xsl:if>
	<xsl:if test="string($itemWidth)!=''">, width: <xsl:value-of select="$itemWidth"/></xsl:if>
	, items: [<xsl:apply-templates select="descendant::*[not(name(.)='px:data')]" mode="dataField"><xsl:sort select="position()" order="descending"/> </xsl:apply-templates>]
</xsl:template>

</xsl:stylesheet>
