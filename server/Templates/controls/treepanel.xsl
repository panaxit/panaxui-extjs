<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax"
>

<xsl:template mode="itemHeight" match="*[@referencesItself='true' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default']" priority="-1">150</xsl:template>
<xsl:template mode="itemWidth" match="*[@referencesItself='true' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default']" priority="-1">550</xsl:template>

<xsl:template match="*" mode="field.maxSelections">undefined</xsl:template>
<xsl:template match="*[@referencesItself='true' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default']" mode="field.maxSelections">1</xsl:template>
<xsl:template match="*[@maxSelections]" mode="field.maxSelections"><xsl:value-of select="@maxSelections"/></xsl:template>
<xsl:template match="*[@relationshipType='hasOne']" mode="field.maxSelections">1</xsl:template>

<xsl:template match="*" mode="field.minSelections">undefined</xsl:template>
<xsl:template match="*[@minSelections]" mode="field.minSelections"><xsl:value-of select="@minSelections"/></xsl:template>

<xsl:template mode="control.onCheckEvent" match="*" priority="-1">function(control, rowIndex, checked, eOpts){return undefined}</xsl:template>

<xsl:template name="treePanel" match="*[@referencesItself='true' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default']|*[@dataType='junctionTable' and @controlType='default'][*/px:fields/*[@isPrimaryKey=1]/*[@referencesItself='true']]">
	<!--@relationshipType='hasOne' or-->
	<xsl:param name="name"><xsl:choose>
	<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
	<xsl:when test="../@foreignKey and @primaryKey"><xsl:value-of select="@Column_Name"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="../@Column_Name"/></xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="id"><xsl:apply-templates select="." mode="cmp_id"/></xsl:param>
<xsl:param name="required"><xsl:apply-templates select="." mode="required"/></xsl:param>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>
<xsl:param name="itemWidth"><xsl:apply-templates mode="itemWidth" select="."/></xsl:param>
<xsl:param name="itemHeight"><xsl:apply-templates mode="itemHeight" select="."/></xsl:param>
<xsl:variable name="parentAssociation" select="."/>
<!-- revisar  http://www.sencha.com/forum/showthread.php?138496-MVC-hasMany-associations-with-nested-treestore-data -->
<!-- Mode: <xsl:value-of select="name(..)"/> vs. <xsl:value-of select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/> -->
	xtype: "customtreepanel"
	,store: Ext.create('Panax.data.TreeStore', {<xsl:if test="not(ancestor::*[@dataType='foreignKey'])">model: '<xsl:apply-templates mode="modelName" select="*"/>'</xsl:if>})
	,width: 500
	,height: 300
	,itemId: "<xsl:value-of select="@fieldName"/>"
	,hideHeaders: <xsl:choose><xsl:when test="*/px:fields/*[not(@isPrimaryKey=1 or @isIdentity=1)]">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose>
	<!-- store: store_junction --><!-- <xsl:value-of select="@fieldId"/> -->
	,collapsible: false
    ,useArrows: true
    ,rootVisible: false
	,resizable: true
	,singleExpand: true
	,multiSelect: true
	,autoScroll: true
	<xsl:if test="string($itemHeight)!=''">, height: <xsl:value-of select="$itemHeight"/></xsl:if>
	<xsl:if test="string($itemWidth)!=''">, width: <xsl:value-of select="$itemWidth"/></xsl:if>
	,maxSelections: <xsl:apply-templates select="." mode="field.maxSelections"/>
	,minSelections: <xsl:apply-templates select="." mode="field.minSelections"/>
	,columns: [
		function () { 
		var me = Ext.create('Ext.tree.Column', {
            header: "<xsl:apply-templates select="." mode="headerText"/>", 
			flex: 2,
            sortable: true,
            displayValue: 'value',
			displayField: 'text',
            dataIndex: '<xsl:choose><xsl:when test="ancestor::*[@dataType='foreignKey']">text</xsl:when><xsl:otherwise><xsl:if test="$parentAssociation"><xsl:value-of select="$parentAssociation/@fieldName"/>.</xsl:if><xsl:value-of select="*/px:fields/*[@isPrimaryKey=1]/@fieldName"/></xsl:otherwise></xsl:choose>'
			, renderer: function(value, metaData, record, rowIndex, colIndex, store, view){ 
				return Ext.isObject(value)?value[me.displayField]:value 
			}
		});
		return me;
		}()
		<!-- {
            xtype: 'checkcolumn',
            dataIndex: 'checked',
            width: 55,
            stopSelection: false,
			listeners: {
				beforecheckchange: function( control, rowIndex, checked, eOpts) {
					var grid=control.up('grid')
					var c=checked?1:-1;
					Ext.Array.each((grid.getStore().data.items || []), function(record) {
						if (record.get('checked')) {
							++c
						}
					})
<xsl:text disable-output-escaping="yes"><![CDATA[ 
					if (c>grid.maxSelections && checked) {
						alert("Sólo se pueden seleccionar "+grid.maxSelections+" opciones");
						checked=false;
					}
]]></xsl:text>
				if (grid.onCheckEvent) grid.onCheckEvent(control, rowIndex, checked, eOpts)
				}
			}
        },  -->
		<xsl:if test="*/px:fields/*[not(@isPrimaryKey=1 or @isIdentity=1)]">, <xsl:apply-templates select="*/px:fields/*[not(@isPrimaryKey=1 or @isIdentity=1)]" mode="gridView.columns.column"/></xsl:if>]
	, loadMask: true
	, columnLines: false
	, emptyText: 'No Matching Records'
	, onCheckEvent: <xsl:apply-templates mode="control.onCheckEvent" select="."/>
  <xsl:choose>
	<xsl:when test="$mode='readonly'">
	, readOnly: true
	</xsl:when>
	<xsl:otherwise>
		<!-- <select turnOn="true" class="catalog {$cssClass}" oncontextmenu="cancelBubble(); return false;">
			<xsl:attribute name="opt_new"><xsl:choose><xsl:when test="not(ancestor::*[@mode='filters'] or contains(@filters, '[#primaryTable].')) and string(@disableInsert)!='true'">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="*[string(@mode)!='none']"><xsl:attribute name="parentObject"><xsl:value-of select="concat('field_', ancestor::*[@dataType='foreignKey'][1]/@Column_Name, '_', generate-id(*))"/></xsl:attribute></xsl:if>
			<xsl:if test="@filters!='' and not(@disableAppFilters='true')"><xsl:attribute name="filters"><xsl:choose>
	<xsl:when test="starts-with(@filters, $apostrophe)"><xsl:value-of select="@filters"/></xsl:when>	
	<xsl:otherwise>'<xsl:value-of select="str:escapeApostrophe(string(@filters))"/>'</xsl:otherwise>
</xsl:choose></xsl:attribute></xsl:if>
			<xsl:if test="../@foreignKey and @primaryKey"><xsl:attribute name="isSubmitable">false</xsl:attribute></xsl:if>
			<xsl:if test="@isSubmitable"><xsl:attribute name="isSubmitable"><xsl:value-of select="@isSubmitable"/></xsl:attribute></xsl:if>
			<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:attribute name="catalogName"><xsl:if test="@Table_Schema"><xsl:value-of select="@Table_Schema"/>.</xsl:if><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:attribute name="dataValue"><xsl:choose><xsl:when test="@dataValue"><xsl:value-of select="@dataValue" /></xsl:when><xsl:otherwise><xsl:value-of select="@primaryKey" /></xsl:otherwise>
</xsl:choose></xsl:attribute>
			<xsl:attribute name="dataText"><xsl:value-of select="@dataText" /></xsl:attribute>
			<xsl:attribute name="primaryKey"><xsl:value-of select="@primaryKey" /></xsl:attribute>
			<xsl:attribute name="foreignKey"><xsl:value-of select="@foreignKey" /></xsl:attribute>
			<xsl:attribute name="foreignTable"><xsl:value-of select="name(*[not(name(.)='items')][string(@mode)!='none'])" /></xsl:attribute>
			<xsl:if test="@onchange"><xsl:attribute name="onchange"><xsl:value-of select="@onchange" disable-output-escaping="yes" /></xsl:attribute></xsl:if>
			<xsl:attribute name="dataField"> <xsl:value-of select="name(ancestor-or-self::*[parent::dataRow][1])" /> </xsl:attribute>
			<xsl:if test="@opt_all!=''"><xsl:attribute name="opt_all"><xsl:value-of select="@opt_all"/></xsl:attribute></xsl:if>
			<xsl:attribute name="opt_null">true</xsl:attribute>
			<xsl:if test="number($required)=0"><xsl:attribute name="opt_null">true</xsl:attribute></xsl:if>
			<xsl:if test="ancestor::*[@dataType='foreignKey'][1]/data"><xsl:attribute name="isUpdated">true</xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="ancestor::*[@dataType='foreignKey'][1]/data">
						<xsl:for-each select="ancestor::*[@dataType='foreignKey'][1]/data/*"><xsl:sort select="@sortOrder"/><xsl:sort select="@text"/>
							<option value="{@value}"><xsl:if test="@value=ancestor::*[@dataType='foreignKey'][1]/@value"><xsl:attribute name="selected">true</xsl:attribute></xsl:if><xsl:value-of select="@text"/></option>
						</xsl:for-each>
						<xsl:if test="not(ancestor::*[@mode='filters'] or contains(@filters, '[#primaryTable].')) and string(@disableInsert)!='true'"><OPTION id="opt_&lt;new&gt;" class="new systemOption" value="&lt;new&gt;">[New]</OPTION></xsl:if>
					</xsl:when>	
					<xsl:otherwise>
						<option selected="true">
						<xsl:choose>
							<xsl:when test="not(@required='true') and not(@value!='')">
							<xsl:attribute name="value"><xsl:value-of select="'NULL'" /></xsl:attribute>
								<xsl:value-of select="''"/>
								- -
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
								<xsl:value-of select="@text"/>
							</xsl:otherwise>
						</xsl:choose>			
						</option>
					</xsl:otherwise>
				</xsl:choose>
		</select> -->
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
