/**
 * Set Panax Cache folder
 */
Ext.Loader.setPath({
	'Cache': '../server/Cache'
});

/**
 * Class: Panax Component
 */
Ext.define('Panax.core.PanaxComponent', {

	panaxCmp: undefined,

	/**
	 * Constructor
	 * @param  {[type]} model         [description]
	 * @param  {[type]} configuration [description]
	 * @return {[type]}               [description]
	 */
	constructor: function(model, configuration) {
		var className, ViewClass;

		className = (model.prefix + "." + model.dbId + "." + model.lang + "." + model.catalogName + "." + model.mode + "." + model.controlType || Ext.ClassManager.getNameByAlias(model.alias));

		ViewClass = (Ext.ClassManager.get(className));
		if (!ViewClass) {
			if (className) {
				this.panaxCmp = this.getInstance({
					catalogName: model.catalogName,
					controlType: model.controlType,
					mode: model.mode,
					//ToDo: Development only
					rebuild: 1
				}, configuration);
			} else {
				Ext.log.warn('Class with alias "' + model.alias + (className ? '" or name "' + className : "") + '" not found.');
			}
		} else {
			this.panaxCmp = Ext.create(className, configuration);
		}
	},

	/**
	 * Get Panax Component instance
	 * @return {[type]} [description]
	 */
	getCmp: function() {
		return this.panaxCmp;
	},

	/**
	 * Get Instance
	 * @param  {[type]} model         [description]
	 * @param  {[type]} configuration [description]
	 * @param  {[type]} xmlData       [description]
	 * @return {[type]}               [description]
	 */
	getInstance: function(model, configuration, xmlData) {
		var classObject;

		configuration = (configuration || {});
		if (model.rebuild == 1) {
			model.output = 'json';
			model = this.requestInstance(model, xmlData);
		} else {
			model = this.requestInstance(function() {
				var params = model;
				params.getData = 0;
				params.getStructure = 1;
				params.output = 'json';
				return params;
			}(), xmlData);
		}
		if (!model.success) {
			return false;
		}
		try {
			classObject = Ext.create('Cache.app.' + model.dbId + '.' + model.lang + '.' + model.catalogName + '.' + model.mode + '.' + model.controlType, configuration);
		} catch (e) {
			if ((e.type == "called_non_callable" || e.type === undefined) && (model.rebuild === undefined ? 0 : model.rebuild) != 1) {
				//ToDo: debugMode=1
				model.rebuild = 1;
				classObject = this.getInstance(model, configuration, xmlData);
			} else {
				Ext.MessageBox.show({
					title: 'Error',
					msg: "Este módulo no está disponible en este momento",
					icon: Ext.MessageBox.ERROR,
					buttons: Ext.Msg.OK
				});
				Ext.log.error(e.stack);
			}
		}
		return classObject;
	},

	/**
	 * Request Instance
	 * @param  {[type]} parameters [description]
	 * @param  {[type]} xmlData    [description]
	 * @return {[type]}            [description]
	 */
	requestInstance: function(parameters, xmlData) {
		Ext.Ajax.request({
			url: '../server/request.asp',
			timeout: 360000,
			method: xmlData ? 'POST' : 'GET',
			async: false,
			xmlData: xmlData,
			params: parameters,
			success: function(xhr) {
				var response = Ext.JSON.decode(xhr.responseText);
				parameters.success = (response.success /* && confirm("Se reconstruyó el módulo, continuar?")*/ );
				if (response.callback) {
					response.callback();
				} else {
					if (response.message) {
						Ext.MessageBox.show({
							title: 'MENSAJE DEL SISTEMA',
							msg: response.message,
							icon: Ext.MessageBox.ERROR,
							buttons: Ext.Msg.OK
						});
					}
				}
				parameters = Ext.apply(parameters, response.catalog);
			},
			failure: function() {
				Ext.Msg.alert("Error de comunicación", "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
				parameters.success = false;
			}
		});
		return parameters;
	}

});