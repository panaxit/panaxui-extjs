<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:px="urn:panax">

<xsl:template match="*[@dataType='time']" mode="field.config.increment">/*<xsl:value-of select="name(.)"/>*/30</xsl:template>

<xsl:template match="Evento[@dataType='table']
" mode="Store.Config">customevents: {
	onload: function() {
		alert('on load')
	}
}</xsl:template>

<xsl:template match="Evento/px:layout//px:tab[@name='Datos Generales']" mode="container_id">evento_padres</xsl:template>

<xsl:template match="Evento/px:layout//px:tab[@name='Datos Evento']" mode="container_id">evento_pcd</xsl:template>

<xsl:template match="Evento/px:fields/FechaInicial" mode="field.config">vtype: 'daterange', endDateField: "<xsl:apply-templates mode="field_id" select="../FechaFinal"/>"</xsl:template>

<xsl:template match="Evento/px:fields/FechaFinal" mode="field.config">vtype: 'daterange', startDateField: "<xsl:apply-templates mode="field_id" select="../FechaInicial"/>"</xsl:template>

<xsl:template match="Evento/px:layout//px:tabPanel" mode="container.config">hidden:true</xsl:template>

<xsl:template match="Evento/px:fields/DatosGenerales/*
" mode="itemHeight"></xsl:template>

<xsl:template match="Evento/px:fields/TipoDeEvento/*
" mode="control.onchange">function(combo, records, eOptions) { 
	<xsl:variable name="tabPanel" select="key('table',../@fieldId)/px:layout//px:tabPanel[@name='Configuración del Evento']"/>
	var tabManager = Ext.ComponentQuery.query("#<xsl:apply-templates mode="container_id" select="$tabPanel"/>")[0]
	<xsl:text disable-output-escaping="yes"><![CDATA[ 
	tabManager.hide()
	tabManager.child("#evento_padres").tab.hide(true);
	tabManager.child("#evento_pcd").tab.hide(true);
	var selectedCard
	if (combo.value && combo.value.metaData && combo.value.metaData.TipoAsistentes=="Padres") {
		selectedCard=tabManager.child("#evento_padres");
	} else if (combo.value && combo.value.metaData && combo.value.metaData.TipoAsistentes=="PcD") {
		selectedCard=tabManager.child("#evento_pcd");
	}
	
	]]></xsl:text>
	if (selectedCard) {
		tabManager.show()
		selectedCard.tab.show(true);
		tabManager.setActiveTab(selectedCard);
	}
}
</xsl:template>

<xsl:template match="DatosGenerales[@dataType='table']
" mode="Form.Config">width:1100</xsl:template>

<xsl:template match="DatosGenerales/px:fields/Asistentes/*
" mode="itemWidth">600</xsl:template>

<xsl:template mode="itemWidth" match="Evento/px:fields/Configuracion">800</xsl:template>

<xsl:template mode="dockedItems" match="Configuracion/px:fields/Sesiones/*
| Configuracion/px:fields/GruposActivos/*">
</xsl:template>

<xsl:template mode="itemHeight" match="Configuracion/px:fields/Sesiones/*">150</xsl:template>

<xsl:template mode="row.header" match="Configuracion/px:fields/Sesiones/*">
{
	xtype: 'actioncolumn'
	, itemId: 'button_<xsl:apply-templates mode="field_id" select="."/>'
	, text: ''
	, width: 40
	, tooltip: 'Editar'
	, align: 'center'
	//, locked: false // Si se pone esta propiedad crea la parte de locked columns, lo que causa problemas cuando se intenta hacer un editbyposition porque 
	, hideable: false
	, icon: '../../../../resources/extjs/extjs-current/examples/simple-tasks/resources/images/edit_task.png'
	, handler: function(grid, rowIndex, colIndex, actionItem, event, record, row) {
		var win = Ext.create('widget.window', {
			title: 'Editar registro'
			, itemId: 'modalWindow'
			, modal: true
			, closable: true
			//, closeAction: 'hide'
			, width: 1000
			, minWidth: 350
			, height: 600
			, layout: {
				type: 'fit'
				, padding: 5
			}
		});
		var instance={
			catalogName: 'EventosPcD.Sesiones',
			mode:'edit'
		}
		if (!record.getId()) {
			var masterForm = this.up('form').up('form')
			masterForm.store.customevents.onaftersave=function(store, operation, eOpts, scope){
				Ext.ComponentQuery.query("#button_<xsl:apply-templates mode="field_id" select="."/>")[0].handler(grid, rowIndex, colIndex, actionItem, event, record, row)
				return false;
			}
			masterForm.save()
			
			/*Ext.MessageBox.show({
				title: 'Importante',
				msg: "Este registro no ha sido guardado, es necesario guardar cambios, actualizar e intentar acceder nuevamente",
				icon: Ext.MessageBox.INFO,
				buttons: Ext.Msg.OK
			});*/
		}
		if (record.getId()) {
			var content = Panax.getInstance(instance, {filters: '[IdSesion]='+record.getId()});
			if (content) {
				var container=win;
	<xsl:text disable-output-escaping="yes"><![CDATA[ 
				if (container.items.length>0) { 
					container.remove(0);
				}
		]]></xsl:text>
				container.add(content);
				container.show();
				container.animateTarget=row; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
				//var myMask = new Ext.LoadMask(container, {msg:"Cargando..."});
				//myMask.show();
				//myMask.hide();
			}
			else {
				//Ext.Msg.alert("Mensaje del servidor", "No se pudo recuperar el módulo");
			}
		}
	}
},
</xsl:template>
	
<xsl:template mode="row.header" match="Configuracion/px:fields/GruposActivos/*">
{
	xtype: 'actioncolumn'
	, itemId: 'button_<xsl:apply-templates mode="field_id" select="."/>'
	, text: ''
	, width: 40
	, tooltip: 'Editar'
	, align: 'center'
	, hideable: false
	, icon: '../../../../resources/extjs/extjs-current/examples/simple-tasks/resources/images/edit_task.png'
	, handler: function(grid, rowIndex, colIndex, actionItem, event, record, row) {
		var win = Ext.create('widget.window', {
			title: 'Editar registro'
			, itemId: 'modalWindow'
			, modal: true
			, closable: true
			//, closeAction: 'hide'
			, width: 1000
			, minWidth: 350
			, height: 600
			, layout: {
				type: 'fit'
				, padding: 5
			}
		});
		var instance={
			catalogName: 'EventosPcD.GruposActivos',
			mode:'edit'
		}
		if (!record.getId()) {
			var masterForm = this.up('form').up('form')
			masterForm.store.customevents.onaftersave=function(store, operation, eOpts, scope){
				Ext.ComponentQuery.query("#button_<xsl:apply-templates mode="field_id" select="."/>")[0].handler(grid, rowIndex, colIndex, actionItem, event, record, row)
				return false;
			}
			masterForm.save()
			
			/*Ext.MessageBox.show({
				title: 'Importante',
				msg: "Este registro no ha sido guardado, es necesario guardar cambios, actualizar e intentar acceder nuevamente",
				icon: Ext.MessageBox.INFO,
				buttons: Ext.Msg.OK
			});*/
		}
		if (record.getId()) {
			var content = Panax.getInstance(instance, {filters: '[IdGrupo]='+record.getId()});
			if (content) {
				var container=win;
	<xsl:text disable-output-escaping="yes"><![CDATA[ 
				if (container.items.length>0) { 
					container.remove(0);
				}
		]]></xsl:text>
				container.add(content);
				container.show();
				container.animateTarget=row; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
				//var myMask = new Ext.LoadMask(container, {msg:"Cargando..."});
				//myMask.show();
				//myMask.hide();
			}
			else {
				//Ext.Msg.alert("Mensaje del servidor", "No se pudo recuperar el módulo");
			}
		}
	}
},
</xsl:template>

<xsl:template mode="fieldFilters" match="InscripcionesVoluntarios/px:fields/Grupo">"<xsl:call-template name="replace"><xsl:with-param name="inputString"><xsl:value-of select="ancestor-or-self::*[@filters][1]/@filters"/></xsl:with-param><xsl:with-param name="searchText">Id=</xsl:with-param><xsl:with-param name="replaceBy">IdEvento=</xsl:with-param></xsl:call-template>"</xsl:template>

<xsl:template mode="Form.Config" match="Configuracion[@dataType='table']"><xsl:text disable-output-escaping="yes"><![CDATA[
flex:1,
toolBarItems: ['->', {
	iconCls: 'add',
	text: 'Números de Emergencia',
	itemId: 'addButton',
	scope: this,
	handler: function(me, e) { 
		var win = Ext.create('widget.window', {
			title: 'Números de Emergencia'
			, itemId: 'modalWindow'
			, modal: true
			, closable: true
			//, closeAction: 'hide'
			, width: 300
			, height: 200
			, layout: {
				type: 'fit'
				, padding: 5
			}
		});
		
		var content = Panax.getInstance({
			catalogName: 'dbo.NumerosDeEmergencia',
			mode:'readonly'
		}, {
			showDockPanel: false, showPagingToolbar: false, hideHeaders: true
		});
		
		if (content) {
			if (win.items.length>0) { 
				win.remove(0);
			}
	
			win.add(content);
			win.show();
			win.animateTarget=me; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
			//var myMask = new Ext.LoadMask(container, {msg:"Cargando..."});
			//myMask.show();
			//myMask.hide();
		}
	}		
}]
]]></xsl:text></xsl:template>

<xsl:template mode="field.config" match="px:fields/AsignacionEnPrivado|px:fields/GruposSinAsignar|px:fields/AsignacionEnPublico|px:fields/ParticipantesEnGrupo|px:fields/NoParticipantesEnGrupos|px:fields/VoluntariosEnGrupo|px:fields/VoluntariosSinGrupo">title:'<xsl:apply-templates select="." mode="headerText"/>'</xsl:template>

<xsl:template mode="field.config" match="px:fields/VoluntariosSinGrupo/*">
	width:300, height: 310
	, xtype: 'livesearchgridpanel'
	,viewConfig: {
	plugins: {
	ptype: 'gridviewdragdrop',
	enableDrag: true,
	enableDrop: true,
	appendOnly: true
	},

	listeners: {
	/*nodedragover: function(targetNode, position, dragData){
	var rec = dragData.records[0],
	isFirst = targetNode.isFirst(),
	canDropFirst = rec.get('canDropOnFirst'),
	canDropSecond = rec.get('canDropOnSecond');

	return isFirst ? canDropFirst : canDropSecond;
	}*/
	beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
	var grid=this;
	Ext.Array.each(dragData.records, function(rec, index, records) {
	var newRecord=Ext.create(grid.getStore().model.modelName, {})
	newRecord.data["VoluntariosSinGrupo.IdVoluntario"]=rec.get("VoluntariosEnGrupo.IdVoluntario")
	newRecord.data["checked"]=true
	records[index]=newRecord
	rec.store.remove(rec);
	});
	return true;
	}
	}
	}
</xsl:template>


<xsl:template mode="field.config" match="px:fields/VoluntariosEnGrupo/*">
	width:600, height: 310
	,viewConfig: {
	plugins: {
	ptype: 'gridviewdragdrop',
	enableDrag: true,
	enableDrop: true,
	appendOnly: true
	},
	listeners: {
	/*nodedragover: function(targetNode, position, dragData){
	var rec = dragData.records[0],
	isFirst = targetNode.isFirst(),
	canDropFirst = rec.get('canDropOnFirst'),
	canDropSecond = rec.get('canDropOnSecond');

	return isFirst ? canDropFirst : canDropSecond;
	}*/
	beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
	var grid=this;
	Ext.Array.each(dragData.records, function(rec, index, records) {
	var newRecord=Ext.create(grid.getStore().model.modelName, {})
	newRecord.data["VoluntariosEnGrupo.IdVoluntario"]=rec.get("VoluntariosSinGrupo.IdVoluntario")
	newRecord.data["checked"]=true
	records[index]=newRecord
	rec.store.remove(rec);
	});
	return true;
	}
	}
	}
</xsl:template>

<xsl:template mode="field.config" match="px:fields/NoParticipantesEnGrupos/*">
	width:300, height: 310
	, xtype: 'livesearchgridpanel'
	,viewConfig: {
	plugins: {
	ptype: 'gridviewdragdrop',
	enableDrag: true,
	enableDrop: true,
	appendOnly: true
	},
	listeners: {
	/*nodedragover: function(targetNode, position, dragData){
	var rec = dragData.records[0],
	isFirst = targetNode.isFirst(),
	canDropFirst = rec.get('canDropOnFirst'),
	canDropSecond = rec.get('canDropOnSecond');

	return isFirst ? canDropFirst : canDropSecond;
	}*/
	beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
	var grid=this;
	Ext.Array.each(dragData.records, function(rec, index, records) {
	var newRecord=Ext.create(grid.getStore().model.modelName, {})
	newRecord.data["NoParticipantesEnGrupos.IdPcD"]=rec.get("ParticipantesEnGrupo.IdPcD")
	newRecord.data["checked"]=true
	records[index]=newRecord
	rec.store.remove(rec);
	});
	return true;
	}
	}
	}
</xsl:template>


<xsl:template mode="field.config" match="px:fields/ParticipantesEnGrupo/*">
	width:600, height: 310
	,viewConfig: {
	plugins: {
	ptype: 'gridviewdragdrop',
	enableDrag: true,
	enableDrop: true,
	appendOnly: true
	},
	listeners: {
	/*nodedragover: function(targetNode, position, dragData){
	var rec = dragData.records[0],
	isFirst = targetNode.isFirst(),
	canDropFirst = rec.get('canDropOnFirst'),
	canDropSecond = rec.get('canDropOnSecond');

	return isFirst ? canDropFirst : canDropSecond;
	}*/
	beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
	var grid=this;
	Ext.Array.each(dragData.records, function(rec, index, records) {
	var newRecord=Ext.create(grid.getStore().model.modelName, {})
	newRecord.data["ParticipantesEnGrupo.IdPcD"]=rec.get("NoParticipantesEnGrupos.IdPcD")
	newRecord.data["checked"]=true
	records[index]=newRecord
	rec.store.remove(rec);
	});
	return true;
	}
	}
	}
</xsl:template>

	<xsl:template mode="field.config" match="px:fields/SinInscribir/*">
		width:300, height: 310
		, xtype: 'livesearchgridpanel'
		,viewConfig: {
		plugins: {
		ptype: 'gridviewdragdrop',
		enableDrag: true,
		enableDrop: true,
		appendOnly: true
		},
		listeners: {
		/*nodedragover: function(targetNode, position, dragData){
		var rec = dragData.records[0],
		isFirst = targetNode.isFirst(),
		canDropFirst = rec.get('canDropOnFirst'),
		canDropSecond = rec.get('canDropOnSecond');

		return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
		var grid=this;
		Ext.Array.each(dragData.records, function(rec, index, records) {
		var newRecord=Ext.create(grid.getStore().model.modelName, {})
		newRecord.data["SinInscribir.IdPcD"]=rec.get("Inscripciones.IdPcD")
		newRecord.data["checked"]=true
		records[index]=newRecord
		rec.store.remove(rec);
		});
		return true;
		}
		}
		}
	</xsl:template>

	<xsl:template mode="field.config" match="px:fields/Inscripciones/*">
		width:600, height: 310
		,viewConfig: {
		plugins: {
		ptype: 'gridviewdragdrop',
		enableDrag: true,
		enableDrop: true,
		appendOnly: true
		},
		listeners: {
		/*nodedragover: function(targetNode, position, dragData){
		var rec = dragData.records[0],
		isFirst = targetNode.isFirst(),
		canDropFirst = rec.get('canDropOnFirst'),
		canDropSecond = rec.get('canDropOnSecond');

		return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
		var grid=this;
		Ext.Array.each(dragData.records, function(rec, index, records) {
		var newRecord=Ext.create(grid.getStore().model.modelName, {})
		newRecord.data["Inscripciones.IdPcD"]=rec.get("SinInscribir.IdPcD")
		newRecord.data["checked"]=true
		records[index]=newRecord
		rec.store.remove(rec);
		});
		return true;
		}
		}
		}
	</xsl:template>

	<xsl:template mode="field.config" match="px:fields/VoluntariosSinInscribir/*">
		width:300, height: 310
		, xtype: 'livesearchgridpanel'
		,viewConfig: {
		plugins: {
		ptype: 'gridviewdragdrop',
		enableDrag: true,
		enableDrop: true,
		appendOnly: true
		},
		listeners: {
		/*nodedragover: function(targetNode, position, dragData){
		var rec = dragData.records[0],
		isFirst = targetNode.isFirst(),
		canDropFirst = rec.get('canDropOnFirst'),
		canDropSecond = rec.get('canDropOnSecond');

		return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
		var grid=this;
		Ext.Array.each(dragData.records, function(rec, index, records) {
		var newRecord=Ext.create(grid.getStore().model.modelName, {})
		newRecord.data["VoluntariosSinInscribir.IdVoluntario"]=rec.get("InscripcionesVoluntarios.IdVoluntario")
		newRecord.data["checked"]=true
		records[index]=newRecord
		rec.store.remove(rec);
		});
		return true;
		}
		}
		}
	</xsl:template>

	<xsl:template mode="field.config" match="px:fields/InscripcionesVoluntarios/*">
		width:600, height: 310
		,viewConfig: {
		plugins: {
		ptype: 'gridviewdragdrop',
		enableDrag: true,
		enableDrop: true,
		appendOnly: true
		},
		listeners: {
		/*nodedragover: function(targetNode, position, dragData){
		var rec = dragData.records[0],
		isFirst = targetNode.isFirst(),
		canDropFirst = rec.get('canDropOnFirst'),
		canDropSecond = rec.get('canDropOnSecond');

		return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
		var grid=this;
		Ext.Array.each(dragData.records, function(rec, index, records) {
		var newRecord=Ext.create(grid.getStore().model.modelName, {})
		newRecord.data["InscripcionesVoluntarios.IdVoluntario"]=rec.get("VoluntariosSinInscribir.IdVoluntario")
		newRecord.data["checked"]=true
		records[index]=newRecord
		rec.store.remove(rec);
		});
		return true;
		}
		}
		}
	</xsl:template>


	<xsl:template mode="field.config" match="px:fields/GruposSinAsignar/*">
	<xsl:variable name="field"><xsl:choose><xsl:when test="name(../../..)='Sesiones'">Grupo</xsl:when><xsl:otherwise>Sesion</xsl:otherwise></xsl:choose></xsl:variable>
width:300, height: 310
, xtype: 'livesearchgridpanel'
,viewConfig: {
	plugins: {
	   ptype: 'gridviewdragdrop',
	   enableDrag: true,
	   enableDrop: true,
	   appendOnly: true
	},
	listeners: {
		/*nodedragover: function(targetNode, position, dragData){
			var rec = dragData.records[0],
				isFirst = targetNode.isFirst(),
				canDropFirst = rec.get('canDropOnFirst'),
				canDropSecond = rec.get('canDropOnSecond');
				
			return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
			var grid=this;
			Ext.Array.each(dragData.records, function(rec, index, records) {
				var newRecord=Ext.create(grid.getStore().model.modelName, {})
				newRecord.data["GruposSinAsignar.<xsl:value-of select="$field"/>"]=(rec.store.model.modelName.indexOf('EventosPcD.AsignacionEnPrivado')!=-1?rec.get("AsignacionEnPrivado.<xsl:value-of select="$field"/>"):rec.get("AsignacionEnPublico.<xsl:value-of select="$field"/>"))
				newRecord.data["checked"]=true
				records[index]=newRecord
				rec.store.remove(rec);
			});
			return true;
		}
	}
}
</xsl:template>

<xsl:template mode="field.config" match="px:fields/AsignacionEnPublico/*">
	<xsl:variable name="field"><xsl:choose><xsl:when test="name(../../..)='Sesiones'">Grupo</xsl:when><xsl:otherwise>Sesion</xsl:otherwise></xsl:choose></xsl:variable>
width:600, height: 310
,viewConfig: {
	plugins: {
	   ptype: 'gridviewdragdrop',
	   enableDrag: true,
	   enableDrop: true,
	   appendOnly: true
	},
	listeners: {
		/*nodedragover: function(targetNode, position, dragData){
			var rec = dragData.records[0],
				isFirst = targetNode.isFirst(),
				canDropFirst = rec.get('canDropOnFirst'),
				canDropSecond = rec.get('canDropOnSecond');
				
			return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
			var grid=this;
			Ext.Array.each(dragData.records, function(rec, index, records) {
				var newRecord=Ext.create(grid.getStore().model.modelName, {})
				newRecord.data["AsignacionEnPublico.<xsl:value-of select="$field"/>"]=(rec.store.model.modelName.indexOf('EventosPcD.AsignacionEnPrivado')!=-1?rec.get("AsignacionEnPrivado.<xsl:value-of select="$field"/>"):rec.get("GruposSinAsignar.<xsl:value-of select="$field"/>"))
				newRecord.data["checked"]=true
				records[index]=newRecord
				rec.store.remove(rec);
			});
			return true;
		}
	}
}
</xsl:template>

<xsl:template mode="field.config" match="px:fields/AsignacionEnPrivado/*">
	<xsl:variable name="field"><xsl:choose><xsl:when test="name(../../..)='Sesiones'">Grupo</xsl:when><xsl:otherwise>Sesion</xsl:otherwise></xsl:choose></xsl:variable>
width:600, height: 310
,viewConfig: {
	plugins: {
	   ptype: 'gridviewdragdrop',
	   enableDrag: true,
	   enableDrop: true,
	   appendOnly: true
	},
	listeners: {
		/*nodedragover: function(targetNode, position, dragData){
			var rec = dragData.records[0],
				isFirst = targetNode.isFirst(),
				canDropFirst = rec.get('canDropOnFirst'),
				canDropSecond = rec.get('canDropOnSecond');
				
			return isFirst ? canDropFirst : canDropSecond;
		}*/
		beforedrop: function(targetNode, dragData, overModel, position, dropHandler, eOpts) {
			var grid=this;
			Ext.Array.each(dragData.records, function(rec, index, records) {
				var newRecord=Ext.create(grid.getStore().model.modelName, {})
				newRecord.data["AsignacionEnPrivado.<xsl:value-of select="$field"/>"]=(rec.store.model.modelName.indexOf('EventosPcD.AsignacionEnPublico')!=-1?rec.get("AsignacionEnPublico.<xsl:value-of select="$field"/>"):rec.get("GruposSinAsignar.<xsl:value-of select="$field"/>"))
				newRecord.data["checked"]=true
				records[index]=newRecord
				rec.store.remove(rec);
			});
			return true;
		}
	}
}
</xsl:template>

<!-- <xsl:template mode="itemWidth" match="Evento/px:fields/Configuracion/*/px:fields/Sesiones/*">700</xsl:template> -->

<xsl:template mode="control.onchange" match="Configuracion/px:fields/NumeroDeSesiones
| Configuracion/px:fields/NumeroDeGrupos">function(control, newValue, oldValue, eOptions) { 
var grid = Ext.ComponentQuery.query("#<xsl:choose><xsl:when test="local-name(.)='NumeroDeSesiones'">Sesiones</xsl:when><xsl:when test="local-name(.)='NumeroDeGrupos'">GruposActivos</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>");
var newValue=(newValue || 0)
if (Ext.isArray(grid)) grid=grid[0];
<xsl:text disable-output-escaping="yes"><![CDATA[ 
	for (var i=grid.store.data.length; i<(newValue||0); ++i) {
		grid.onAddClick()
	}
	
	var recordNumberToDelete = grid.store.data.length-newValue;
	
	
	//if (newValue<grid.store.data.length) grid.getSelectionModel().selectRange(newValue, grid.store.data.length-1);
	
	var newRecords = grid.store.data.items.filter(function(element, index, array){ 
		if (recordNumberToDelete>0 && !element.data[element.idProperty]) {
			--recordNumberToDelete; 
			return true;
		} else {
			return false;
		}
	});
	
	grid.store.remove(newRecords);
	
	grid.getSelectionModel().deselectAll();
	
	for (var i=grid.store.data.length; i>(grid.store.data.length-recordNumberToDelete||0); --i) {
		var record=grid.store.data.items[i-1];
		if(record.data[record.idProperty]) {
			grid.getSelectionModel().select(record, true);
		} else {
			grid.store.removeAt(i-1);
		}
	}

	var recordsForDeletion = grid.getSelectionModel().getSelection();
	
	if (recordsForDeletion.length>0) {
		Ext.MessageBox.confirm('Confirme', '¿Desea eliminar los elementos seleccionados?', function(result){
			if (result=="yes") {
				grid.store.remove(recordsForDeletion);
			} 
			if (newValue!=grid.store.data.length) control.setValue(grid.store.data.length);
		})
	}
	]]></xsl:text>
	
}
</xsl:template>

<xsl:template match="Sesiones/px:fields/AsignacionEnPublico
" mode="field.config">hidden: true, title:'<xsl:apply-templates select="." mode="headerText"/>'</xsl:template>

<xsl:template match="Sesiones/px:fields/EnLugarPublico
" mode="onChange">function(newValue, oldValue) {
	var control = Ext.ComponentQuery.query("#AsignacionEnPublico")[0]
	if (!control) return;
	if (newValue) { control.show() }
	else { control.hide() }
}

</xsl:template>


</xsl:stylesheet>