<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>


<xsl:template name="selectPager">
	<xsl:param name="for" />
	<div class="selectPager">
	 <img class="imageButton" src="..\Images\Buttons\btn_LArrow.png" width="20" height="20" enabled="true" oncontextmenu="return false;">
		<xsl:attribute name="onclick">jumpToPage(<xsl:value-of select="number(ancestor-or-self::dataRow/../../@pageIndex)-1"/>)</xsl:attribute>
	</img>
	<xsl:value-of select="$nbsp"/>
		<strong>
		Página: / <xsl:value-of select="ceiling(number(ancestor-or-self::dataRow/../../@totalRecords) div number(ancestor-or-self::dataRow/../../@pageSize))"/>
	 	</strong>
	 <xsl:value-of select="$space"/>
	 <img class="imageButton" src="..\imagenes\Buttons\btn_RArrow.png" width="20" height="20" enabled="true" oncontextmenu="return false;">
		<xsl:attribute name="onclick">jumpToPage(<xsl:value-of select="number(ancestor-or-self::dataRow/../../@pageIndex)+1"/>)</xsl:attribute>
	</img>

	</div>
</xsl:template>

</xsl:stylesheet>