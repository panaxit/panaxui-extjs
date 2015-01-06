<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	>
<xsl:strip-space elements="*"/>

<xsl:template match="*[1=0 and (@controlType='image' or @controlType='picture')]" priority="-1">
	<xsl:call-template name="image"/>
</xsl:template>

<xsl:template name="image" match="*[1=0 and (@controlType='image' or @controlType='picture')]" priority="-1">
<xsl:param name="name" select="name(.)"/>
<xsl:param name="id" select="concat('input_', name(.), '_', generate-id(.))"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="parentFolder"><xsl:choose>
	<xsl:when test="@parentFolder"><xsl:value-of select="@parentFolder"/></xsl:when>	
	<xsl:otherwise>Images/FileSystem</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="imageUrl"><xsl:choose>
	<xsl:when test="string(@value)!=''"><xsl:value-of select="@value"/></xsl:when>	
	<xsl:otherwise>no_photo.gif</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="width" select="'90'"/>
<xsl:param name="mode" select="'readonly'"/>
xtype: 'filefield',
emptyText: 'Select an image',
buttonText: '',
buttonConfig: {iconCls: 'upload-icon'},
<xsl:choose>
<!-- READONLY -->
	<xsl:when test="$mode='readonly'">
	readOnly: true,
<!-- <xsl:element name="img">
	<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
	<xsl:attribute name="src">../../../../<xsl:value-of select="$parentFolder"/>/<xsl:value-of select="$imageUrl"/></xsl:attribute>
	<xsl:attribute name="onerror">this.src="../../../../Images/FileSystem/no_photo.gif"</xsl:attribute>
</xsl:element> -->
	</xsl:when>
<!-- EDITABLE -->
	<xsl:otherwise>
		<!-- <span class="fileManager image {$cssClass}" isSubmitable="true" onMouseOver="/*alert(this.value+': '+($(this).hasClass('changed')))*/" oncontextmenu="return false;">
			<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
			<xsl:attribute name="fileName"><xsl:value-of select="@value"/></xsl:attribute>
			<xsl:attribute name="parentFolder"><xsl:value-of select="$parentFolder"/></xsl:attribute>
			
			<xsl:element name="img">
			<xsl:attribute name="class">thumbnail</xsl:attribute>
			<xsl:attribute name="src">../../../../<xsl:value-of select="$parentFolder"/>/<xsl:value-of select="$imageUrl"/></xsl:attribute>
			<xsl:attribute name="height">90</xsl:attribute>
			<xsl:attribute name="width">90</xsl:attribute>
			<xsl:attribute name="onerror">this.src="../../../../Images/FileSystem/no_photo.gif"</xsl:attribute>
		</xsl:element><br/><label id="fileName"></label>
		</span> -->
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>
