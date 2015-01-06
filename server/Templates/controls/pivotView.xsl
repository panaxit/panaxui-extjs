<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:math="http://exslt.org/math"
	xmlns:exsl="http://exslt.org/functions"
	xmlns:set="http://exslt.org/sets"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	extension-element-prefixes="math exsl"
	exclude-result-prefixes="set"
	> 

<xsl:template match="*[@dataType='table'][@controlType='pivotView']">
	<xsl:param name="rowField">OriginId</xsl:param>
	<xsl:param name="pivotField">TransportId</xsl:param>
	<xsl:param name="valueField">Kilometers</xsl:param>
	<xsl:variable name="document" select="current()"/>
	pivot view
</xsl:template>

</xsl:stylesheet>