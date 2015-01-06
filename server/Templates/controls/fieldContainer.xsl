<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax"
>

<xsl:template match="*[not(@fieldContainer)]" mode="fieldContainer">
	<xsl:param name="scope" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
	<xsl:variable name="fieldContainer" select="@fieldContainer"/>
	<xsl:variable name="items" select=".|following-sibling::*[@fieldId=$scope/@fieldId][@fieldContainer=$fieldContainer]"/>
	<xsl:variable name="required"><xsl:apply-templates select="." mode="required"/></xsl:variable>
	<xsl:variable name="current" select="current()"/>
	{
		xtype: "fieldcontainer"/*formField*/
		, itemId: "<xsl:apply-templates select="." mode="container_id"/>"
		, fieldLabel: "<xsl:apply-templates select="." mode="headerText"/><!--  <xsl:if test="key('fieldContainer',concat(generate-id(),'::',self::*[@fieldContainerEnd]/@fieldContainerEnd|self::*[not(@fieldContainerEnd)]/following-sibling::*[@fieldContainerEnd=current()/preceding-sibling::*[@fieldContainer][1]/@fieldContainer][1]/@fieldContainerEnd))"> (<xsl:value-of select="@Column_Name"/>)</xsl:if> -->"
		<!-- /*fieldSet: <xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'fieldSet'"/></xsl:call-template>*/ -->
		, afterLabelTextTpl: '<xsl:if test="number($required)=1">
		<span style="color:red;font-weight:bold" data-qtip="Requerido">*</span>
	</xsl:if> <xsl:if test="string(@description)!=''"><img src="../../../../Images/advise/vbQuestion.gif" width="15" data-qtip="{@description}"/></xsl:if>'
	    , labelWidth: <xsl:apply-templates mode="labelWidth" select="."/>
		, layout: 'hbox'
		, width: "100%"	
		, defaults: { hideLabel: true, anchor: 'none', flex: 0, <xsl:apply-templates select="." mode="container.items.defaultConfig"/>}
		, <xsl:apply-templates select="." mode="container.config"/>
		, items: [<xsl:apply-templates mode="dataField" select="."/>]
	},
</xsl:template>

<xsl:template name="fieldContainer" match="*" mode="fieldContainer">
	<xsl:param name="scope" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
	<xsl:variable name="fieldContainer" select="@fieldContainer"/>
	<xsl:variable name="items" select=".|following-sibling::*[@fieldId=$scope/@fieldId][@fieldContainer=$fieldContainer]"/>
	{
		xtype: "fieldcontainer"/*mode="fieldContainer"*/,
		itemId: "<xsl:apply-templates select="." mode="container_id"/>",
		fieldLabel: "<xsl:apply-templates select="@fieldContainer" mode="headerText"/>",
		afterLabelTextTpl: '<xsl:if test="$items[string(@description)!=''][1]"><img src="../../../../Images/advise/vbQuestion.gif" width="15" data-qtip="{$items[@description][1]/@description}"/></xsl:if>',
		labelWidth: <xsl:apply-templates mode="labelWidth" select="."/>,
		layout: 'hbox',
		pack: 'start',
		width: "100%",
		<xsl:if test="@fieldContainer">
		defaults: { labelAlign: "top", anchor: 'none', flex: 0, <xsl:apply-templates select="@fieldContainer" mode="container.items.defaultConfig"/>},
		<xsl:apply-templates select="@fieldContainer" mode="container.config"/>,
		</xsl:if>
		items: [<xsl:apply-templates select="self::*[count($items)=0]|$items" mode="dataField"/>, {xtype:"displayfield", flex:1}],
		<xsl:apply-templates select="." mode="container.config"/>
	},
</xsl:template>

</xsl:stylesheet>


