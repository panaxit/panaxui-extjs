Ext.define('Panax.data.CatalogProxy', {
	extend: 'Ext.data.proxy.Ajax',
	alias: 'proxy.panax_catalogproxy',

	url: '../server/scripts/xmlCatalogOptions.asp',
	reader: {
		type: 'json',
		rootProperty: 'data',
		successProperty: 'success',
		messageProperty: 'message',
		totalProperty: 'total'
	},
	pageParam: 'pageIndex',
	limitParam: 'pageSize',
	filterParam: 'filters',
	sortParam: 'sorters',
	extraParams: { 
		output: 'json' 
	},
	listeners: {
		exception: function(proxy, response, operation){
			//alert(response.responseText)
			var message = operation.getError();
			message = Ext.isObject(message)?message["error"]:message;
			Ext.MessageBox.show({
				title: 'ERROR!',
				msg: message,
				icon: Ext.MessageBox.ERROR,
				buttons: Ext.Msg.OK
			});
		}
	}
});