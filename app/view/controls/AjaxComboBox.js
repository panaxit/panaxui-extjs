Ext.define("Panax.view.controls.AjaxComboBox", {
	extend: 'Ext.form.field.ComboBox',
	//model: 'Panax.model.ajaxdropdown',
	alias: 'widget.ajaxcombobox',
	valueNotFoundText: "valueNotFound",
	displayField: 'text',
	valueField: 'id',
	publishes: 'value',
	queryMode: 'remote',
	queryParam: false,
	//, queryMode: 'local'
	queryCaching: false, //Temporalmente siempre hacer la llamada Ajax al catalogo
	//, triggerAction: 'all'
	editable: false,
	//, typeAhead: true
	//, editable: true
	//, forceSelection: true 

	// //OVERRIDE to support {Object} Values
	// setValue: function(value) {
	// 	debugger;
	// 	return this.doSetValue(value);
	// },
	// getValue: function(value) {
	// 	debugger;
	// 	return me.value;
	// }
	// OVERRIDE to support remote String filters
	setFilters: function(filters) {
		if (Ext.isString(filters)) {
			this.getStore().getProxy().extraParams.filters = filters;
		} else {
			this.callParent(arguments);
		}
	}
});