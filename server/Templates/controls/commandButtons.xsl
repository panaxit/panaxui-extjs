<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template match="fields[not(ancestor-or-self::*[@mode='filters'])]" mode="insertButton">
  <xsl:element name="img" use-attribute-sets="commandButtons.insert">
		<xsl:attribute name="parameters"><xsl:for-each select="*[@mode='static']"><xsl:if test="position()>1">,</xsl:if>@#<xsl:value-of select="name(.)"/>=<xsl:value-of select="*/@value"/></xsl:for-each></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match="data/dataRow[not(ancestor-or-self::*[@mode='filters'])][@identity]" mode="editButton">
	<xsl:element name="img" use-attribute-sets="commandButtons.edit">
		<xsl:attribute name="filter"><xsl:value-of select="ancestor-or-self::*[@dataType='table'][1]/@identityKey"/>=<xsl:value-of select="ancestor-or-self::dataRow[1]/@identity"/></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match="data/dataRow[not(ancestor-or-self::*[@mode='filters'])][not(ancestor-or-self::*[@dataType='table'][2][@controlType='gridView'])]" mode="deleteButton">
	<xsl:element name="img" use-attribute-sets="commandButtons.delete">
		<xsl:attribute name="primaryKey"><xsl:value-of select="ancestor-or-self::*[@dataType='table'][1]/@identityKey"/></xsl:attribute>
		<xsl:attribute name="identityValue"><xsl:choose>
			<xsl:when test="ancestor-or-self::dataRow[1]/@identity!=''"><xsl:value-of select="ancestor-or-self::dataRow[1]/@identity"/></xsl:when>	
			<xsl:otherwise>NULL</xsl:otherwise>
		</xsl:choose></xsl:attribute>
	</xsl:element>
</xsl:template>
</xsl:stylesheet>
