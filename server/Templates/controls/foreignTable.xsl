<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax"
>
<xsl:strip-space elements="*"/>

<xsl:template mode="itemHeight" match="*[@dataType='foreignTable']/*" priority="-1">150</xsl:template>
<xsl:template mode="itemHeight" match="*[@dataType='foreignTable']/*[@controlType='formView']" priority="-1"></xsl:template>
<xsl:template mode="itemWidth" match="*[@dataType='foreignTable']/*" priority="-1">350</xsl:template>

<xsl:template match="*[@dataType='foreignTable']" mode="emptyText" priority="-.5">Sin registros</xsl:template>

<xsl:template match="*[@dataType='foreignTable']/*" mode="dockedItems" priority="-1">
<xsl:call-template name="dockedItems.default"/>
</xsl:template>

<xsl:template name="dockedItems.default">
{
	iconCls: 'add',
	text: 'Nuevo',
	itemId: 'addButton',
	scope: this,
	handler: function() { 
		var grid = Ext.ComponentQuery.query("#<xsl:value-of select="../@Column_Name"/>")
		grid[0].onAddClick()
		}
}, {
	iconCls: 'remove',
	text: 'Borrar',
	disabled: true,
	itemId: 'deleteButton',
	scope: this,
	handler: function() { 
		var grid = Ext.ComponentQuery.query("#<xsl:value-of select="../@Column_Name"/>")
		grid[0].onDeleteClick()
		}
		
}
</xsl:template>

<xsl:template name="foreignTable" match="*[@dataType='foreignTable']">
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="*[@dataType='foreignTable']/*[@controlType='formView']">
<xsl:param name="itemWidth"><xsl:apply-templates mode="itemWidth" select="."/></xsl:param>
<xsl:param name="itemHeight"><xsl:apply-templates mode="itemHeight" select="."/></xsl:param>
	xtype: 'panaxform'
	<!-- , store: Ext.create('Ext.data.Store', {model: "<xsl:apply-templates select="." mode="modelName"/>", proxy: {type: 'memory'}}) -->
	<xsl:if test="string($itemHeight)!=''">, height: <xsl:value-of select="$itemHeight"/></xsl:if>
	<xsl:if test="string($itemWidth)!=''">, width: <xsl:value-of select="$itemWidth"/></xsl:if>
	, <xsl:apply-templates select="." mode="Form.Config"/>
	, itemId: "<xsl:value-of select="../@Column_Name"/>"
	, items: [<xsl:apply-templates select="." mode="Form.Content"/>]
</xsl:template>

<xsl:template match="*[@dataType='foreignTable']/*[@controlType='gridView']"><!--  and (@controlType='inlineTable' or @controlType='embeddedTable') -->
<xsl:param name="itemWidth"><xsl:apply-templates mode="itemWidth" select="."/></xsl:param>
<xsl:param name="itemHeight"><xsl:apply-templates mode="itemHeight" select="."/></xsl:param>
	xtype: 'foreigntable'
	, itemId: "<xsl:value-of select="../@Column_Name"/>"
	, border: false
	, resizable: true
	, multiSelect: true
	, autoScroll: true
	<xsl:if test="string($itemHeight)!=''">, height: <xsl:value-of select="$itemHeight"/></xsl:if>
	<xsl:if test="string($itemWidth)!=''">, width: <xsl:value-of select="$itemWidth"/></xsl:if>
	, <xsl:apply-templates select="." mode="Form.Config"/>
	, dockedItems: [{
		xtype: 'toolbar',
		items: [<xsl:apply-templates select="." mode="dockedItems"/>]
		}]
	, columns: [<xsl:apply-templates select="." mode="row.header"/>
	<xsl:apply-templates select="px:fields/*[not(@dataType='junctionTable' or @dataType='foreignTable')][not(@dataType='identity')]" mode="gridView.columns.column"/>
		<!-- <xsl:for-each select="*/px:fields/*[not(@dataType='identity')]"><xsl:if test="position()&gt;1">,</xsl:if>{
		<xsl:variable name="currentFieldId" select="@fieldId"/>
		header: "<xsl:apply-templates select="." mode="headerText"/>", 
		flex: 1,
		menuDisabled: true,
		hideable: false,
		sortable: false, 
		draggable: false,
		groupable: false,		
		dataIndex: "<xsl:value-of select="@Column_Name"/>"
	}</xsl:for-each> -->]
	

	, onBeforeEdit: function(editor, e, eOpts) {
	}

	, onAddClick: function(){
		var rec = new <xsl:apply-templates select="." mode="modelName"/>(), edit = this.editing, grid=this;
		function removeColumns(element, index, array){ 
			return element.xtype!="actioncolumn";
		}
        edit.cancelEdit();
        this.store.insert(0, rec);
		edit.startEditByPosition({row: 0, column: grid.columns.filter(removeColumns)[0].getIndex()})
        //edit.startEditByPosition({ row: 0, column: 0 });
       <!-- Ext.MessageBox.show({
			title: 'Agregando!',
			msg: "Success",
			icon: Ext.MessageBox.INFO,
			buttons: Ext.Msg.OK
		}); -->
    }<!-- ,
	loadMask: true,
	columnLines: false,
	selModel: Ext.create('Ext.selection.RowModel', {
	        listeners: {
	            selectionchange: function(sm, selections) {
	                Ext.getCmp('<xsl:value-of select="@Column_Name"/>').onSelectChange(sm, selections);
	            }
	        }
	    }),
	dockedItems: [{
		xtype: 'toolbar',
		items: [{
			iconCls: 'add',
			text: 'Add',
			scope: this,
			handler: this.onAddClick
		}, {
			iconCls: 'remove',
			text: 'Delete',
			disabled: true,
			itemId: 'delete',
			scope: this,
			handler: this.onDeleteClick
		}]
	}],
    
    onSelectChange: function(selModel, selections){
        this.down('#delete').setDisabled(selections.length === 0);
    },

    onSync: function(){
        this.store.sync();
    },

    onDeleteClick: function(){
        var selection = this.getView().getSelectionModel().getSelection()[0];
        if (selection) {
            this.store.remove(selection);
        }
    },

    onAddClick: function(){
        var rec = new Writer.Person({
            first: '',
            last: '',
            email: ''
        }), edit = this.editing;

        edit.cancelEdit();
        this.store.insert(0, rec);
        edit.startEditByPosition({
            row: 0,
            column: 1
        });
    } -->
</xsl:template>
</xsl:stylesheet>
