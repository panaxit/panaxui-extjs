Ext.define('Panax.view.PanaxGrid', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.panaxgrid',
	/*, plugins: [{
		ptype: 'gridfilters',
		menuFilterText: 'Filtros'
	}]*/
	emptyText: 'No coincidieron registros',
	loadMask: true,
	stateful: true,
	border: true,
	// Set a stateId so that this grid's state is persisted.
	stateId: 'stateful-filter-grid',
	initComponent: function() {
		var me = this;

		console.info("PanaxGrid initiated: " + this.id);

		/*
		Toolbar
		 */
		this.tbar = [{
			text: 'Nuevo Registro',
			glyph: 70,
			handler: 'onAddRecordClick',
			disabled: me.viewConfig.isReadonly
		}, {
			text: 'Borrar Registro',
			glyph: 116,
			handler: 'onRemoveRecordClick',
			disabled: me.viewConfig.isReadonly,
			// bind: {
			// 	disabled: '{!panaxformGrid.selection}'
			// }
		}, {
			xtype: 'tbfill'
		}, {
			text: 'Configurar Vista',
			glyph: 42,
			menu: [{
				text: 'Filtros',
				//glyph: 83,
				menu: [{
					text: 'Remotos',
					checked: true
						// ToDo
				}, {
					text: 'Locales'
						// ToDo
				}, {
					text: 'Borrar',
					handler: 'onClearFiltersClick'
				}],
			}, {
				text: 'Paginacion',
				//glyph: 83,
				menu: [{
					text: 'Mostrar',
					menu: [{
						text: '10 Registros',
						pageSize: 10,
						handler: 'onTogglePagingToolbar'
					}, {
						text: '25 Registros',
						pageSize: 25,
						handler: 'onTogglePagingToolbar'
					}, {
						text: '50 Registros',
						pageSize: 50,
						handler: 'onTogglePagingToolbar'
					}, {
						text: '100 Registros',
						pageSize: 100,
						handler: 'onTogglePagingToolbar'
					}],
				}, {
					text: 'No Mostrar',
					pageSize: 0,
					handler: 'onTogglePagingToolbar'
				}],
			}, {
				text: 'Funciones',
				//glyph: 931,
				menu: [{
					text: 'Ninguna',
					summaryType: null,
					handler: 'onToggleSummary'
				}, {
					text: 'Sumatoria (SUM)',
					summaryType: 'sum',
					handler: 'onToggleSummary'
						// },{
						//     text:'Cuenta (COUNT)',
						//     checked: false
						// },{
						//     text:'Promedio (AVG)',
						//     checked: false
						// },{
						//     text:'Maximo (MAX)',
						//     checked: false
						// },{
						//     text:'Minimo (MIN)',
						//     checked: false
				}],
			}, {
				text: 'Guardar',
				glyph: 86
			}, {
				text: 'Reestablecer',
				glyph: 115
			}]
		}];

		/*
		Paging Toolbar
		 */
		this.dockedItems = {
			xtype: 'pagingtoolbar',
			reference: 'pagingtoolbar',
			bind: {
				store: me.viewConfig.paging.store
			},
			dock: 'bottom',
			hidden: !me.viewConfig.paging.show,
			displayInfo: true,
			displayMsg: 'Registros {0} - {1} de {2}',
			emptyMsg: "No hay registros",
			afterPageText: 'de {0}',
			beforePageText: 'Pagina',
			firstText: 'Primera pagina',
			lastText: 'Ultima pagina',
			nextText: 'Siguiente',
			prevText: 'Anterior',
			refreshText: 'Actualizar',
			items: []
		};

		/*
		Summary Row
		 */
		this.features = {
			ftype: 'summary',
			dock: 'bottom',
			/*
			BUG: showSummaryRow ignored: http://www.sencha.com/forum/showthread.php?261234-showSummaryRow-in-summary-feature&p=1080417#post1080417
			 */
			showSummaryRow: me.viewConfig.summary.show
		};

		/*
		Super
		 */
		this.callParent();
	}
});