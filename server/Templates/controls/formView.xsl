<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax">
  <xsl:strip-space elements="*"/>

<xsl:template match="*[@dataType='table'][@controlType='formView' or @controlType='detailsView']">
	<xsl:apply-templates select="." mode="formView.Template"/>
</xsl:template>
  
<xsl:template match="*[@dataType='table']" mode="formView.Template">
	<xsl:apply-templates select="." mode="formView.table.Template" />	
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="formView.table.Template">
Ext.define('Cache.app.<xsl:value-of select="@dbId"/>.<xsl:value-of select="@xml:lang"/>.<xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/>.<xsl:value-of select="translate(@mode, $uppercase, $smallcase)"/>.<xsl:value-of select="@controlType"/>', { 
extend: 'Ext.container.Container', 
onDestroy: function() {
	//alert('destroyed form');
},
identity: null,
filters: <xsl:choose><xsl:when test="@filters">"<xsl:value-of select="@filters"/>"</xsl:when><xsl:otherwise>undefined</xsl:otherwise></xsl:choose>,
initComponent: function() { 
	var me = this; 
	var store;
	<xsl:apply-templates select="." mode="Model"/>

    var store = <xsl:apply-templates select="." mode="data.Store"/>
	
	me.formView = Ext.create('Panax.Form', {
		store: store
		<xsl:if test="@mode">, mode: '<xsl:value-of select="@mode"/>'</xsl:if>
		, <xsl:apply-templates select="." mode="Form.Config"/>
		, items: [<xsl:apply-templates select="." mode="Form.Content"/>]
		, tipTpl: Ext.create('Ext.XTemplate', '<ul><tpl for="."><li><span class="field-name">{name}</span>: <span class="error">{error}</span></li></tpl></ul>')
	});
	Ext.apply(me, { 
		layout: 'fit',
		items: [me.formView]
	});
	me.callParent(arguments); 
	}
	,loadRecord: function(currentRecord) {
		var me = this;
		if (!(currentRecord===undefined)) {
			var view = me.formView;
			view.mask = new Ext.LoadMask(view, {msg:"Cargando..."});
			view.mask.show();
			if (Ext.isObject(currentRecord)) {
				view.loadRecord(currentRecord);
				view.mask.hide();
				}
			else {
				var newRecord = <xsl:value-of select="@Table_Schema" />.<xsl:value-of select="@Table_Name" />.load(currentRecord
				, {
					success: function(record) {
						view.loadRecord(record);
						view.mask.hide();
					}
					, failure: function() {
						view.mask.hide();
					}
				});
			}
		}
	}
});
	<!-- 
	
	<xsl:for-each select="px:data/px:dataRow[1]">
	var newRecord = new <xsl:value-of select="ancestor::*[@dataType='table'][1]/@Table_Schema" />.<xsl:value-of select="ancestor::*[@dataType='table'][1]/@Table_Name" />({<xsl:apply-templates select="*[not(@dataType='junctionTable' or @dataType='foreignTable')]" mode="fieldValue"/>null:null});
		<xsl:variable name="currentRow" select="."/>
		<xsl:for-each select="key('fields', */@fieldId)[@dataType='junctionTable' or @dataType='foreignTable']">
		newRecord.association_<xsl:value-of select="@Column_Name"/>_<xsl:value-of select="generate-id()"/>().add({<xsl:apply-templates select="*/px:data/px:dataRow/*" mode="fieldValue"/>null:null});
		</xsl:for-each>
	</xsl:for-each>
	
	var newRecord = new dbo.Prospecto({"NombreProspecto":"Uriel","ApellidoPaterno":"Gomez","ApellidoMaterno":null,"NombreConyuge":null,"ApellidosConyuge":null,"IdTipoPrimerContacto":10,"FechaVisita":new Date('2012-06-13 18:33:11'),"IdMedio":63,"IdVendedor":19,"IdPrototipo":11,"IdDemostrador":null,"CalificacionDemostrador":null,"IdCerrador":null,"CalificacionCerrador":null,"Email":null,"EmailAlternativo":null,"MesesAntigüedad":null,});

	newRecord.phonenumbers().add({home:'1357911', business: '987654321'});
	-->
<!-- 	<xsl:element name="div" use-attribute-sets="query.parameters">
		<xsl:apply-templates select="." mode="formView.table.Wrapper" />
	</xsl:element> -->
</xsl:template>


<xsl:template name="subGroupTabPanel.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:apply-templates select=".|following-sibling::*[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][@subGroupTabPanel][count(. | key('subGroupTabPanel', @subGroupTabPanel)[1]) = 1]" mode="formView.subGroupTabPanel.Template">
		<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="portlet.private">
	<xsl:param name="title"/>
	<xsl:param name="scope" select=".|following-sibling::*"/>
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	
	<xsl:variable name="items" select=".|following-sibling::*[@fieldId=$scope/@fieldId]"/>
	<xsl:variable name="filteredItems" select="$items[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))]"/>
		{
			xtype: 'portalpanel',
			title: '<xsl:value-of select="$title"/>',
			iconCls: 'x-icon-users',
			tabTip: '',
			//style: 'padding: 10px;',
			border: false,
			layout: 'fit',
			items: [{
				flex: 1,
				items: [<xsl:apply-templates select=".|$filteredItems[@portlet][count(. | key('portlet', @portlet)[1]) = 1]" mode="formView.portlet.Template">
				<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
				<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
			</xsl:apply-templates>null]
			}]
		}
</xsl:template>

<xsl:template name="tabPanel.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="portlet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'portlet'"/></xsl:call-template></xsl:param>
	
	<xsl:variable name="items" select=".|following-sibling::*"/>
	<xsl:variable name="filteredItems" select="$items[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][key('portlet',concat(generate-id(),'::',$portlet))]"/>
	<xsl:choose>
		<xsl:when test="$filteredItems[@tabPanel]">
			{
				xtype:'tabpanel',
				activeTab: 0,
				defaults:{
					bodyPadding: 10,
					//layout: 'anchor'
				},
				items:[<xsl:apply-templates select=".|$filteredItems[@tabPanel][count(. | key('tabPanel', @tabPanel)[1]) = 1]" mode="formView.tabPanel.Template">
					<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
					<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
					<xsl:with-param name="portlet" select="$portlet"/>
				</xsl:apply-templates>null]
			},
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="fieldSetGroup.private">
				<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
				<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
				<xsl:with-param name="portlet" select="$portlet"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="fieldSetGroup.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="portlet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'portlet'"/></xsl:call-template></xsl:param>
	<xsl:param name="tabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>

	<xsl:variable name="items" select=".|following-sibling::*"/>
	<xsl:variable name="scope" select="$items[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][key('portlet',concat(generate-id(),'::',$portlet))][key('tabPanel',concat(generate-id(),'::',$tabPanel))]"/>
	<xsl:choose>
		<xsl:when test="$scope[@fieldSet]">
		<xsl:apply-templates select=".|$scope[@fieldSet][count(. | key('fieldSet', @fieldSet)[1]) = 1]" mode="formView.fieldSetGroup.Template">
			<xsl:with-param name="scope" select="$scope"/>
			<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
			<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
			<xsl:with-param name="portlet" select="$portlet"/>
			<xsl:with-param name="tabPanel" select="$tabPanel"/>
		</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
		{
			xtype: 'panel',
			frame: true,
			defaults: {
				anchor: 'none'
			},
			items: [
			<xsl:call-template name="fieldContainer.private">
				<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
				<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
				<xsl:with-param name="portlet" select="$portlet"/>
				<xsl:with-param name="tabPanel" select="$tabPanel"/>
			</xsl:call-template>null
			]
		},
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="fieldContainer.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="portlet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'portlet'"/></xsl:call-template></xsl:param>
	<xsl:param name="tabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="fieldSet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'fieldSet'"/></xsl:call-template></xsl:param>
	<xsl:param name="items" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
	<xsl:param name="scope" select="$items[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][key('portlet',concat(generate-id(),'::',$portlet))][key('tabPanel',concat(generate-id(),'::',$tabPanel))][key('fieldSet',concat(generate-id(),'::',$fieldSet))]"/>
	<xsl:param name="groupBy"/>
	<xsl:variable name="headOfGroup"><xsl:call-template name="getHeadOfGroup"><xsl:with-param name="key" select="$groupBy"/><xsl:with-param name="scope" select="$scope"/></xsl:call-template></xsl:variable>
	
	<xsl:if test="$scope[not(@fieldContainer)]|$scope[@fieldContainer][count(. | key('fieldContainer', @fieldContainer)[1]) = 1]">
	<xsl:variable name="filteredItems">
	<xsl:for-each select="$scope[not(@fieldContainer)]|$scope[@fieldContainer][count(. | key('fieldContainer', @fieldContainer)[1]) = 1]">
	<xsl:variable name="currentheadOfGroup"><xsl:call-template name="getHeadOfGroup"><xsl:with-param name="key" select="$groupBy"/><xsl:with-param name="scope" select="$scope"/></xsl:call-template></xsl:variable>
	<!-- <xsl:variable name="currentheadOfGroup" select="
	self::*[not(@fieldSet)]/preceding-sibling::*[@fieldId=$scope/@fieldId][@fieldSet][1] |
	self::*[not(@fieldSet)]/preceding-sibling::*[@fieldId=$scope/@fieldId][@fieldSet][1][string(@fieldSet)=string(preceding-sibling::*[1]/@fieldSet)]/preceding-sibling::*[@fieldId=$scope/@fieldId][string(@fieldSet)!=string(preceding-sibling::*[1]/@fieldSet)][1] |
	self::*[@fieldSet][string(@fieldSet)=string(preceding-sibling::*[1]/@fieldSet)]/preceding-sibling::*[@fieldId=$scope/@fieldId][string(@fieldSet)!=string(preceding-sibling::*[1]/@fieldSet)][1] | 
	self::*[@fieldSet]
"/> -->
	<xsl:if test="$currentheadOfGroup=$headOfGroup"><xsl:copy-of select="."/><!--  {xtype:'displayfield', flex:1, value:'<xsl:value-of select="@Column_Name"/>: <xsl:value-of select="$headOfGroup"/>(<xsl:value-of select="key('fields',$headOfGroup)/@Column_Name"/>)'}, -->
	</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<!-- <xsl:for-each select="$scope[@fieldId=msxsl:node-set($filteredItems)/*/@fieldId][not(@fieldContainer)]|$scope[@fieldId=msxsl:node-set($filteredItems)/*/@fieldId][@fieldContainer][count(. | key('fieldContainer', @fieldContainer)[1]) = 1]">
		 {xtype:'displayfield', flex:1, value:'<xsl:value-of select="@Column_Name"/>: <xsl:value-of select="$headOfGroup"/>(<xsl:value-of select="key('fields',$headOfGroup)/@Column_Name"/>)'},
	</xsl:for-each> -->
	<xsl:apply-templates select="$scope[@fieldId=msxsl:node-set($filteredItems)/*/@fieldId][not(@fieldContainer)]|$scope[@fieldId=msxsl:node-set($filteredItems)/*/@fieldId][@fieldContainer][count(. | key('fieldContainer', @fieldContainer)[1]) = 1]" mode="fieldContainer">
		<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
		<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
		<xsl:with-param name="portlet" select="$portlet"/>
		<xsl:with-param name="tabPanel" select="$tabPanel"/>
		<xsl:with-param name="fieldSet" select="$fieldSet"/>
	</xsl:apply-templates>
	</xsl:if>
</xsl:template>


<xsl:template match="*[@dataType='table']" mode="formView.table.Wrapper">
<!--     <xsl:choose>
<xsl:when test="current()[string(@mode)!='filters']/px:data/px:dataRow/*[@controlType='tab']"> -->
		<xsl:apply-templates select="." mode="formView.table.tabManager.Template" />
<!--     </xsl:when>
    <xsl:otherwise>
    	<xsl:apply-templates select="." mode="formView.table.Default" />
    </xsl:otherwise>
</xsl:choose> -->
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="Form.Config" priority="-1">
defaults: {
	<!-- labelAlign: 'right', -->
	labelWidth: 100
	<!-- labelAlign: 'top', -->
	<!-- anchor: '100%' -->
}
, layout: {
	type: 'fit'
}
, frame: true
</xsl:template>

<xsl:template mode="quickTip" priority="-1" match="px:fieldContainer|px:fieldSet"></xsl:template>
<xsl:template name="quickTip"><xsl:variable name="text"><xsl:apply-templates mode="quickTip" select="."/></xsl:variable><xsl:if test="$text!=''"><img src="../../../../Images/advise/vbQuestion.gif" width="15"><xsl:attribute name="data-qtip"><xsl:apply-templates mode="quickTip" select="."/></xsl:attribute></img></xsl:if></xsl:template>

<xsl:template mode="headerText" priority="-1" match="px:fieldSet"><xsl:value-of select="@name"/></xsl:template>

<xsl:template mode="formView" match="px:fieldSet">
<xsl:if test="position()&gt;1">,</xsl:if>{
	xtype:'fieldset'
	, title: '<xsl:apply-templates mode="headerText" select="."/><xsl:call-template name="quickTip"/>'
	, itemId: "<xsl:apply-templates mode="container_id" select="."/>"
	, defaultType: 'textfield'
	, layout: 'anchor'
	, defaults: { <!-- labelAlign:'right',  -->anchor:'none', <xsl:apply-templates select="." mode="container.items.defaultConfig"/> }
	, <xsl:apply-templates select="." mode="container.config"/>
	, items: [<xsl:apply-templates select="*" mode="formView"/>]
	<!-- , items: [{xtype:'displayfield', flex:1, value:'dummy'}] -->
	}
</xsl:template>

<xsl:template mode="headerText" priority="-1" match="px:portlet"><xsl:value-of select="@name"/></xsl:template>
<xsl:template mode="headerText" priority="-1" match="px:portlet[@name=px:field/@fieldName]"><xsl:apply-templates mode="headerText" select="key('fields', px:field[1]/@fieldId)"/></xsl:template>

<xsl:template mode="formView" match="px:portlet">
<xsl:if test="position()&gt;1">,</xsl:if>{
	title: '<xsl:value-of select="@name"/>'
	,closable:false
	,layout: 'anchor'
	,items:[{ 
		xtype:'panel'
		,frame: true
		,items: [
		<xsl:apply-templates mode="formView"/>
		]
	}]
}
</xsl:template>

<xsl:template mode="headerText" priority="-1" match="px:tabPanel"><xsl:value-of select="@name"/></xsl:template>
<xsl:template mode="headerText" priority="-1" match="px:tabPanel[@name=px:field/@fieldName]"><xsl:apply-templates mode="headerText" select="key('fields', px:field[1]/@fieldId)"/></xsl:template>

<xsl:template mode="formView" match="px:tabPanel">
<xsl:if test="position()&gt;1">,</xsl:if>{
		xtype:'tabpanel'
		,itemId: '<xsl:apply-templates select="." mode="container_id"/>'
		,activeTab: 0
		,frame:true
		,defaults:{
			bodyPadding: 10
			//layout: 'anchor'
		}
		,<xsl:apply-templates select="." mode="container.config"/>
		,items:[<xsl:apply-templates select="*" mode="formView"/>]
	}
</xsl:template>

<xsl:template mode="formView" match="px:tab">
<xsl:if test="position()&gt;1">,</xsl:if>{
		xtype:'panel'
		,itemId: '<xsl:apply-templates select="." mode="container_id"/>'
		,frame:true
		,title:'<xsl:value-of select="@name"/>'
		,<xsl:apply-templates select="." mode="container.config"/>
		,items:[<xsl:apply-templates select="*" mode="formView"/>]
	}
</xsl:template>

<xsl:template mode="formView" match="px:field">
<xsl:if test="position()&gt;1">,</xsl:if><xsl:apply-templates mode="fieldContainer" select="."/>
</xsl:template>

<xsl:template mode="formView.layout.regions" match="px:layout">{region:'south', hidden:true, xtype:'component', html:''}</xsl:template>

<xsl:template mode="formView.layout.regions.center" match="px:layout">
{
	xtype: 'panel'
	,frame: true
	<xsl:if test="1=1 or not(../..)">,autoScroll: true</xsl:if>
	,defaults: {
		anchor: 'none'
	}
	,items: [<xsl:apply-templates mode="formView" select="*"/>]
}
</xsl:template>

<xsl:template mode="formView" match="px:layout">
<xsl:if test="position()&gt;1">,</xsl:if>{ 
			xtype: 'panel'
			,title: ''
			,border: false
			,layout: 'fit'
			,width: '100%'
			,frame: true
			,<xsl:apply-templates select="." mode="container.config"/>
			,items: [{
				xtype:'portalpanel'
				,title:''
				,region:'center'
				,flex: 1
				,frame: true
				,items: [{
					xtype:'portlet'
					,closable: false
					,collapsible: false
					,resizable:true
					,draggable: false
					,layout: 'fit'
					,items: [<xsl:apply-templates select="." mode="formView.layout.regions.center"/>]
				}]
			},<xsl:apply-templates select="." mode="formView.layout.regions"/>]
		}
</xsl:template>

<xsl:template mode="formView" match="px:layout">
<xsl:apply-templates select="." mode="formView.layout.regions.center"/>
</xsl:template>

<xsl:template mode="formView" match="px:layout[px:groupTabPanel]">
<xsl:if test="position()&gt;1">,</xsl:if><xsl:apply-templates mode="formView" select="*"/>
</xsl:template>

<xsl:template mode="formView" match="px:layout/px:field">
<xsl:if test="position()&gt;1">,</xsl:if><xsl:apply-templates mode="fieldContainer" select="."/>
</xsl:template>

<xsl:template mode="formView" match="px:fieldContainer/px:field">
<xsl:if test="position()&gt;1">,</xsl:if><xsl:apply-templates mode="dataField" select="key('fields', @fieldId)"/>
</xsl:template>

<!-- <xsl:template mode="formView" match="px:groupTabPanel/px:field">
<xsl:if test="position()&gt;1">,</xsl:if>{
	xtype:'panel'
	,frame:true
	,items:[<xsl:apply-templates mode="fieldContainer" select="."/>]
}
</xsl:template>

 --><xsl:template name="px:groupTabPanel.panel">
	{
		xtype: 'portalpanel',
		title: '<xsl:value-of select="@name"/>',
		iconCls: 'x-icon-users',
		tabTip: '',
		//style: 'padding: 10px;',
		frame: true,
		border: false,
		layout: 'fit',
		items: [{
			flex: 1,
			items: [{
				xtype: 'panel',
				frame: true,
				border: false,
				defaults: {
					anchor: 'none'
				},
				items: [
					<xsl:apply-templates select="*[not(name(.)='px:subGroupTabPanel')]" mode="formView"/>
					]
				}]
			}
		]
	}
</xsl:template>

<xsl:template match="px:groupTabPanel" mode="formView">
<xsl:if test="position()&gt;1">,</xsl:if>{
	mainItem: 0,
	items: [<xsl:call-template name="px:groupTabPanel.panel"/><xsl:if test="px:subGroupTabPanel">,<xsl:apply-templates select="px:subGroupTabPanel" mode="formView"/></xsl:if>]
}
</xsl:template>

<xsl:template name="px:groupTabPanel" match="px:layout[px:groupTabPanel]" mode="formView">
<xsl:if test="position()&gt;1">,</xsl:if>function() { var grouptabpanel = Ext.create('Ext.ux.GroupTabPanel', {
	xtype: 'grouptabpanel',
	padding: '10 5 3 10',
	activeGroup: 0,
	items: [<xsl:apply-templates select="px:groupTabPanel" mode="formView"/>]
});
grouptabpanel.items.items[0].width=250; //se tiene que definir así porque no tiene configuración
return grouptabpanel;
}()
</xsl:template>

<xsl:template name="px:subGroupTabPanel" match="px:subGroupTabPanel" mode="formView">
<xsl:if test="position()&gt;1">,</xsl:if><xsl:call-template name="px:groupTabPanel.panel"/>
</xsl:template>

<xsl:template mode="headerText" priority="-1" match="px:fieldContainer|px:fieldSet"><xsl:value-of select="@name"/></xsl:template>
<xsl:template mode="headerText" priority="-1" match="px:fieldContainer[@name=px:field/@fieldName]"><xsl:apply-templates mode="headerText" select="key('fields', px:field[1]/@fieldId)"/></xsl:template>

<xsl:template mode="formView" match="px:fieldContainer">
<xsl:variable name="fields" select="key('fields', px:field/@fieldId)"/>
<xsl:variable name="required"><xsl:apply-templates select="$fields" mode="required"/></xsl:variable>
<xsl:if test="position()&gt;1">,</xsl:if>{
		xtype: 'fieldcontainer'/*px:fieldContainer*/
		, itemId: "<xsl:apply-templates mode="container_id" select="."/>"
		, fieldLabel: '<xsl:if test="not(ancestor::*[@mode='fieldselector'])"><xsl:apply-templates select="." mode="headerText"/></xsl:if>'
		<xsl:apply-templates mode="field.config.labelSeparator" select="$fields"/>
		<xsl:apply-templates mode="field.config.beforeLabelTextTpl" select="$fields"/>
		<xsl:apply-templates mode="field.config.afterLabelTextTpl" select="$fields"/>
	    , labelWidth: <xsl:apply-templates mode="labelWidth" select="."/>
		, layout: <xsl:choose><xsl:when test="@Orientation='horizontal'">'hbox'</xsl:when><xsl:otherwise>'vbox'</xsl:otherwise></xsl:choose>
		, width: "100%"	
		<xsl:if test="not(count(*)=1 or @Orientation='horizontal')">, hideLabel: true </xsl:if>
		, defaults: { hideEmptyLabel:false, <xsl:if test="count(*)=1 or @Orientation='horizontal'">hideLabel: true, </xsl:if><!-- labelAlign: 'right',  -->anchor: 'none', flex: 0, <xsl:apply-templates select="." mode="container.items.defaultConfig"/>}
		, <xsl:apply-templates select="." mode="container.config"/>
		, items: [<xsl:apply-templates select="*" mode="formView"/>]
	}
</xsl:template>

<xsl:template mode="formView" match="px:fieldContainer[@name=key('fields', px:field/@fieldId)[@dataType='bit']/@fieldName]|px:fieldSet[@name=key('fields', px:field/@fieldId)[@dataType='bit']/@fieldName]">
<xsl:variable name="container" select="."/>
<xsl:variable name="linkedField" select="key('fields', px:field/@fieldId)[@dataType='bit'][@fieldName=$container/@name]"/>
<xsl:if test="position()&gt;1">,</xsl:if>/*<xsl:value-of select="key('fields', px:field/@fieldId)[@dataType='bit']"/>*/{
		xtype: "fieldset"
		,itemId: "<xsl:apply-templates select="." mode="container_id"/>"
		,title: '<xsl:apply-templates select="$linkedField" mode="headerText"/> <xsl:if test="not(ancestor-or-self::*[@mode='fieldselector']) and string($linkedField/@description)!=''"><img src="../../../../Images/advise/vbQuestion.gif" width="15" data-qtip="{$linkedField/@description}"/></xsl:if>'
		,checkboxToggle: true
		<xsl:if test="$linkedField">,checkboxName: "<xsl:value-of select="$linkedField/@fieldName" disable-output-escaping="yes"/>"</xsl:if>
		,collapsed: true
		,layout: <xsl:choose><xsl:when test="@Orientation='horizontal'">'hbox'</xsl:when><xsl:otherwise>'vbox'</xsl:otherwise></xsl:choose>
		,defaults: { <xsl:if test="count(*)=1 or @Orientation='horizontal'">hideLabel: true, </xsl:if><!-- labelAlign:'right',  -->anchor: 'none', flex:0, columnWidth:50, <xsl:apply-templates select="@fieldContainer" mode="fieldset.items.defaultConfig"/>}
		,<xsl:apply-templates select="$linkedField" mode="container.config"/>
		,items: [<xsl:apply-templates select="px:field[@fieldId!=$linkedField/@fieldId]" mode="formView"/>, {xtype:"displayfield", flex:1}]
		<xsl:variable name="onexpand"><xsl:apply-templates select="." mode="container.onexpand"/></xsl:variable>
		<xsl:variable name="oncollapse"><xsl:apply-templates select="." mode="container.oncollapse"/></xsl:variable>
		, listeners: {
			<xsl:if test="$onexpand!=''">expand: <xsl:value-of select="$onexpand"/></xsl:if>
			<xsl:if test="$oncollapse!=''"><xsl:if test="$onexpand!=''">,</xsl:if>collapse: <xsl:value-of select="$oncollapse"/></xsl:if>
		}
	}
</xsl:template>

<xsl:template match="*" mode="fieldContainer.quickTips"><xsl:if test="position()&gt;1"> / </xsl:if><xsl:apply-templates select="." mode="headerText"/>: <xsl:value-of select="@description"/>.</xsl:template>

<xsl:template match="px:field|px:fields/*" mode="fieldContainer">
	<xsl:param name="id"><xsl:apply-templates select="." mode="container_id"/></xsl:param>
	<xsl:variable name="field" select="key('fields', descendant-or-self::px:field/@fieldId)"/>
	<xsl:variable name="required"><xsl:apply-templates select="$field" mode="required"/></xsl:variable>
	<xsl:if test="position()&gt;1">,</xsl:if>/*<xsl:value-of select="key('fields', px:field/@fieldId)[@dataType='bit']"/>*/{
		<xsl:choose>
			<xsl:when test="$field/@relationshipType='hasOne' and $field/@dataType='foreignTable'">xtype: "fieldset", title: '<xsl:if test="not(ancestor::*[@mode='fieldselector'])"><xsl:apply-templates select="$field" mode="headerText"/></xsl:if>'</xsl:when>
			<xsl:otherwise>xtype: "fieldcontainer", fieldLabel: '<xsl:if test="not(ancestor::*[@mode='fieldselector'])"><xsl:apply-templates select="$field" mode="headerText"/></xsl:if>'</xsl:otherwise>
		</xsl:choose>
		/*formField*/
		, itemId: "<xsl:value-of select="$id"/>"
		
		<xsl:if test="string($field/@hideLabel)!=''">, hideLabel: <xsl:value-of select="$field/@hideLabel"/></xsl:if>
		<xsl:apply-templates mode="field.config.labelSeparator" select="$field"/>
		<xsl:apply-templates mode="field.config.beforeLabelTextTpl" select="$field"><xsl:with-param name="name" select="$field/@fieldName"/></xsl:apply-templates>
		<xsl:apply-templates mode="field.config.afterLabelTextTpl" select="$field"/>
	    , labelWidth: <xsl:apply-templates mode="labelWidth" select="$field"/>
		, layout: 'hbox'
		, width: "100%"	
		, defaults: { labelAlign:'right', hideLabel: true, anchor: 'none', flex: 0, <xsl:apply-templates select="$field" mode="container.items.defaultConfig"/>}
		, <xsl:apply-templates select="$field" mode="container.config"/>
		, <xsl:apply-templates select="." mode="container.config"/>
		, items: [<xsl:apply-templates mode="dataField" select="$field"/>]
	}
</xsl:template>

<xsl:template mode="Form.Content" match="*[@dataType='table'][px:layout]" priority="-1">
	<xsl:apply-templates select="px:layout" mode="formView"/>
</xsl:template>


<xsl:template match="px:subGroupTabPanel" mode="formView" priority="-1">
<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>, 
	<xsl:call-template name="portlet.private"><xsl:with-param name="title" select="$subGroupTabPanel"/><xsl:with-param name="groupTabPanel" select="$groupTabPanel"/><xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/></xsl:call-template>
</xsl:template>
					
<xsl:template match="*[@dataType='table']/px:fields/*" mode="formView.portlet.Template" priority="-1">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="portlet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'portlet'"/></xsl:call-template></xsl:param>
	{
		title: '<xsl:choose><xsl:when test="$subGroupTabPanel!=''"><xsl:value-of select="$subGroupTabPanel"/></xsl:when><xsl:otherwise><xsl:value-of select="$groupTabPanel"/></xsl:otherwise></xsl:choose><xsl:if test="self::*[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))]/@portlet!=''"> - <xsl:value-of select="@portlet"/></xsl:if><!-- <xsl:value-of select="$groupTabPanel"/> - <xsl:value-of select="$subGroupTabPanel"/> (<xsl:value-of select="name(.)"/>: <xsl:value-of select="@portlet"/>)  -->',
		closable: false,
		layout: 'anchor',
		items: [<xsl:call-template name="tabPanel.private"><xsl:with-param name="title" select="$subGroupTabPanel"/><xsl:with-param name="groupTabPanel" select="$groupTabPanel"/><xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/><xsl:with-param name="portlet" select="$portlet"/></xsl:call-template>null]	
	},
</xsl:template>

<xsl:template match="*[@dataType='table']/px:fields/*[@tabPanel]" mode="formView.tabPanel.Template" priority="-1">
<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="portlet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="tabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>
{
	title:'<xsl:value-of select="@tabPanel"/>',
	defaultType: 'textfield',
	items: [<xsl:call-template name="fieldSetGroup.private"><xsl:with-param name="groupTabPanel" select="$groupTabPanel"/><xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/><xsl:with-param name="portlet" select="$portlet"/><xsl:with-param name="tabPanel" select="$tabPanel"/></xsl:call-template>]
},
</xsl:template>

<xsl:template match="px:data/px:dataRow/*|px:fields/*" mode="formView.fieldSetGroup.Template" priority="-1">
<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="portlet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="tabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>
<xsl:param name="fieldSet"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'fieldSet'"/></xsl:call-template></xsl:param>
<xsl:param name="items" select=".|following-sibling::*[key('visibleFields', @fieldId)]"/>
<xsl:param name="scope" select="$items[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][key('portlet',concat(generate-id(),'::',$portlet))][key('tabPanel',concat(generate-id(),'::',$tabPanel))][key('fieldSet',concat(generate-id(),'::',$fieldSet))]"/>

<xsl:variable name="headOfGroup"><xsl:call-template name="getHeadOfGroup"><xsl:with-param name="key" select="'fieldSet'"/><xsl:with-param name="scope" select="$scope"/></xsl:call-template></xsl:variable>

{
	xtype:'fieldset',
	title: '<!-- <xsl:value-of select="$groupTabPanel"/>::<xsl:value-of select="$subGroupTabPanel"/>::<xsl:value-of select="$tabPanel"/>::<xsl:value-of select="$fieldSet"/>:  --><xsl:apply-templates select="@fieldSet" mode="headerText" />',
	defaultType: 'textfield',
	layout: 'anchor',
	defaults: {
		anchor: 'none', labelWidth:75
	}
	, items: [<xsl:call-template name="fieldContainer.private"><xsl:with-param name="groupBy" select="'fieldSet'"/><xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/><xsl:with-param name="portlet" select="$portlet"/><xsl:with-param name="tabPanel" select="$tabPanel"/><xsl:with-param name="fieldSet" select="$fieldSet"/></xsl:call-template>]
	<!-- , items: [{xtype:'displayfield', flex:1, value:'dummy'}] -->
},
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="modelName"><xsl:variable name="ancestorTable" select="ancestor::*[@dataType='table'][1]"/><xsl:if test="$ancestorTable"><xsl:apply-templates select="$ancestorTable" mode="modelName"/>.</xsl:if><xsl:value-of select="@dbId"/>.<xsl:value-of select="@xml:lang"/>.<xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/>.<xsl:value-of select="translate(@mode, $uppercase, $smallcase)"/>.<xsl:value-of select="@controlType"/></xsl:template>

<xsl:template match="*[@dataType='table']" mode="Model">
<xsl:variable name="catalogName" select="concat(@Table_Schema,'.',@Table_Name)"/>
<xsl:variable name="parentAssociation" select="ancestor::*[@dataType='junctionTable' or @dataType='foreignTable'][1]"/>
Ext.define("<xsl:apply-templates select="." mode="modelName"/>", {
    extend: 'Ext.data.Model'
    <xsl:if test="string(@identityKey)!=''">, idProperty: '<xsl:if test="$parentAssociation"><xsl:value-of select="$parentAssociation/@Column_Name"/>.</xsl:if><xsl:value-of select="@identityKey"/>'</xsl:if>
    , primaryKeys: '<xsl:value-of select="@primaryKey"/>'
    , fields: [<xsl:if test="ancestor::*[@dataType='junctionTable']">{ name:'checked', type: 'bool', submitValue: false }<!-- , { name: 'expanded', defaultValue: true } TODO: poder ligar campos de la tabla con estas propiedades -->,
</xsl:if><xsl:apply-templates select="px:fields/*[not((@dataType='junctionTable' or @dataType='foreignTable') and ../../@controlType!='gridView')]" mode="Model.fields"/>]
	, validations: []
	<xsl:if test="px:fields/*[@dataType='junctionTable' or @dataType='foreignTable']">
	, associations: [<xsl:for-each select="px:fields/*[@dataType='junctionTable' or @dataType='foreignTable']"><xsl:if test="position()&gt;1">,</xsl:if>
	{ type: '<xsl:choose><xsl:when test="@relationshipType='hasOne' and @dataType='foreignTable'"><xsl:value-of select="@relationshipType"/></xsl:when><xsl:otherwise>hasMany</xsl:otherwise></xsl:choose><!-- TODO: Debería tener el tipo de relación que dice la base de datos, provisionalmente se aplica a las tablas autoreferenciadas -->', model: "<xsl:apply-templates select="*" mode="modelName"/>", name: "<xsl:value-of select="@Column_Name"/>",  tableName: '<xsl:value-of select="*/@Table_Schema"/>.<xsl:value-of select="*/@Table_Name"/>' ,primaryKey: "<xsl:value-of select="*/@primaryKey"/>", identityKey: '<xsl:value-of select="*/@identityKey"/>', foreignKey: "<xsl:value-of select="@foreignReference"/>", associationKey: "<xsl:value-of select="@Column_Name"/>", reader: { type: 'json', root: 'data' }}</xsl:for-each>]</xsl:if>
	<xsl:if test="ancestor::*[1][@dataType='junctionTable' or @dataType='foreignTable']">
	, belongsTo: "<xsl:apply-templates select="ancestor::*[@dataType='table'][1]" mode="modelName"/>"</xsl:if>
});
<xsl:for-each select="px:fields/*[@dataType='foreignTable']">
<xsl:apply-templates select="*" mode="Model"/><!-- var store_<xsl:value-of select="@fieldId"/>  = Ext.create('Ext.data.Store', {
	model: '<xsl:value-of select="*/@Table_Schema" />.<xsl:value-of select="*/@Table_Name" />',
	data: [<xsl:for-each select="*/px:data/px:dataRow"><xsl:if test="position()&gt;1">,</xsl:if>{ <xsl:for-each select="*[not(key('fields', @fieldId)/@dataType='junctionTable' or key('fields', @fieldId)/@dataType='foreignTable')]">"<xsl:value-of select="key('fields', @fieldId)/@Column_Name"/>": "<xsl:value-of select="@value"/>",</xsl:for-each>}</xsl:for-each>]
}); -->
</xsl:for-each>

<xsl:for-each select="px:fields/*[@dataType='junctionTable']">
<xsl:apply-templates select="*" mode="Model"/><!-- var store_<xsl:value-of select="@fieldId"/>  = Ext.create('Ext.data.TreeStore', {
	model: '<xsl:value-of select="*/@Table_Schema" />.<xsl:value-of select="*/@Table_Name" />',
	root: {"text":".","children": [ <xsl:apply-templates select="*/px:data/px:dataRow" mode="json" /> ]}
}); -->
</xsl:for-each>
</xsl:template>


<xsl:template match="*" mode="Store.Config">undefined:undefined</xsl:template>


<xsl:template match="px:data/px:dataRow/*" mode="fieldValue">"<xsl:value-of select="key('fields', @fieldId)/@Column_Name"/>":<xsl:apply-templates select="." mode="json.value"/>,</xsl:template>

<!-- <xsl:template match="*[@dataType='table']" mode="layout">
container.add(formView)
</xsl:template> -->


<xsl:template match="*[@dataType='table']" mode="data.Store">
Ext.create('Panax.custom.AjaxStore', {
	autoLoad: true
	, autoSync: true
	, autoDestroy: true
	, pageSize: 1
	, defaultPageSize: <xsl:value-of select="@pageSize" />
	, remoteSort: true
	, model: "<xsl:apply-templates select="." mode="modelName"/>"
	<xsl:if test="*[@groupByColumn='true'] or 1=0">, groupField: 'IdVendedor',//'<xsl:value-of select="*[@groupByColumn='true'][1]/@Column_Name"/>'</xsl:if>
	, settings: {
		catalogName: "<xsl:value-of select="@Table_Schema" />.<xsl:value-of select="@Table_Name" />"
		, filters: me.filters?me.filters:(!me.identity?"0=0":"[<xsl:value-of select="@identityKey" />]="+me.identity)
		, identityKey: "<xsl:value-of select="@identityKey" />"
		, primaryKey: "<xsl:value-of select="@primaryKey" />"
		, mode: "<xsl:value-of select="@mode" />"
		, lang: "<xsl:value-of select="@xml:lang" />"
	}
	, <xsl:apply-templates select="." mode="Store.Config"/>
	
})
</xsl:template>



</xsl:stylesheet>