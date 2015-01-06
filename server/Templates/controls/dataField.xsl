<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:extjs="urn:extjs"
	xmlns:px="urn:panax"
>

<xsl:template match="@*" mode="copyConfig"></xsl:template>

<xsl:template match="@extjs:*" mode="copyConfig">, <xsl:value-of select="local-name(.)"/>:<xsl:value-of select="."/></xsl:template>

<xsl:template mode="templates.field.config" match="*"><xsl:param name="name"/><xsl:param name="value"/><xsl:if test="$value!=''">,<xsl:value-of select="$name"/>:<xsl:value-of select="$value"/></xsl:if></xsl:template>

<xsl:template mode="templates.field.allConfigs" match="*">
<xsl:apply-templates mode="templates.field.config" select=".">
	<xsl:with-param name="name">increment</xsl:with-param>
	<xsl:with-param name="value"><xsl:apply-templates mode="field.config.increment" select="."/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>

<xsl:template mode="templates.field.allConfigs" match="*[@dataType='foreignTable' or @dataType='junctionTable']"></xsl:template>

<xsl:template match="@hidden|@maxSelections|@maxValue|@minSelections|@minValue" mode="copyConfig">, <xsl:value-of select="local-name(.)"/>:<xsl:value-of select="."/></xsl:template>

<xsl:template match="*" mode="field.config">/*<xsl:value-of select="@dataType"/>*/undefined:null</xsl:template>
<xsl:template match="*" mode="field.items.defaultConfig" priority="-2">undefined:null</xsl:template>
<xsl:template match="*" mode="container.items.defaultConfig" priority="-2"><xsl:if test="position()&gt;1">,</xsl:if>undefined:null</xsl:template>
<xsl:template match="*" mode="container.config" priority="-2"><xsl:if test="position()&gt;1">,</xsl:if>undefined:null</xsl:template>
<xsl:template match="@fieldContainer" mode="container.config" priority="-2">undefined:null</xsl:template>
<xsl:template match="px:fieldContainer[px:field]|px:fieldSet[px:field]" mode="container.config" priority="-2"><xsl:apply-templates select="px:field[1]" mode="container.config"/> </xsl:template>
<xsl:template match="px:field" mode="container.config" priority="-2"><xsl:if test="position()&gt;1">,</xsl:if><xsl:apply-templates select="key('fields',@fieldId)" mode="container.config"/></xsl:template>

<xsl:template match="@fieldContainer" mode="container.items.defaultConfig" priority="-2">undefined:null</xsl:template>
<xsl:template match="@fieldContainer" mode="fieldset.items.defaultConfig" priority="-2"><xsl:variable name="containerItemsConfig"><xsl:apply-templates select="." mode="container.items.defaultConfig"/></xsl:variable><xsl:value-of select="$containerItemsConfig"/><xsl:if test="not(contains(string($containerItemsConfig), 'hideLabel:'))">, hideLabel: false</xsl:if></xsl:template>

<xsl:template match="px:*" mode="container_id"><xsl:value-of select="concat('container_', generate-id(.))"/></xsl:template>

<xsl:template match="px:fields/*" mode="container_id"><xsl:apply-templates mode="container_id" select="key('fieldContainer', @fieldId)"/></xsl:template>

<xsl:template match="*" mode="cmp_id"><xsl:value-of select="concat('cmp_', name(ancestor-or-self::*[@dataType][1]), '_', generate-id(.))"/></xsl:template>


<xsl:template mode="headerText" priority="-1" match="@fieldContainer|@fieldSet"><xsl:value-of select="."/></xsl:template>
<xsl:template mode="headerText" priority="-1" match="@fieldContainer[.=../@Column_Name]" ><xsl:apply-templates mode="headerText" select=".."/></xsl:template>

<xsl:template match="*[@dataType='table']|*[@headerText]" mode="headerText" priority="-1">
<xsl:choose>
	<xsl:when test="string(@headerText)!=''"><xsl:value-of select="@headerText"/></xsl:when>	
	<xsl:otherwise><xsl:value-of select="@headerText"/></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template mode="emptyText" priority="-2" match="*"><xsl:apply-templates select="." mode="headerText"/></xsl:template>
<xsl:template mode="emptyText" priority="-2" match="*[@dataType='foreignKey']/*"><xsl:apply-templates select=".." mode="emptyText"/></xsl:template>

<xsl:template match="*" mode="required" priority="-1"><xsl:choose>
	<xsl:when test="self::*[key('requiredFields', generate-id())]">1</xsl:when>
	<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 
<xsl:template match="*[@dataType='foreignKey'][@controlType!='default']" mode="fieldContainer">
	<xsl:param name="scope" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
	<xsl:variable name="items" select="."/>
	{
		xtype: "fieldset",
		itemId: "<xsl:apply-templates select="." mode="container_id"/>",
		fieldLabel: "<xsl:apply-templates select="." mode="headerText"/>",
		labelWidth: <xsl:apply-templates mode="labelWidth" select="."/>,
		afterLabelTextTpl: '<xsl:if test="$items[string(@description)!=''][1]"><img src="../../../../Images/advise/vbQuestion.gif" width="15" data-qtip="{$items[@description][1]/@description}"/></xsl:if>',
		layout: 'anchor',
		defaults: { anchor: 'none', flex: 0},
		items: [<xsl:apply-templates select="." mode="dataField" />undefined]
	},
</xsl:template> -->

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

<xsl:template match="px:fieldContainer" mode="container.onexpand" priority="-1">function(){}</xsl:template>

<xsl:template match="*" mode="control.onchange" priority="-2">undefined</xsl:template>

<xsl:template match="*[ancestor::*[@mode='fieldselector']]" mode="control.onchange" priority="10">undefined</xsl:template>

<xsl:template match="px:fieldContainer" mode="container.oncollapse" priority="-1">function(){}</xsl:template>

<xsl:template name="fieldContainer.checkBoxToggle" match="*[@fieldContainer][@dataType='bit']" mode="fieldContainer">
	<xsl:param name="scope" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
	<xsl:variable name="fieldContainer" select="@fieldContainer"/>
	<xsl:variable name="items" select="following-sibling::*[@fieldId=$scope/@fieldId][@fieldContainer=$fieldContainer]"/>
	{
		xtype: "fieldset",
		itemId: "<xsl:apply-templates select="." mode="container_id"/>",
		title: "<xsl:choose><xsl:when test="string(@fieldContainer)!=''"><xsl:apply-templates select="@fieldContainer" mode="headerText"/></xsl:when><xsl:otherwise><xsl:apply-templates select="." mode="headerText"/></xsl:otherwise></xsl:choose>",
		checkboxToggle: true,
		<xsl:if test="not(self::*[count($items)=0])"> checkboxName: "<xsl:value-of select="@Column_Name" disable-output-escaping="yes"/>",</xsl:if>
		collapsed: true,
		layout: 'anchor',
		defaults: { anchor: 'none', flex:0, columnWidth:50, <xsl:apply-templates select="@fieldContainer" mode="fieldset.items.defaultConfig"/>}
		, <xsl:apply-templates select="@fieldContainer" mode="container.config"/>
		, items: [<xsl:apply-templates select="self::*[count($items)=0]|$items" mode="dataField"><xsl:with-param name="widthRatio" select="100"/></xsl:apply-templates>, {xtype:"displayfield", flex:1}]
		<xsl:variable name="onexpand"><xsl:apply-templates select="@fieldContainer" mode="container.onexpand"/></xsl:variable>
		<xsl:variable name="oncollapse"><xsl:apply-templates select="@fieldContainer" mode="container.oncollapse"/></xsl:variable>
		, listeners: {
			<xsl:if test="$onexpand!=''">expand: <xsl:value-of select="$onexpand"/></xsl:if>
			<xsl:if test="$oncollapse!=''"><xsl:if test="$onexpand!=''">,</xsl:if>collapse: <xsl:value-of select="$oncollapse"/></xsl:if>
		}
	},
</xsl:template>

<xsl:template match="px:fields/*|px:data/px:dataRow/*" mode="headerText" priority="-1">
	<xsl:param name="dataField" select="." />
	<xsl:choose>
		<xsl:when test="@headerText"><xsl:value-of select="@headerText"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="name(.)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="px:fields/*|px:data/px:dataRow/*" mode="dataField.headerText">
	<xsl:param name="dataField" select="." />
	<xsl:choose>
		<xsl:when test="@headerText"><xsl:value-of select="@headerText"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="name(.)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template mode="field_id" match="*"><xsl:value-of select="concat('field_', name(.), '_', generate-id(.))"/></xsl:template>
<xsl:template mode="item_id" match="*"><xsl:value-of select="concat('item_', name(.), '_', generate-id(.))"/></xsl:template>

<xsl:template mode="labelWidth" match="*" priority="-2">100</xsl:template>
<xsl:template mode="labelWidth" match="*[ancestor-or-self::*[@mode='fieldselector']]" priority="-2">300</xsl:template>

<xsl:template mode="itemHeight" match="*" priority="-2"></xsl:template>
<xsl:template mode="itemWidth" match="*" priority="-2"><xsl:variable name="length" select="ancestor-or-self::*[@length][1]/@length"/><xsl:choose><xsl:when test="$length&lt;=15"><xsl:value-of select="50+$length*8"/></xsl:when><xsl:when test="$length&lt;=40"><xsl:value-of select="125+$length*2"/></xsl:when><xsl:otherwise>306</xsl:otherwise></xsl:choose></xsl:template>
<xsl:template mode="itemWidth" match="*[@controlType!='default']" priority="-2"></xsl:template>

<xsl:template mode="field.name" match="*" priority="-2"><xsl:variable name="parentAssociation" select="ancestor::*[@dataType='junctionTable' or @dataType='foreignTable'][1]"/><xsl:if test="$parentAssociation"><xsl:value-of select="$parentAssociation/@Column_Name"/>.</xsl:if><xsl:choose><xsl:when test="@binding"><xsl:value-of select="@binding" disable-output-escaping="yes"/></xsl:when><xsl:when test="@fieldName"><xsl:value-of select="@fieldName" disable-output-escaping="yes"/></xsl:when><xsl:when test="@Column_Name"><xsl:value-of select="@Column_Name" disable-output-escaping="yes"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:template>

<xsl:template match="*" mode="field.config" priority="-2">undefined:null</xsl:template>

<!-- <xsl:template mode="dataField" match="*">
<xsl:if test="position()&gt;1">,</xsl:if>
{
	xtype: "fieldcontainer",
	itemId: "<xsl:apply-templates select="." mode="field_id"/>",
	fieldLabel: "<xsl:apply-templates select="." mode="headerText"/>",
	defaults: {anchor:'none', flex:0, hideLabel:true, labelWidth:0, layout:'hbox', <xsl:apply-templates select="." mode="field.items.defaultConfig"/>},
	<xsl:apply-templates select="." mode="field.config"/>,
	items: [<xsl:apply-templates select="." mode="dataField" />]
}</xsl:template> -->

<xsl:template match="*" mode="dataField">
<xsl:param name="labelWidth"><xsl:apply-templates mode="labelWidth" select="."/></xsl:param>
<xsl:param name="itemWidth"><xsl:apply-templates mode="itemWidth" select="."/></xsl:param>
<xsl:param name="itemHeight"><xsl:apply-templates mode="itemHeight" select="."/></xsl:param>
<xsl:param name="name"><xsl:apply-templates mode="field.name" select="."/></xsl:param>
<xsl:if test="position()&gt;1">,</xsl:if>
	<xsl:call-template name="dataField">
		<xsl:with-param name="labelWidth" select="$labelWidth"/>
		<xsl:with-param name="itemWidth" select="$itemWidth"/>
		<xsl:with-param name="itemHeight" select="$itemHeight"/>
		<xsl:with-param name="name" select="$name"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="field.config.labelSeparator"></xsl:template>
<xsl:template match="*[ancestor-or-self::*[@mode='fieldselector']]" mode="field.config.labelSeparator">, labelSeparator:''</xsl:template>

<xsl:template match="*" mode="field.config.beforeLabelTextTpl"></xsl:template>
<xsl:template match="*[ancestor-or-self::*[@mode='filters' or @mode='fieldselector']]" mode="field.config.beforeLabelTextTpl"><xsl:param name="name"/><!--, beforeLabelTextTpl: '<xsl:if test="$name"><input type="checkbox" name="{$name}" id="lbl_{generate-id()}"><xsl:choose><xsl:when test="ancestor-or-self::*[@mode='fieldselector']"><xsl:attribute name="checked">checked</xsl:attribute></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></input><xsl:value-of select="$nbsp"/></xsl:if>'--></xsl:template>

<xsl:template match="*" mode="field.config.afterLabelTextTpl"></xsl:template>
<xsl:template match="*[not(ancestor-or-self::*[@mode='fieldselector'])]" mode="field.config.afterLabelTextTpl">
<xsl:variable name="required"><xsl:apply-templates select="." mode="required"/></xsl:variable>
, afterLabelTextTpl: '<xsl:if test="number($required)=1"><span style="color:red;font-weight:bold" data-qtip="Requerido">*</span></xsl:if><xsl:if test="string(@description)!=''"><img src="../../../../Images/advise/vbQuestion.gif" width="15" data-qtip="{@description}"/></xsl:if>'</xsl:template>
<xsl:template name="dataField">
	<xsl:param name="value" select="string(@value)"/>
	<xsl:param name="text" select="string(@text)"/>
	<xsl:param name="name"><xsl:apply-templates mode="field.name" select="."/></xsl:param>
	<xsl:param name="labelWidth"><xsl:apply-templates mode="labelWidth" select="."/></xsl:param>
	<xsl:param name="itemWidth"><xsl:apply-templates mode="itemWidth" select="."/></xsl:param>
	<xsl:param name="itemHeight"><xsl:apply-templates mode="itemHeight" select="."/></xsl:param>
	<xsl:variable name="id" select="concat('field_', name(.), '_', generate-id(.))"/>
	<xsl:variable name="inputId" select="concat('input_', name(.), '_', generate-id(.))"/>
	<xsl:variable name="mode"><xsl:call-template name="currentMode"/></xsl:variable>
	<xsl:variable name="required"><xsl:apply-templates select="." mode="required"/></xsl:variable>
	<xsl:variable name="class"><xsl:choose><xsl:when test="number($required)=1"> required </xsl:when><xsl:otherwise> notRequired </xsl:otherwise></xsl:choose> </xsl:variable>
<xsl:choose>
	<xsl:when test="1=0 and @dataType='foreignTable'"><!-- <xsl:apply-templates select=".">
				<xsl:with-param name="id" select="$inputId"/>
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="mode" select="$mode"/>
				<xsl:with-param name="required" select="$required"/>
			</xsl:apply-templates> --></xsl:when>	
	<xsl:otherwise>
<xsl:variable name="fieldSet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'fieldSet'"/></xsl:call-template></xsl:variable>
{ <!-- <xsl:for-each select="@*"> <xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>, </xsl:for-each> <xsl:value-of select="@dataType"/> (<xsl:value-of select="@controlType"/>)-->
	fieldLabel: '<xsl:if test="not(ancestor::*[@mode='fieldselector'])"><xsl:apply-templates select="." mode="headerText"/></xsl:if>'

	, emptyText: '<xsl:apply-templates select="." mode="emptyText"/>'
	, name: '<xsl:value-of select="$name"/>'
	, itemId: "<xsl:apply-templates select="." mode="field_id"/>"<!-- item_id -->
	<!-- ,beforeSubTpl:'<select><option>=</option><option>empieza con</option><option>contiene</option></select>' -->
	<xsl:apply-templates mode="field.config.labelSeparator" select="."/>
	<xsl:apply-templates mode="field.config.beforeLabelTextTpl" select="."><xsl:with-param name="name" select="$name"/></xsl:apply-templates>
	<xsl:apply-templates mode="field.config.afterLabelTextTpl" select="."/>
	<xsl:if test="ancestor-or-self::*[@mode='filters']">, style: {"white-space":'nowrap'}, beforeBodyEl: '<xsl:text disable-output-escaping="yes"><![CDATA[ <select id="filter_{$name}"> <option>=</option><option value="LIKE" selected="selected">contiene</option><option value="STARTS-WITH">empieza con</option></select>]]></xsl:text>'</xsl:if>
	<xsl:choose><xsl:when test="number($required)=1">, required: true
	, cls: 'required <xsl:value-of select="@class"/>'
	, allowBlank: false</xsl:when><xsl:when test="string(@class)!=''">, cls: '<xsl:value-of select="@class"/>'</xsl:when></xsl:choose>/*dt: <xsl:value-of select="ancestor-or-self::*[@dataType][1]/@dataType"/>; lw: <xsl:value-of select="$labelWidth"/>; iw: <xsl:value-of select="$itemWidth"/>*/
	<xsl:if test="string($itemHeight)!=''">, height: <xsl:value-of select="$itemHeight"/></xsl:if>
	<xsl:if test="string($itemWidth)!=''">, width: <xsl:value-of select="$itemWidth"/>/*<xsl:value-of select="ancestor-or-self::*[@length][1]/@length"/><!--+$labelWidth <xsl:choose><xsl:when test="@dataType='foreignKey'">100</xsl:when><xsl:when test="$length&lt;=15"><xsl:value-of select="$length"/></xsl:when><xsl:when test="$length&lt;=25">130</xsl:when><xsl:when test="$length&lt;=13">150</xsl:when><xsl:when test="$length&lt;=20">170</xsl:when><xsl:when test="$length&lt;=40">230</xsl:when><xsl:otherwise>300</xsl:otherwise></xsl:choose> -->*/</xsl:if>
	<xsl:choose>
		<xsl:when test="@dataType='foreignKey' or @dataType='bit'">
		</xsl:when>
		<xsl:when test="@dataType='tinyint'">
	, maxLength: 3
		</xsl:when>
		<xsl:when test="@dataType='int'">
	, maxLength: 5
		</xsl:when>
		<xsl:otherwise>
	, maxLength: <xsl:choose><xsl:when test="@length=-1">4000</xsl:when><xsl:otherwise><xsl:value-of select="number(@length)"/></xsl:otherwise></xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	, onchange_event: <xsl:apply-templates select="." mode="control.onchange"/>
	, /*<xsl:value-of select="@controlType"/>*/<xsl:apply-templates select=".">
		<xsl:with-param name="id" select="$inputId"/>
		<xsl:with-param name="name" select="$name"/>
		<xsl:with-param name="text" select="$text"/>
		<xsl:with-param name="mode" select="$mode"/>
		<xsl:with-param name="required" select="$required"/>
	</xsl:apply-templates>
	<xsl:apply-templates mode="templates.field.allConfigs" select="."/>
	, <xsl:apply-templates select="." mode="field.config"/>
	, emptyText: '<xsl:apply-templates select="." mode="emptyText"/>'
	/*dbconfig*/<xsl:apply-templates select="@extjs:*" mode="copyConfig"/>/*dbconfig*/
}
<!-- 		<span>
			<xsl:attribute name="class"><xsl:if test="$mode!='readonly' or @isSubmitable='1' or @isSubmitable='true'"><xsl:text>dataField </xsl:text></xsl:if><xsl:value-of select="$class"/> Field_<xsl:value-of select="@Column_Name"/></xsl:attribute>
			<xsl:apply-templates select="." mode="field.config" />
      		<xsl:attribute name="filterOperator">=</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$id" /> </xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
			<xsl:attribute name="text"><xsl:value-of select="$text" /></xsl:attribute>
			<xsl:apply-templates select=".">
				<xsl:with-param name="id" select="$inputId"/>
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="text" select="$text"/>
				<xsl:with-param name="mode" select="$mode"/>
				<xsl:with-param name="required" select="$required"/>
			</xsl:apply-templates>
		</span> -->
	</xsl:otherwise>
</xsl:choose>	
</xsl:template>

<!-- <xsl:template match="*" mode="duplicateNode">
	&lt;<xsl:value-of select="local-name(.)"/><xsl:for-each select="@*"><xsl:text> </xsl:text><xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each>&gt;<xsl:apply-templates mode="duplicateNode" select="*"/>&lt;/<xsl:value-of select="local-name(.)"/>&gt;
</xsl:template> -->

</xsl:stylesheet>


