<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:template name="dropDownList" match="*[@controlType='dropDownList']">
	<select>
		<xsl:attribute name="dataField"> <xsl:value-of select="name(ancestor-or-self::*[parent::dataRow][1])" /> </xsl:attribute>
		<xsl:attribute name="id"> <xsl:value-of select="ancestor::*[@nodeType='dataTable']/@id" />_<xsl:value-of select="ancestor::*[@nodeType='dataRow']/@id" /> </xsl:attribute>
		<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
		<xsl:attribute name="class"><xsl:value-of select="@cssClass" /></xsl:attribute>
		<option>
		20
		</option>
		<option selected="selected">
		<xsl:attribute name="value"><xsl:value-of select="value" /></xsl:attribute>
		<xsl:value-of select="value" />
		</option>
		<option>
		30
		</option>
	</select> 
</xsl:template>
</xsl:stylesheet>
