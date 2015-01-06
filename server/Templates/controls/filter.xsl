<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
  <xsl:strip-space elements="*"/>

  <xsl:template name="filter" match="/*[@mode='filters' or @mode='fieldselector']">
  	<!-- <xsl:attribute name="onkeydown">if (event.keyCode==13) { try {document.all('filterStringButton').focus(); document.all('filterStringButton').click(); } catch(e) {alert(e.description)}; }</xsl:attribute>
	<button id="filterStringButton" onclick="getFilterString()"><xsl:choose>
	<xsl:when test="ancestor-or-self::*[lang('en')]">Sort</xsl:when>
	<xsl:otherwise>Filtrar</xsl:otherwise>
</xsl:choose></button> -->
  	<xsl:apply-templates select="." mode="formView.Template"/>
  </xsl:template>
</xsl:stylesheet>