Ext.define('Panax.store.Navigation', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.navigation',

    constructor: function(config) {
        var me = this,
            queryParams = Ext.Object.fromQueryString(location.search);

        me.callParent([Ext.apply({
            root: {
                text: 'Panax UI v12.9',
                id: 'home',
                expanded: true,
                expandable: false,
                children: me.getNavItems()
            }
        }, config)]);
	}
	
    , config: {
        refs: {
            viewport: 'viewport',
            navigationTree: 'navigation-tree',
            navigationBreadcrumb: 'navigation-breadcrumb',
            contentPanel: 'contentPanel',
            descriptionPanel: 'descriptionPanel',
            thumbnails: {
                selector: 'thumbnails',
                xtype: 'thumbnails',
                autoCreate: true
            }
        }
	}

	, getNavItems: function() {		
		var me=this
			, store=[];
			
		Ext.Ajax.request({
			url: '../server/templates/menu.asp'
			, method: 'GET'
			, async: false
			, params: { output: 'json' }
			, success: function(xhr) {
				var response=Ext.JSON.decode(xhr.responseText); 
				// parameters["success"] = (response.success/* && confirm("Se reconstruyó el módulo, continuar?")*/);
				 if (response.callback) {
						var config = {};
						config.onSuccess = function() {
							//me.removeAll()
							me.getRootNode().removeAll()
							me.getRootNode().appendChild(me.getNavItems());
							// location.href=location.href;
						}
						response.callback(config);
					}
					else {
						if (response.message) {
							Ext.MessageBox.show({
								title: 'MENSAJE DEL SISTEMA',
								msg: response.message,
								icon: Ext.MessageBox.ERROR,
								buttons: Ext.Msg.OK
							});
						}
					}
				if (response.success) store=response.data;
			}
			, failure: function() {
				Ext.Msg.alert("Error de comunicación", "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
				//parameters["success"] = false;
			}
		});
        return store;
    }
});
