<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="yesNo" match="*[@dataType='bit' and (number(@isNullable)=1 or ancestor-or-self::*[@mode='filters']) or @controlType='yesNo']">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>

xtype: 'datefield',
name: '<xsl:value-of select="$name"/>',
value: '<xsl:value-of select="$text"/>',
width: 100, 
format: 'd/m/Y',
maxValue: new Date(),
    handler: function(picker, date) {
    },
<xsl:choose>
	<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	readOnly: true,
<!-- 	<img width="15" height="15" border="1" tabIndex="-1">
		<xsl:attribute name="src">
			<xsl:choose>
				<xsl:when test="@value=1">../../../../Images/controls/checkbox/on.gif</xsl:when>
				<xsl:when test="@value=0">../../../../Images/controls/checkbox/off.gif</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>			
		</xsl:attribute>
		<xsl:attribute name="alt"><xsl:value-of select="@text"/></xsl:attribute>
	</img> -->
	</xsl:when>
	<!-- EDITABLE -->
	<xsl:otherwise>
<!-- 		<select>
			<xsl:attribute name="id"><xsl:value-of select="$id" /> </xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="concat($cssClass,' ',string(@cssClass))"/></xsl:attribute>
			<option value="NULL">- -</option>
			<option value="1">
			<xsl:if test="$value=1"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>
			Sí
			</option>
			<option value="0">
			<xsl:if test="$value=0"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>
			No
			</option>
		</select>  -->
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
