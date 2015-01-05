Ext.define('Panax.data.Proxy', {
	extend: 'Ext.data.proxy.Ajax',
	alias: 'proxy.panax_proxy'

    , timeout: 360000
    , api: {
          create: "Scripts/update.asp"
        , read: "request.asp"
        , update: "Scripts/update.asp"
        , destroy: "Scripts/update.asp"
    }
	, settings: {
		catalogName: undefined
		, lang: undefined
		//, filters: undefined
		, identityKey: undefined
		, primaryKey: undefined
		, mode: undefined
		//, view: undefined
		//, identity: undefined
	}
	, constructor: function(configuration) {
        var me = this; 
		me.callParent(arguments);
		Ext.apply(me, {
			extraParams: {
				catalogName: me.config.settings.catalogName
				, lang: me.config.settings.lang
				//, filters: me.config.settings.filters
				, identityKey: me.config.settings.identityKey
				, primaryKey: me.config.settings.primaryKey
				, mode: me.config.settings.mode
				, output: 'json'
			}
		});
	}
    ,writer: {
        type:'xml',
        successProperty: 'success',
        writeAllFields: false,
        rootProperty:'data'
        // , partialDataOptions: { // Se evita esta configuración porque recupera toda la información asociada y no solamente los cambios
            // associated: true
        // },
    }
    ,reader: {
    	type: 'json',
        rootProperty:'data',
        successProperty: 'success'
    }
    , pageParam: 'pageIndex'
    , limitParam: 'pageSize'
    , filterParam: 'filters'
    , sortParam: 'sorters'
    , encodeFilters: function(filters) {
	    filterOperator = function(filter) {
	    	var op = filter.getOperator(),
	    		val = Ext.XML.encodeValue(filter.getValue());

			switch(op) {
				case 'gt': 		return '> ' + val;
				case 'gte': 	return '>= ' + val;
				case 'lt': 		return '< ' + val;
				case 'lte': 	return '<= ' + val;
				case 'like': 	return "LIKE '%'+REPLACE("+val+",'','%')+'%'"
				case 'eq': 		return '= ' + val;
				default: 		return '= ' + val;
			}
	    };

        var a = [""], //["<values>"], 
            len = filters.length,
            i;

        //a.push('<filterGroup operator="AND">');
        for (i = 0; i < len; i += 1) {
            a.push(filters[i].getProperty());
            a.push(filterOperator(filters[i]));
        }
        //a.push('</filterGroup>');

    	return a.join(" ").trim();
    }
    , success: function(xhr) {
    	alert("success");
        var response=Ext.JSON.decode(xhr.responseText); 
        parameters["success"] = (response.success/* && confirm("Se reconstruyó el módulo, continuar?")*/);
            if (response.callback) {
                response.callback();
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
        parameters = Ext.apply(parameters, response.catalog)
    }
    , failure: function() {
        Ext.Msg.alert("Error de comunicación", "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
        parameters["success"] = false;
    }
    , exception: function( me, request, operation, eOpts ){
        Ext.Msg.alert("Error en el script", "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
    }
});