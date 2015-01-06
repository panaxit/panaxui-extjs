<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="radioButton" match="*[@controlType='radioButton']">
	<input type="radio">
		<xsl:attribute name="dataField"> <xsl:value-of select="name(ancestor-or-self::*[parent::dataRow][1])" /> </xsl:attribute>
		<xsl:attribute name="id"> <xsl:value-of select="ancestor::dataTable/@tableName" />_<xsl:value-of select="ancestor::*[@nodeType='dataRow']/@id" /> </xsl:attribute>
		<xsl:attribute name="name"> <xsl:value-of select="name(ancestor::*[@nodeType='dataTable'])" />_<xsl:value-of select="ancestor::*[@nodeType='dataRow']/@id" /> </xsl:attribute>
		<xsl:attribute name="value"> <xsl:value-of select="@value" /> </xsl:attribute>
		<xsl:if test="ancestor::*[@controlType='radioButtonList']/@value=@value">
			<xsl:attribute name="checked"> <xsl:value-of select="checked" /> </xsl:attribute>
		</xsl:if>
	</input><xsl:value-of select="@text" />
</xsl:template>
</xsl:stylesheet>
