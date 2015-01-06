<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">

<xsl:template mode="emptyText" match="*[@controlType='numericfield' or @controlType='default' and (
@dataType='tinyint'
or @dataType='int' or (@dataType='float' or @dataType='decimal') and not(@format) or @dataType='real'
)]" priority="-1">--</xsl:template>

<xsl:template mode="itemWidth" match="*[@controlType='default'][@dataType='tinyint']" priority="-1">50</xsl:template>

<xsl:template mode="itemWidth" match="*[@controlType='default'][@dataType='int' or (@dataType='float' or @dataType='decimal') or @dataType='real']" priority="-1">80</xsl:template>

<xsl:template match="*[@controlType='numericfield' or @controlType='default' and (
@dataType='tinyint'
or @dataType='int' or (@dataType='float' or @dataType='decimal') and not(@format) or @dataType='real'
)]" mode="field.minValue" priority="-1">0</xsl:template>
<xsl:template match="*[@controlType='numericfield' or @controlType='default' and (
@dataType='tinyint'
or @dataType='int' or (@dataType='float' or @dataType='decimal') and not(@format) or @dataType='real'
)]" mode="field.maxValue" priority="-1">99999999999</xsl:template>
<xsl:template match="*[@minValue]" mode="field.minValue" priority="-1"><xsl:value-of select="@minValue"/></xsl:template>
<xsl:template match="*[@maxValue]" mode="field.maxValue" priority="-1"><xsl:value-of select="@maxValue"/></xsl:template>

<xsl:template name="numberfield" match="*[@controlType='numericfield' or @controlType='default' and (
@dataType='tinyint'
or @dataType='int' or (@dataType='float' or @dataType='decimal') and not(@format) or @dataType='real'
)]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>
<xsl:param name="maxlength" select="@length"/>

<xsl:param name="size" select="@length" />
<xsl:param name="format"><xsl:choose>
	<xsl:when test="@format"><xsl:value-of select="@format"/></xsl:when>	
	<xsl:when test="@dataType='int' or @dataType='tinyint' or @dataType='float' and not(@format) or @dataType='real'">numero</xsl:when>
	<xsl:otherwise></xsl:otherwise>
</xsl:choose></xsl:param>
<!-- COMMON PROPERTIES -->
<xsl:variable name="control.attributeSet"><xsl:copy><xsl:apply-templates select="." mode="control.attributeSet" /></xsl:copy></xsl:variable>
<!-- <xsl:param name="onchange"/> -->
xtype: 'numberfield'
, name: '<xsl:value-of select="$name"/>'
, value: '<xsl:value-of select="@text"/>'
, maxValue: <xsl:apply-templates select="." mode="field.maxValue"/>
, minValue: <xsl:apply-templates select="." mode="field.minValue"/>
<xsl:if test="boolean(@allowNegatives)=false()">, minValue:0</xsl:if>

<xsl:if test="@dataType='float' or @dataType='decimal' or @dataType='real'">
, allowDecimals: true
, decimalPrecision: 2
, decimalSeparator: "."
</xsl:if>
<xsl:if test="@disableSpinner">, hideTrigger:true</xsl:if>
<xsl:if test="number(@step)&gt;0">, step: <xsl:value-of select="@step"/></xsl:if>
, listeners: {
	change: function(control, newValue, oldValue, eOptions){
		var handler = <xsl:apply-templates select="." mode="control.onchange"/>;
		<xsl:text disable-output-escaping="yes"><![CDATA[
		if (handler && handler(control, newValue, oldValue, eOptions)==false) ]]></xsl:text>{
			return true
		}
		else {
			
		}
	}
}
<!-- 
hideTrigger:true, -->
<xsl:choose>
	<xsl:when test="@dataType='tinyint'">
		,maxLength: 3
		,maxValue: <xsl:choose><xsl:when test="@maxValue&lt;255"><xsl:value-of select="@maxValue"/></xsl:when><xsl:otherwise>255</xsl:otherwise></xsl:choose>
		,minValue: 0
	</xsl:when>
	<xsl:when test="@dataType='int'">
		,maxLength: 6
	</xsl:when>
</xsl:choose>
	
<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	, readOnly: true
	</xsl:when>
<!-- EDITABLE -->
	<xsl:otherwise>
		<!-- <xsl:if test="$mode='filters'"><xsl:attribute name="filterOperator">LIKE</xsl:attribute></xsl:if><xsl:apply-templates select="." mode="control.attributeSet" /> -->
		<!-- <xsl:element name="input">
			<xsl:attribute name="type">text</xsl:attribute>
			<xsl:attribute name="style">width:<xsl:value-of select="@width"/>;</xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="$cssClass"/><xsl:value-of select="' '"/><xsl:value-of select="$format"/></xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$id" /> </xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$text" /></xsl:attribute>
			<xsl:copy-of select="msxsl:node-set($control.attributeSet)/*/@*" />
			<xsl:choose>
				<xsl:when test="@dataType='tinyint'">
					<xsl:attribute name="size">3</xsl:attribute>
					<xsl:attribute name="maxlength">3</xsl:attribute>
				</xsl:when>
				<xsl:when test="@dataType='int'">
					<xsl:attribute name="size">5</xsl:attribute>
					<xsl:attribute name="maxlength">5</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="size"><xsl:value-of select="$size" /></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@decimalPositions"><xsl:attribute name="decimalPositions"><xsl:value-of select="@decimalPositions"/></xsl:attribute></xsl:if>
			<xsl:attribute name="maxlength"><xsl:value-of select="$maxlength" /></xsl:attribute>
		</xsl:element> -->
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
