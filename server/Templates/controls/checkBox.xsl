<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:px="urn:panax"
>
<xsl:strip-space elements="*"/>

<xsl:template match="*" mode="onChange" priority="-1">function(){return}</xsl:template>

<xsl:template match="*" mode="boxLabel" priority="-1"></xsl:template>
<xsl:template match="*[ancestor::*[@mode='fieldselector']]" mode="boxLabel" priority="-1"><xsl:apply-templates select="." mode="headerText"/></xsl:template>

<xsl:template name="checkbox" match="*[@dataType='bit' and @controlType='default' and not(ancestor::*[@mode='filters']) or @controlType='checkbox']">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>

<xsl:param name="dataType" select="@dataType"/>
<xsl:param name="onclick" select="@onclick"/>
<xsl:param name="uncheckedValue"><xsl:choose>
	<xsl:when test="@uncheckedValue"><xsl:value-of select="@uncheckedValue"/></xsl:when>	
	<xsl:when test="@dataType='bit'">0</xsl:when>	
	<xsl:otherwise>NULL</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="valueOnCheck"><xsl:choose>
	<xsl:when test="@valueOnCheck"><xsl:value-of select="@valueOnCheck"/></xsl:when>
	<xsl:when test="$dataType='bit'">1</xsl:when>
	<xsl:when test="$value"><xsl:value-of select="$value"/></xsl:when>
	<xsl:otherwise>NULL</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="checked"><xsl:choose>
	<xsl:when test="@checked"><xsl:value-of select="@checked"/></xsl:when>
	<xsl:when test="$valueOnCheck=$value">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:variable name="control.attributeSet"><xsl:copy>
	<xsl:attribute name="type">checkbox</xsl:attribute>
	<xsl:attribute name="highlightAlways">true</xsl:attribute>
	<xsl:attribute name="onclick">autoCheck('<xsl:value-of select="generate-id(.)"/>')</xsl:attribute>
	<xsl:attribute name="value"><xsl:value-of select="$valueOnCheck"/></xsl:attribute>
	<xsl:attribute name="uncheckedValue"><xsl:value-of select="$uncheckedValue"/></xsl:attribute>
	<xsl:if test="$checked='true'"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
	<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
	<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
	<xsl:if test="$onclick"><xsl:attribute name="onclick"><xsl:value-of select="$onclick" disable-output-escaping="yes" /></xsl:attribute></xsl:if>
	<xsl:for-each select="ancestor::*[not(@catalogName)]"><xsl:attribute name="group_{generate-id(.)}">1</xsl:attribute></xsl:for-each>
</xsl:copy>
</xsl:variable>
<!-- value: <xsl:value-of select="$value"/> (<xsl:value-of select="@dataType"/>) - <xsl:value-of select="$valueOnCheck"/> -->
xtype: 'checkboxfield'
, boxLabel: '<xsl:apply-templates select="." mode="boxLabel"/>'
, name: '<xsl:value-of select="$name"/>'
, value: '<xsl:value-of select="@text"/>'
<xsl:if test="not(ancestor::*[@mode='fieldselector'])">
, onChange: <xsl:apply-templates select="." mode="onChange"/>
, setReadOnly: function(readonly){
		this.setVisible(!this.readOnly || this.checked)
}
, listeners: {
	change: function(control, newValue, oldValue, eOpts) {
<xsl:text disable-output-escaping="yes"><![CDATA[ 
		control.setVisible(!control.readOnly || control.readOnly && newValue);
]]></xsl:text>
	}
}
</xsl:if>
<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	, readOnly: true
	</xsl:when>
<!-- EDITABLE -->
	<xsl:otherwise>
		<!-- <xsl:element name="input">
		<xsl:copy-of select="msxsl:node-set($control.attributeSet)/*/@*" />
		</xsl:element> -->
	</xsl:otherwise>
</xsl:choose>

</xsl:template>
</xsl:stylesheet>
