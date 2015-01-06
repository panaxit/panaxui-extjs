<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/str"
	xmlns:px="urn:panax"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	extension-element-prefixes="str"
	>
<xsl:strip-space elements="*"/>
<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function replace(sText, sSearch, sReplace){ 
var re = new RegExp(sSearch,'g');
return sText.replace(re, sReplace);}
]]>
</msxsl:script>
<xsl:variable name="br"><br/></xsl:variable>

<xsl:template mode="control.renderer" match="px:fields/*">
function(value) {
	return value
}
</xsl:template>

<xsl:template mode="control.renderer" match="px:fields/*[contains(@dataType, 'date')=1]">
Ext.util.Format.dateRenderer('d/m/Y')
</xsl:template>

<xsl:template name="label" match="px:fields/*[@controlType='label' or @mode='readonly' and @dataType!='foreignKey']">
xtype: "displayfield",
renderer: <xsl:apply-templates select="." mode="control.renderer"/>
</xsl:template>
</xsl:stylesheet>
