<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:import href="../html.xsl"/>
<xsl:strip-space elements="*"/>

<xsl:template match="*[@controlType='fileTemplate']">
	<span class="dataTable">
		<xsl:attribute name="id"><xsl:value-of select="@Table_Name"/>_<xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:if test="ancestor-or-self::*[@dataType='table'][2]"><xsl:attribute name="primary_table"><xsl:value-of select="ancestor-or-self::*[@dataType='table'][2]/@Table_Name"/>_<xsl:value-of select="generate-id(ancestor-or-self::*[@dataType='table'][2])"/></xsl:attribute></xsl:if>
		<xsl:attribute name="db_table_name"><xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/></xsl:attribute>
		<xsl:attribute name="db_primary_key"><xsl:value-of select="@primaryKey"/></xsl:attribute>
		<xsl:attribute name="db_identity_key"><xsl:value-of select="@identityKey"/></xsl:attribute>
		<xsl:attribute name="db_identity_value"><xsl:choose><xsl:when test="data/dataRow/@identity!=''"><xsl:value-of select="data/dataRow/@identity"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:attribute name="db_identity_value"><xsl:choose><xsl:when test="@identity!=''"><xsl:value-of select="@identity"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:attribute name="db_primary_value"><xsl:choose><xsl:when test="@primaryValue!=''"><xsl:value-of select="@primaryValue"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:apply-templates select="." mode="control.attributeSet"/>
		@@CONTENT<div id="Output"></div>
	</span>
</xsl:template>

<xsl:template match="*[@controlType='fileTemplate']/data/dataRow[@use]">
	<xsl:apply-templates select="*[@Column_Name=current()/@use]" mode="dataField" />
</xsl:template>

</xsl:stylesheet>