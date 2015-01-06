<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:template match="*[@controlType='file' or @controlType='image' or @controlType='picture']">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="required"/>
<xsl:param name="text" select="string(@text)"/>
<xsl:param name="value" select="string(@value)"/>

<xsl:param name="size" select="@length" />
<xsl:param name="parentFolder"><xsl:choose>
	<xsl:when test="@parentFolder"><xsl:value-of select="@parentFolder"/></xsl:when>	
	<xsl:otherwise>Images/FileSystem</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="width" select="'90'"/>
xtype: "fieldcontainer"
, width: 350
, height: 130
, layout: {
	type: 'vbox'
	, align : 'stretch'
	, pack  : 'start'
}
, items: [{
	xtype: <xsl:choose><xsl:when test="@controlType='file'">'filemanager'</xsl:when><xsl:otherwise>'imagemanager'</xsl:otherwise></xsl:choose>
	, itemId: 'fileImage'
	, name: '<xsl:value-of select="$name"/>'
	, parentFolder: "<xsl:value-of select="$parentFolder"/>"
<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	, readOnly: true
	</xsl:when>
	<xsl:otherwise>
		
	</xsl:otherwise>
</xsl:choose>
}]
</xsl:template>
</xsl:stylesheet>
