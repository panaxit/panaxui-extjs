<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="tableExpander" match="*[@dataType='foreignTable' and @controlType='default' or @controlType='tableExpander']">
	<xsl:if test="ancestor-or-self::dataRow[1]/@identity">
		<img class="Button Expander" tabIndex="0" src="../../../../Images/Buttons/expand.jpg" width="15" height="15" enabled="true" oncontextmenu="Expander_oncontextmenu(); return false;" onkeydown="Expander_onkeydown()" onclick="Expander_onclick()" style="cursor:hand; background-color:lightgoldenrodyellow;">
			<xsl:attribute name="alt"><xsl:value-of select="@text"/></xsl:attribute>
		</img>
		
		<div class="tableLoader" style="display:none; behavior:url('../Scripts/Behaviors/tableLoader.htc');">
		<xsl:attribute name="fullPath"><xsl:value-of select="/*/@fullPath"/>[<xsl:value-of select="name(/*)"/>][<xsl:value-of select="name(.)"/>](<xsl:value-of select="/*/@controlType"/>:<xsl:value-of select="/*/@mode"/>)</xsl:attribute>
		<xsl:attribute name="catalogName"><xsl:value-of select="name(.)"/></xsl:attribute>
		<xsl:attribute name="viewMode">gridView</xsl:attribute>
		<xsl:attribute name="mode"><xsl:value-of select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/></xsl:attribute>
		<xsl:attribute name="filter">{<xsl:value-of select="@foreignReference"/>}=<xsl:choose>
			<xsl:when test="ancestor-or-self::dataRow/@identity!=''"><xsl:value-of select="ancestor-or-self::dataRow/@identity"/></xsl:when>	
			<xsl:otherwise>NULL</xsl:otherwise>
		</xsl:choose></xsl:attribute>
		<xsl:attribute name="parameters">@#<xsl:value-of select="@foreignReference"/>=<xsl:choose>
			<xsl:when test="ancestor-or-self::dataRow/@identity!=''"><xsl:value-of select="ancestor-or-self::dataRow/@identity"/></xsl:when>	
			<xsl:otherwise>NULL</xsl:otherwise>
		</xsl:choose></xsl:attribute>
			<b>Cargando...</b>
		</div>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
