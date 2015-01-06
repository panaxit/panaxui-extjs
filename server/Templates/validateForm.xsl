<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:set="http://exslt.org/sets"
	extension-element-prefixes="msxsl"
	exclude-result-prefixes="set">
<xsl:output method="text" omit-xml-declaration="yes"/> 

<xsl:template match="/">
	<xsl:apply-templates select="*"/>
	<xsl:for-each select="//*[@hasError='true']">
	$('#<xsl:value-of select="@sourceObjectId"/>').addClass("error");
	</xsl:for-each>
</xsl:template>

<xsl:template match="dataTable">
	<xsl:for-each select="dataRow">
		<xsl:variable name="table" select="ancestor-or-self::dataTable[1]"/>
		<xsl:variable name="parentTable" select="$table/../ancestor-or-self::dataTable[1]"/>

		<xsl:choose>
			<xsl:when test="@identityValue='NULL'">
				<xsl:choose>
					<xsl:when test="dataField">
					<xsl:apply-templates select="dataTable"/>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="dataField"></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>