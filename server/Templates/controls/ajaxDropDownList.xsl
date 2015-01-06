<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax"
>

<xsl:template match="*[@controlType]/px:data/*" mode="selector.option" priority="-1">/*selector.option no está definido*/</xsl:template>

<xsl:template match="*[@controlType]/px:data/*[not(@value)]" mode="combobox.option" priority="-1">/*combobox.option no está definido*/</xsl:template>

<xsl:template match="*[not(@dataType) and (@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]/px:data/*" mode="selector.option" priority="-1">
	<xsl:if test="position()&gt;1">,</xsl:if><xsl:apply-templates mode="combobox.option" select="."/>
</xsl:template>

<xsl:template mode="itemWidth" match="*[(@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" priority="-1">150</xsl:template>

<xsl:template mode="control.config" match="*[(@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" priority="-1">undefined:undefined</xsl:template>

<xsl:template mode="control.config.insertEnabled" match="*[(@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" priority="-1"><xsl:choose><xsl:when test="@supportsInsert='1' and not(string(@disableInsert)='true')">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:template>

<xsl:template mode="control.config.editEnabled" match="*[(@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" priority="-1"><xsl:choose><xsl:when test="@supportsUpdate='1' and not(string(@disableEdit)='true')">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:template>

<xsl:template mode="control.config.deleteEnabled" match="*[(@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" priority="-1"><xsl:choose><xsl:when test="@supportsDelete='1' and not(string(@disableDelete)='true')">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:template>

<xsl:template mode="control.config.refreshEnabled" match="*[(@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" priority="-1"><xsl:choose><xsl:when test="@disableRefresh='true'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:template>


<xsl:template name="ajaxDropDownList" match="*[not(@dataType) and (@controlType='ajaxDropDownList' or @controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='ajaxDropDownList' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]">

<xsl:param name="name"><xsl:choose>
	<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
	<xsl:when test="../@foreignKey and @primaryKey"><xsl:value-of select="ancestor::*[@Column_Name][1]/@Column_Name"/>_<xsl:value-of select="count(ancestor::*[@Column_Name][1]/descendant::*[not(name(.)='px:data')])-1"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="../@Column_Name"/></xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="id"><xsl:apply-templates select="." mode="cmp_id"/></xsl:param>
<xsl:param name="required"><xsl:apply-templates select="." mode="required"/></xsl:param>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass" select="@cssClass"/>

<!-- Mode: <xsl:value-of select="name(..)"/> vs. <xsl:value-of select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/> -->
xtype: 'ajaxdropdown'
, mode: 'local'
, queryMode: 'local'
, triggerAction: 'all'
<!-- multiSelect: true, -->
, typeAhead: true
, fieldLabel: '<xsl:apply-templates select="." mode="headerText"/>'
, emptyText: '<xsl:apply-templates select="." mode="emptyText"/>'
//width: 400
<xsl:if test="@enforceConstraint">, enforceConstraint: Boolean(<xsl:value-of select="@enforceConstraint"/>)</xsl:if>
//forceSelection: true <!-- se quita para que pueda poner el valor sin que lo borre, se habilita en el listener change -->
, settings: {
	catalogName: "<xsl:value-of select="@Table_Schema" />.<xsl:value-of select="@Table_Name" />",
	filters: "<xsl:value-of select="@filters" />",
	dataValue: "<xsl:value-of select="@dataValue" />",
	dataText: "<xsl:value-of select="@dataText" />", 
	primaryKey: "<xsl:value-of select="@primaryKey" />",
	foreignKey: "<xsl:value-of select="@foreignKey" />",/*<xsl:value-of select="name(.)"/>*/
	<xsl:if test="@orderBy">orderBy: "<xsl:value-of select="@orderBy"/>",</xsl:if>
	foreignTable: "<xsl:value-of select="*[not(name(.)='items')][string(@mode)!='none']/@Table_Name" />",	
	foreignElement: "<xsl:apply-templates select="*[not(name(.)='items')][string(@mode)!='none']" mode="field_id"/>",
	dependants: [<xsl:for-each select="ancestor::*[1][not(@dataType='foreignKey')][not(name(.)='items')][string(@mode)!='none']">"<xsl:apply-templates select="." mode="field_id"/>",</xsl:for-each>undefined],
	<xsl:apply-templates select="." mode="control.config"/>
	}
, insertEnabled: <xsl:apply-templates select="." mode="control.config.insertEnabled"/>
, editEnabled: <xsl:apply-templates select="." mode="control.config.editEnabled"/>
, deleteEnabled: <xsl:apply-templates select="." mode="control.config.deleteEnabled"/>
, refreshEnabled: <xsl:apply-templates select="." mode="control.config.refreshEnabled"/>
, store: Ext.create('Panax.ajaxDropDown', {model: "Panax.model.combobox"
<!-- , listeners: {
		datachanged: function(comboStore) {
		if (!(comboStore.enableInsert)) return;
			try { //quitar este try
				if (comboStore.find('id', Panax.REFRESH)==-1) comboStore.add({id:Panax.REFRESH, text: '[Actualizar...]'})
				if (comboStore.find('id', Panax.NEW)==-1) comboStore.add({id:Panax.NEW, text: '[Otro...]'})
			} catch(e) {}
		}
	} -->
})
, onSelect: <xsl:apply-templates select="." mode="control.onchange"/>
<!-- Ext.create('Ext.data.Store', {
    fields: ['id', 'text'],
    data : [{id:'1', text:'No capturado'}, {id:'9', text:'LA LOMAs'}, {id:'10', text:'OTRO'}]
}), -->

<!-- listeners: {
select: function(combo, records, eOptions) {
		if (combo.value=='<xsl:text disable-output-escaping="yes"><![CDATA[<refresh>]]>'</xsl:text>) {
			combo.select(combo.getStore().data.items[0]);
			combo.store.load();
			}
		else if (combo.value=='<xsl:text disable-output-escaping="yes"><![CDATA[<new>]]>'</xsl:text>) {
			combo.select(combo.getStore().data.items[0]);
			var win = Ext.create('widget.window', {
				title: 'Agregar nuevo registro',
				modal: true,
				closable: true,
				closeAction: 'hide',
				width: 800,
				minWidth: 350,
				height: 600,
				layout: {
					type: 'fit',
					padding: 5
				}
			});
			
			var container=win;
			//myMask.show();
			//var myMask = new Ext.LoadMask(container, {msg:"Cargando..."});
			Ext.Ajax.request({
				url: '../Templates/request.asp',
				method: 'GET',
				params: {
					catalogName: "<xsl:value-of select="@Table_Schema" />.<xsl:value-of select="@Table_Name" />",
					mode: "insert",
					output: 'extjs'
				},
				success: function(xhr) {
					eval(xhr.responseText);
					
				},
				failure: function() {
					//myMask.hide();
					Ext.Msg.alert("Error de comunicación", "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
				}
			});	

			win.show();	
		}
	},
},

store: Ext.create('Ext.data.Store', {
	autoLoad: true,
	fields: ['id', 'text'],
	<xsl:choose>
		<xsl:when test="px:data">
		data:[
			<xsl:for-each select="px:data/*">
			{id:'<xsl:value-of select="@value"/>', text:'<xsl:value-of select="@text"/>'},
			</xsl:for-each>
			]	
		</xsl:when>
		<xsl:otherwise>
		proxy: {
			type: 'ajax',
			url: '../Scripts/xmlCatalogOptions.asp',
			reader: {
				type: 'json',
				root: 'data',
				successProperty: 'success',
				messageProperty: 'message',
				totalProperty: 'total',
				idProperty: '<xsl:value-of select="@identityKey"/>'
			},
			pageParam: 'pageIndex',
			limitParam: 'pageSize',
			sortParam: 'sorters',
			extraParams: {
				catalogName: "<xsl:value-of select="@Table_Schema" />.<xsl:value-of select="@Table_Name" />",
				filters: "<xsl:value-of select="@dataText" /> NOT IN ('No capturado') <xsl:value-of select="@filters" />",
				dataValue: "<xsl:value-of select="@dataValue" />",
				dataText: "<xsl:value-of select="@dataText" />",
				output: 'json',
			},
			listeners: {
				exception: function(proxy, response, operation){
					//alert(response.responseText)
					Ext.MessageBox.show({
						title: 'ERROR!',
						msg: operation.getError(),
						icon: Ext.MessageBox.ERROR,
						buttons: Ext.Msg.OK
					});
				}
			},
		},
		</xsl:otherwise>
	</xsl:choose>
}), -->
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
