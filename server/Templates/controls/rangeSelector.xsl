<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="rangeSelector" match="*[@controlType='rangeSelector' or @controlType='RangeSelector'][1=0]">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>

xtype: 'slider',
name: '<xsl:value-of select="$name"/>',
width: 200,
<xsl:if test="$value">value: <xsl:value-of select="$value"/>,</xsl:if>

minValue: 0,
maxValue: 5
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

<xsl:template name="rangeSelectorElements">
      <xsl:param name="start" select="1"/>
      <xsl:param name="elements" select="0"/>
	  <xsl:param name="mode" select="'readonly'"/>
      <xsl:if test="$elements >= $start">
        <img width="22" height="20" src="../../../../Images/Buttons/FilledStar.png">
		<xsl:choose>
			<xsl:when test="$mode='readonly'">
				<xsl:attribute name="style">cursor:default</xsl:attribute>
				<xsl:if test="not($start&lt;=@value)">
					<xsl:attribute name="src">../../../../Images/Buttons/EmptyStar.png</xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">imageButton</xsl:attribute>
				<xsl:if test="$start&lt;=@value">
					<xsl:attribute name="enabled">true</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="alt"><xsl:value-of select="$start" /></xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$start" /></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		</img>
        <xsl:call-template name="rangeSelectorElements">
          <xsl:with-param name="start" select="$start + 1"/>
          <xsl:with-param name="elements" select="$elements"/>
		  <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>
      </xsl:if>
</xsl:template>
</xsl:stylesheet>
