<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:math="http://exslt.org/math"
	xmlns:exsl="http://exslt.org/functions"
	xmlns:set="http://exslt.org/sets"
	extension-element-prefixes="math exsl"
	exclude-result-prefixes="set"
	> 
<xsl:key name="fields" match="//fields/_x0024_CatalogName" use="@text"/>
<!-- <xsl:key name="data" match="//data[1]/dataRow[_x0024_IdPerfil/@value=-1]" use="_x0024_CatalogName/@value"/> -->
<xsl:variable name="data" select="//data[1]/dataRow"/><!-- //data[1]/dataRow[_x0024_IdProfile/@value=-1] -->

<xsl:template match="ProfilePrivileges[@Table_Schema='$Security'][layout]">
	<span class="dataTable siteMapTree" ondblclick="showModal(escapeHTML(createUpdateXML()));">
		<xsl:attribute name="id"><xsl:value-of select="@Table_Name"/>_<xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:if test="ancestor-or-self::*[@dataType='table'][2]"><xsl:attribute name="primary_table"><xsl:value-of select="ancestor-or-self::*[@dataType='table'][2]/@Table_Name"/>_<xsl:value-of select="generate-id(ancestor-or-self::*[@dataType='table'][2])"/></xsl:attribute></xsl:if>
		<xsl:attribute name="db_table_name"><xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/></xsl:attribute>
		<xsl:attribute name="db_identity_key"><xsl:value-of select="@identityKey"/></xsl:attribute>
		<xsl:attribute name="db_primary_key"><xsl:value-of select="@primaryKey"/></xsl:attribute>
		<xsl:if test="@foreignReference!=''"><xsl:attribute name="db_foreign_key"><xsl:value-of select="@foreignReference"/></xsl:attribute></xsl:if>
		<xsl:apply-templates select="layout/siteMap" />
	</span>
</xsl:template>

<xsl:template match="siteMap">
	<label class="title">PERFIL: <xsl:value-of select="$data/_x0024_Profile/@text"/></label>
<br/>
	<xsl:apply-templates select="*" />
	<div id="Output"></div>
</xsl:template>

<xsl:template match="siteMapNode" priority="-1">
	
	<!-- <xsl:call-template name="checkbox"><xsl:with-param name="mode" select="'inherit'"/></xsl:call-template> -->
	<xsl:variable name="siteMapNode" select="."/>
	<xsl:element name="label">
		<xsl:attribute name="style">margin-left:<xsl:value-of select=".75*count(ancestor::siteMapNode)"/>cm;</xsl:attribute>
	</xsl:element>
	<xsl:for-each select="$data[(concat(_x0024_SchemaName/@value,'.',_x0024_CatalogName/@value)=current()/@catalogName) or (concat(_x0024_SchemaName/@value,'.',_x0024_CatalogName/@value)=concat('dbo.',current()/@catalogName))]">
	<span>
		<xsl:attribute name="id"><xsl:value-of select="ancestor::*[@dataType='table'][1]/@Table_Name"/>_<xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:attribute name="db_identity_value"><xsl:choose><xsl:when test="@identity!=''"><xsl:value-of select="@identity"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:attribute name="db_primary_value"><xsl:choose><xsl:when test="@primaryValue!=''"><xsl:value-of select="@primaryValue"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
	<!-- <xsl:for-each select="key('data', @catalogName)/*[@dataType='bit']"><xsl:apply-templates select="." mode="dataField" /></xsl:for-each>	 -->
		<xsl:apply-templates select="_x0024_IdProfile|_x0024_SchemaName|_x0024_CatalogName" mode="dataField" />
		<xsl:for-each select="*[@dataType='bit']"><xsl:if test="not($siteMapNode/@mode) and current()/@Column_Name='$D' or $siteMapNode/@mode='insert' and current()/@Column_Name='$A' or $siteMapNode/@mode='edit' and current()/@Column_Name='$C' or $siteMapNode/@mode='readonly' and current()/@Column_Name='$D'"><xsl:value-of select="$nbsp"/><xsl:apply-templates select="." mode="dataField" /></xsl:if></xsl:for-each>
		
	</span>
	</xsl:for-each>
	<xsl:value-of select="$nbsp"/><xsl:element name="label">
		<xsl:attribute name="class">h<xsl:value-of select="count(ancestor-or-self::siteMapNode)"/><xsl:value-of select="' '"/><xsl:choose><xsl:when test="@catalogName">node</xsl:when><xsl:otherwise>folder</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:value-of select="$space"/><xsl:value-of select="@title"/>
	</xsl:element>	
	<br/>
	<xsl:apply-templates select="siteMapNode" />
</xsl:template>


</xsl:stylesheet>