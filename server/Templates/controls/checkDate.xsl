<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="checkDate" match="*[@controlType='checkDate']">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>

<xsl:param name="size" select="@length" />
<xsl:param name="format" select="@format"/>
<xsl:param name="mutuallyExclusiveGroup" select="@mutuallyExclusiveGroup"/>

<xsl:param name="valueOnCheck"><xsl:choose>
	<xsl:when test="$value!=''"><xsl:value-of select="$value"/></xsl:when>
	<xsl:otherwise>getdate()</xsl:otherwise>
</xsl:choose></xsl:param>

<xsl:param name="checked"><xsl:choose>
	<xsl:when test="$value!=''">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise>
</xsl:choose></xsl:param>

<xsl:variable name="class"><xsl:value-of select="$cssClass" /> <xsl:choose><xsl:when test="number($required)=1"> required </xsl:when><xsl:otherwise> notRequired </xsl:otherwise></xsl:choose> submitable </xsl:variable>

<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	<xsl:call-template name="hiddenField"/>
	<img width="15" height="15" border="1" tabIndex="-1">
	<xsl:attribute name="src">
		<xsl:choose>
			<xsl:when test="$checked='true'">../../../../Images/controls/checkbox/on.gif</xsl:when>		
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>			
	</xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="@text"/></xsl:attribute>
		</img>
	</xsl:when>
<!-- EDITABLE -->
	<xsl:otherwise>
		<xsl:variable name="formatedValue"><xsl:if test="@value"><xsl:value-of select="@value"/><xsl:value-of select="$nbsp"/><xsl:value-of select="*/@value"/></xsl:if></xsl:variable>
		<!-- <strong>value: <xsl:value-of select="@value"/></strong> -->
		<div>
			<input type="checkbox" class="checkbox" name="{$name}" value="{$valueOnCheck}">
				<xsl:if test="$mutuallyExclusiveGroup"><xsl:attribute name="mutuallyExclusiveGroup"><xsl:value-of select="$mutuallyExclusiveGroup"/></xsl:attribute></xsl:if>
				<xsl:if test="$checked='true'"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
			</input>
		</div>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
