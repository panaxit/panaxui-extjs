<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template match="*[@controlType='rangeSelector' or @controlType='RangeSelector']" mode="field.minValue" priority="-1">1</xsl:template>
<xsl:template match="*[@controlType='rangeSelector' or @controlType='RangeSelector']" mode="field.maxValue" priority="-1">5</xsl:template>
<xsl:template match="*[@minValue]" mode="field.minValue" priority="-1"><xsl:value-of select="@minValue"/></xsl:template>
<xsl:template match="*[@maxValue]" mode="field.maxValue" priority="-1"><xsl:value-of select="@maxValue"/></xsl:template>

<xsl:template name="starrating" match="*[@controlType='rangeSelector' or @controlType='RangeSelector']">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
xtype: 'starrating'
// Arrange checkboxes into two columns, distributed vertically
<!-- columns: 2,
vertical: true, -->
<!-- , width: 120 -->
, canReset: true
, maxValue: <xsl:apply-templates select="." mode="field.maxValue"/>
, minValue: <xsl:apply-templates select="." mode="field.minValue"/>

<!-- , items: [
	{ title: '1', name: '<xsl:value-of select="$name"/>', value: 1<xsl:if test="$value=1">, checked: true</xsl:if> }
    , { title: '2', name: '<xsl:value-of select="$name"/>', value: 2<xsl:if test="$value=2">, checked: true</xsl:if> }
    , { title: '3', name: '<xsl:value-of select="$name"/>', value: 3<xsl:if test="$value=3">, checked: true</xsl:if> }
    , { title: '4', name: '<xsl:value-of select="$name"/>', value: 4<xsl:if test="$value=4">, checked: true</xsl:if> }
    , { title: '5', name: '<xsl:value-of select="$name"/>', value: 5<xsl:if test="$value=5">, checked: true</xsl:if> }
] -->
<!-- text: 'Rating',
width: 70,
renderer: function(rating) {
    return Array(Math.ceil(rating) + 1).join('&#x272D;');
} -->
<!-- 	<span>
		<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
		<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
		<xsl:attribute name="value"> <xsl:value-of select="$value" /> </xsl:attribute>
		<xsl:choose>
			<xsl:when test="$mode='readonly'">
				<xsl:attribute name="readonly">true</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">rangeSelector <xsl:value-of select="concat($cssClass,' ',string(@cssClass))"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<nobr>
		<xsl:call-template name="rangeSelectorElements">
    	  	<xsl:with-param name="elements" select="5"/>
			<xsl:with-param name="mode" select="$mode"/>
	    </xsl:call-template>
		</nobr>
	</span> -->
</xsl:template>

</xsl:stylesheet>
