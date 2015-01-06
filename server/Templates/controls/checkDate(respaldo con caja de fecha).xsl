<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    extension-element-prefixes="date"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:import href="../EXSLT/date/date.xsl" />
<xsl:strip-space elements="*"/>

<xsl:template name="checkDate" match="*[@controlType='checkDate']">
<xsl:param name="dataField" select="name(ancestor-or-self::*[parent::dataRow][1])"/>
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="name(.)"/>
<xsl:param name="text">
<xsl:choose>
	<xsl:when test="@showText='true'"><xsl:value-of select="@text"/></xsl:when>	
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:param>
<xsl:param name="size" select="@length" />
<xsl:param name="cssClass" select="@cssClass" />
<xsl:param name="format" select="@format"/>
<xsl:param name="mode" select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/>

<xsl:param name="value"><xsl:choose>
	<xsl:when test="@value!=''"><xsl:value-of select="@value"/></xsl:when>	
	<xsl:otherwise></xsl:otherwise>
</xsl:choose></xsl:param>

<xsl:param name="valueOnCheck"><xsl:choose>
	<xsl:when test="$value!=''"><xsl:value-of select="$value"/></xsl:when>
	<xsl:otherwise>getdate()</xsl:otherwise>
</xsl:choose></xsl:param>

<xsl:param name="checked"><xsl:choose>
	<xsl:when test="$value!=''">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise>
</xsl:choose></xsl:param>

<xsl:variable name="showText" select="'true'"/>

<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	<img tabIndex="0" width="15" height="15" border="1">
	<xsl:attribute name="src">
		<xsl:choose>
			<xsl:when test="$checked='true'">/Images/check.gif</xsl:when>		
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
			<input type="checkbox" name="{$name}" value="{$valueOnCheck}">
				<xsl:choose>
					<xsl:when test="$showText='true'">
						<xsl:attribute name="onclick">Checkdate_Checkbox_click();</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
				 		<xsl:attribute name="dataField"><xsl:value-of select="$dataField"/></xsl:attribute>
				 	</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$showText='true'"><xsl:attribute name="onclick">Checkdate_Checkbox_click();</xsl:attribute></xsl:if>
				<xsl:if test="$checked='true'"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
			</input><xsl:if test="$showText='true'"><xsl:value-of select="$nbsp"/><xsl:call-template name="dateBox"><xsl:with-param name="dataField" select="''"/></xsl:call-template></xsl:if>
<!-- 			<input type="text" onpropertychange="CheckDate_onpropertychange(this);">
				 <xsl:attribute name="name"><xsl:value-of select="name(.)"/></xsl:attribute>
				 <xsl:attribute name="value"><xsl:value-of select="$formatedValue"/></xsl:attribute>
			</input><xsl:value-of select="$nbsp"/><input type="checkbox" highlightAlways="true" onfocus="this.fireEvent('onmouseover');" onpropertychange="CheckDate_checkbox_onpropertychange(this);">
				 <xsl:attribute name="id">chk_fecha_<xsl:value-of select="name(.)" /></xsl:attribute>
				<xsl:attribute name="onclick"><xsl:if test="@onclick"><xsl:value-of select="@onclick" disable-output-escaping="yes" /></xsl:if> CheckDate_onclick(this);</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@value">
					<xsl:attribute name="checked">true</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$formatedValue"/></xsl:attribute>
					</xsl:when>	
					<xsl:otherwise><xsl:attribute name="value">getdate()</xsl:attribute></xsl:otherwise>
				</xsl:choose>
			</input> -->
		</div>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
