Ext.define('Panax.data.CustomIdGenerator', {
	extend: 'Ext.data.SequentialIdGenerator',
	alias: 'idgen.custom',

	id: 'custom', // shared by default

	prefix: 'ID_',
	seed: 1000
});

Ext.data.Types.AUTO= { // Este override se hace porque la función original no incluye el método convert y si se envía metadata al ejecutar el método setFields marcaba error si tenía algún Field sin tipo definido
	convert: function(v) { return v },
	sortType: Ext.data.SortTypes.none,
	type: 'auto'
}

Ext.XML = (new(function() {
    var me = this,
    encodingFunction,
    // decodingFunction,
    // useNative = null,
    // useHasOwn = !! {}.hasOwnProperty,
    // isNative = function() {
        // if (useNative === null) {
            // useNative = Ext.USE_NATIVE_JSON && window.JSON && JSON.toString() == '[object JSON]';
        // }
        // return useNative;
    // },
    pad = function(n) {
        return n < 10 ? "0" + n : n;
    },
    // doDecode = function(json) {
        // return eval("(" + json + ')');
    // },
    doEncode = function(o, newline) {
        
        if (o === null || o === undefined) {
            return "null";
        } else if (o === "") {
            return "null";
        } else if (Ext.isDate(o)) {
            return Ext.XML.encodeDate(o);
        } else if (Ext.isString(o)) {
            return encodeString(o);
        } else if (typeof o == "number") {
            return isFinite(o) ? String(o) : "null";
        } else if (Ext.isBoolean(o)) {
            return o?"1":"null";
        }
        
        
        else if (o.toJSON) {
            return o.toJSON();
        } else if (Ext.isArray(o)) {
			if (o.length>1) {
				return encodeArray(o, newline);
			} else {
				return doEncode(o[0]);
			}
        } else if (Ext.isObject(o)) {
            return encodeObject(o, newline);
        } else if (typeof o === "function") {
            return "null";
        }
        return 'undefined';
    },
    // m = {
        // "\b": '\\b',
        // "\t": '\\t',
        // "\n": '\\n',
        // "\f": '\\f',
        // "\r": '\\r',
        // '"': '\\"',
        // "\\": '\\\\',
        // '\x0b': '\\u000b' 
    // },
    // charToReplace = /[\\\"\x00-\x1f\x7f-\uffff]/g,
    encodeString = function(s) {
		return "'"+s.replace('+', '%2B')+"'";
        // return '"' + s.replace(charToReplace, function(a) {
            // var c = m[a];
            // return typeof c === 'string' ? c : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        // }) + '"';
    },


    encodeArray = function(o, newline) {

        var a = [""], //["<values>"], 
            len = o.length,
            i;
        for (i = 0; i < len; i += 1) {
            a.push("<value>",doEncode(o[i]),"</value>");
        }
        
        // a[a.length - 1] = '</values>';
        return a.join("");
    },

    encodeObject = function(o, newline) {
		return o.isInstance?doEncode(Ext.isObject(o.getValue()) && o.valueField?o.getValue()[o.valueField]:o.getValue()):doEncode(o.value!==undefined?o["value"]:(o.id!==undefined?o["id"]:null));//doEncode(o["value"] || o["id"] || null);
		//return (o.value?"'"+o.value+"'":(o.id?"'"+o.id+"'":'NULL'));
        // var a = ["{", ""], 
            // i;
        // for (i in o) {
            // if (!useHasOwn || o.hasOwnProperty(i)) {
                // a.push(doEncode(i), ":", doEncode(o[i]), ',');
            // }
        // }
        
        // a[a.length - 1] = '}';
        // return a.join("");
    };

    
    me.encodeValue = doEncode;

    
    me.encodeDate = function(o) {
        return "'" + o.getFullYear() + "-"
        + pad(o.getMonth() + 1) + "-"
        + pad(o.getDate()) + "T"
        + pad(o.getHours()) + ":"
        + pad(o.getMinutes()) + ":"
        + pad(o.getSeconds()) + "'";
    };

    
    me.encode = function(o) {
        if (!encodingFunction) {
            
            encodingFunction = /*isNative() ? JSON.stringify : */me.encodeValue;
        }
        return encodingFunction(o);
    };

    
    // me.decode = function(json, safe) {
        // if (!decodingFunction) {
            
            // decodingFunction = isNative() ? JSON.parse : doDecode;
        // }
        // try {
            // return decodingFunction(json);
        // } catch (e) {
            // if (safe === true) {
                // return null;
            // }
            // Ext.Error.raise({
                // sourceClass: "Ext.XML",
                // sourceMethod: "decode",
                // msg: "You're trying to decode an invalid JSON String: " + json
            // });
        // }
    // };
})());

Ext.define('Ext.data.Model', {
    override: 'Ext.data.Model'
	
	, baseModelName: undefined //extra
	
	, constructor: function (config) {
		this.callParent(arguments); 
	}

	, getBaseName: function() {
		return 'base_name'
	}
	, getChangedFields : function(){
        var modified = this.getChanges();
		var changes = {};
		for (field in modified) {
            if (this.fields.get(field)["fieldName"]){
                changes[field] = this.get(field);
            }
        }

        return changes;
    }
});

Ext.define('Panax.data.writer.Writer', {
     override: 'Ext.data.writer.Writer',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	nameProperty: 'fieldName',
	write: function(request) {
		var operation = request.operation,
			records   = operation.records || [],
			len       = records.length,
			i         = 0,
			dataRows  = [];

		for (; i < len; i++) {
			var record = this.getRecordData(records[i], operation)
			if (record) dataRows.push(record);
		}
		var dataTable = { settings: { catalogName: request.params.catalogName, foreignKey:request.params.foreignKey, identityKey: request.params.identityKey, primaryKey: request.params.primaryKey, mode: request.params.mode, filters: request.params.filters }, records:dataRows }
		request.xmlData=this.writeRecords(dataTable)
		return request;
	},
        
	getRecordData: function(record, operation) {
        var me = this, i, association, childStore,
			isPhantom = record.phantom === true,
            writeAll = this.writeAllFields || isPhantom,
            nameProperty = this.nameProperty,
            fields = record.fields,
            fieldItems = fields.items,
            dataRow = { data:{}, associations: {}, action: (record.get("forDeletion") || operation && operation.action=='destroy')?'destroy':(record.getId()?'update':'create') },
            clientIdProperty = record.clientIdProperty,
            changes,
            name,
            field,
            key,
            f, fLen;
        
		if (dataRow.action!='destroy')
			{
			if (writeAll) {
				fLen = fieldItems.length;
				for (f = 0; f < fLen; f++) {
					field = fieldItems[f];

					if (field.persist && (field.submitValue==undefined || field.submitValue==true)) {
						name       = field[nameProperty] || field.name;
						dataRow.data[name] = record.get(field.name);
					}
				}
			} else {
				changes = record.getChanges();
				if (dataRow.action=='update' && changes["checked"]!=undefined && changes["checked"]==false) {
					dataRow.action='destroy'
					}
				else {
					fLen = fieldItems.length;
					for (f = 0; f < fLen; f++) {
						field = fieldItems[f];

						if (field[nameProperty] && field.isAlwaysSubmitable && (field.submitValue==undefined || field.submitValue==true)) {
							name       = field[nameProperty] || field.name;
							dataRow.data[name] = record.get(field.name);
						}
					}
					// Also write the changes
					for (key in changes) {
						if (key && (fields.get(key).submitValue==undefined || fields.get(key).submitValue) && changes.hasOwnProperty(key)) {
							field      = fields.get(key);
							name       = field[nameProperty] || field.name;
							if (field[nameProperty]) {
								dataRow.data[name] = changes[key];
							}
						}
					}
				}
			}
		}
        if(isPhantom) {
            if(clientIdProperty && operation && operation.records.length > 1) {
                // include clientId for phantom records, if multiple records are being written to the server in one operation.
                // The server can then return the clientId with each record so the operation can match the server records with the client records
                dataRow.data[clientIdProperty] = record.internalId;
            }
        } else {
            // always include the id for non phantoms
            if (fields.get(record.idProperty)[nameProperty]) dataRow.data[fields.get(record.idProperty)[nameProperty]] = record.getId();
        }
		dataRow.data.metaData=(dataRow.data.metaData || {});
		if (record.store) {
			if (!record.store.storeId) record.store.storeId='Store-'+Ext.id()
			if (!Ext.getStore(record.store.storeId)) Ext.data.StoreManager.register(record.store)
			dataRow.data.metaData["storeId"] = record.store.storeId;
			dataRow.data.metaData["internalId"] = record.internalId;
		}
		//Ext.getStore(record.store.storeId).getById(record.internalId)
		
//http://www.sencha.com/forum/showthread.php?141957-Saving-objects-that-are-linked-hasMany-relation-with-a-single-Store
        //Iterate over all the hasMany associations
		for (i = 0; i < record.associations.length; i++) {
            association = record.associations.get(i);
			if (association.type=='hasMany' || association.type=='hasOne') {
				childStore = record[(association.type=='hasMany')? (
					association.storeName
				) : (
					association.instanceName
				)];

				var associationStore = { settings: {catalogName:association.tableName/*association.associatedName*/, identityKey: association.identityKey, primaryKey: association.primaryKey, foreignKey:association.foreignKey }, records: [] };

				dataRow.associations[association.name]=associationStore;
				
				if (childStore.getRootNode) {
					childStore.getRootNode().cascadeBy(function(childRecord) {


					//Recursively get the record data for children (depth first)
					var child = me.getRecordData.call(me, childRecord);

					/*
					 * If the child was marked dirty or phantom it must be added. If there was data returned that was neither
					 * dirty or phantom, this means that the depth first recursion has detected that it has a child which is
					 * either dirty or phantom. For this child to be put into the prepared data, it's parents must be in place whether
					 * they were modified or not.
					 */
					if (childRecord.dirty | childRecord.phantom | (child && child.records != null)){
						dataRow.associations[association.name].records.push(child);
						//record.setDirty();
					}
				}, me);
				} else if (childStore.each) {
				//Iterate over all the children in the current association
				childStore.each(function(childRecord) {


					//Recursively get the record data for children (depth first)
					var child = me.getRecordData.call(me, childRecord);

					/*
					 * If the child was marked dirty or phantom it must be added. If there was data returned that was neither
					 * dirty or phantom, this means that the depth first recursion has detected that it has a child which is
					 * either dirty or phantom. For this child to be put into the prepared data, it's parents must be in place whether
					 * they were modified or not.
					 */
					if (childRecord.dirty | childRecord.phantom | (child && child.records != null)){
						dataRow.associations[association.name].records.push(child);
						//record.setDirty();
					}
				}, me);
				} else {
					var child = me.getRecordData.call(me, childStore);
					if (child && (child.records != null || child.data)) {
						dataRow.associations[association.name].records.push(child);
					}
				}

				/*
				 * Iterate over all the removed records and add them to the preparedData. Set a flag on them to show that
				 * they are to be deleted
				 */
				Ext.each(childStore.removed, function(removedChildRecord) {
					//Set a flag here to identify removed records
					removedChildRecord.set('forDeletion', true);
					var removedChildData = me.getRecordData.call(me, removedChildRecord);
					dataRow.associations[association.name].records.push(removedChildData);
					//record.setDirty();
				});
			}
        }

        //Only return data if it was dirty, new or marked for deletion.
        if (record.dirty | record.phantom | dataRow.action=='destroy' | !Panax.util.isEmptyObject(dataRow.associations)) {
            return dataRow;
        }
    }
});	
	
Ext.define('Panax.data.writer.Xml', {
     override: 'Ext.data.writer.Xml',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	
	documentRoot: 'dataTable',
	record: 'dataRow',
	
	createXMLTable: function(dataTable) {
            var me = this,
                xml = [],
                i = 0,
                records = dataTable.records,
                len = records.length,
                root = me.documentRoot,
                item,
                key;
            xml.push('<', root, ' name="', dataTable.settings.catalogName,'" identityKey="',dataTable.settings.identityKey,'" primaryKey="',function(){return (dataTable.settings.primaryKey && dataTable.settings.primaryKey.indexOf(',')==-1?dataTable.settings.primaryKey:'')}(),'"', function(){return (dataTable.settings.foreignKey?' foreignKey="'+dataTable.settings.foreignKey+'"':'')}(),'>');
				xml.push(this.createXMLRows(dataTable));
            xml.push('</', root, '>');
            return xml.join('');
	},
	
	createXMLRows: function(dataTable){
            var me = this,
                xml = [],
                i = 0,
				records = dataTable.records,
                len = records.length,
                root = me.documentRoot,
                record,
                key, association;
                
            // may not exist
            xml.push(me.header || '');
			var deleteXML = [] 
			for (; i < len; ++i) {
                var record = records[i];
    			var dataRow=(record.action=='destroy'?'deleteRow':'dataRow');
				var currentXMLNode=[]
                currentXMLNode.push('<', dataRow, ' identityValue="', function() { return record.action=='create' && dataTable.settings.identityKey?'NULL':Ext.XML.encodeValue(record.data[dataTable.settings.identityKey])}() ,'" primaryValue="', function() { return record.action=='create' && (!dataTable.settings.primaryKey || !dataTable.settings.identityKey )?'NULL':Ext.XML.encodeValue(record.data[dataTable.settings.primaryKey])}()
				,'"'
				,function(){
					var attributesString='';
					for (var attribute in record.data["metaData"]) {
						attributesString+=' '+attribute+'="'+record.data["metaData"][attribute]+'"';
					}
					return attributesString;
				}()
				,'>');
				
				delete record.data["metaData"];
    			if (record.action!='destroy') {
    				for (key in record.data) {
						if (key && key!=dataTable.settings.identityKey && record.data.hasOwnProperty(key)) {
    						currentXMLNode.push('<dataField name="', key, '">', Ext.XML.encodeValue(record.data[key]), '</dataField>');
    					}
    				}
    			}
				for (association in record.associations) {
				    currentXMLNode.push(this.createXMLTable(record.associations[association]));
				}
                currentXMLNode.push('</', dataRow, '>');
				if (dataRow!='deleteRow') {
					xml.push(currentXMLNode.join(''))
				} else {
					deleteXML.push(currentXMLNode.join(''))
				}
			}
		/*siempre se generan los nodos de borrado primero y después los de actualización*/
        return deleteXML.join('')+xml.join('');
	},
	
	writeRecords: function(dataTable) {
		// alert("method overriden")
        var xml = [];        
        xml.push(this.createXMLTable(dataTable));
        return xml.join('');
	}
 });
 
/*Ext.define('Ext.form.field.Base', {
     override: 'Ext.form.field.Base',

	constructor: function (config) {
		this.callParent(arguments); 
	},

	setValue: function(value) {
        var me = this;
		value = Ext.isObject(value)?(value[this.valueField] || value.text || value.value):value;//value;
        me.setRawValue(me.valueToRaw(value));
        return me.mixins.field.setValue.call(me, value);
    }
});*/

/*Ext.define('Panax.form.Field', {
     override: 'Ext.form.field.Field',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	metadata: null,
	setValue: function(value) {
		var me = this;
		me.value = Ext.isObject(value)?(value[this.valueField] || value.text || value.value):value;//value;
		me.checkChange();
		return me;
	}
});*/

Ext.define('Ext.form.field.Trigger', {
    override:'Ext.form.field.Trigger',

	constructor: function (config) {
		this.callParent(arguments); 
	},
    setReadOnly: function(readOnly) {
		var me = this
        if (readOnly != this.readOnly) {
			me[readOnly ? 'addCls' : 'removeCls'](me.readOnlyCls);
            this.readOnly = readOnly;
            this.updateLayout();
        }
		//this.callParent(arguments);
    }
});

Ext.define('Ext.data.reader.Reader', {
	override: 'Ext.data.reader.Reader'
	, constructor: function(config) { 
        var me = this; 
		Ext.apply(me, config)
		this.callParent(arguments); 
	}
});
// Ext.define('Ext.data.reader.Json', {
    // override: 'Ext.data.reader.Json',
	
	// constructor: function (config) {
		// this.callParent(arguments); 
	// },

	// createAccessor: (function() {
        // var re = /([^\[\.]+)([\[\.].+)?/;

        // return function(expr) {
            // if (Ext.isEmpty(expr)) {
                // return Ext.emptyFn;
            // }
            // if (Ext.isFunction(expr)) {
                // return expr;
            // }
            // if (this.useSimpleAccessors !== true) {
                // var i = String(expr).search(re);
                // if (i >= 0) {
					// var fieldName = String(expr).replace(re, '$1');
                    // return Ext.functionFactory('obj', 'return ((obj.'+fieldName+'||{})'+String(expr).replace(re, '$2')+' || obj.'+fieldName+')');
                // }
            // }
            // return function(obj) {
                // return obj[expr];
            // };
        // };
    // }())
// });


Ext.define('Ext.data.Store', {
    override: 'Ext.data.Store',
	
	constructor: function (config) {
		this.callParent(arguments); 
	},

	loadRawData : function(data, append) {
         var me      = this,
             result  = me.proxy.reader.read(data),
             records = result.records;

         if (result.success) {
             me.totalCount = result.total;
             me.loadRecords(records, append ? me.addRecordsOptions : undefined);
             me.fireEvent('load', me, records, true);
         }
     },

	 loadRecords: function(records, options) {
		var me     = this,
            i      = 0,
            length = records.length,
            start,
            addRecords,
            snapshot = me.snapshot;
		
        if (options) {
            start = options.start;
            addRecords = options.addRecords;
        }

        if (!addRecords) {
            delete me.snapshot;
            me.clearData(true);
        } else if (snapshot) {
            snapshot.addAll(records);
        }

        me.data.addAll(records);

        if (start !== undefined) {
            for (; i < length; i++) {
                records[i].index = start + i;
                records[i].join(me);
            }
        } else {
            for (; i < length; i++) {
                records[i].join(me);
            }
        }

        /*
         * this rather inelegant suspension and resumption of events is required because both the filter and sort functions
         * fire an additional datachanged event, which is not wanted. Ideally we would do this a different way. The first
         * datachanged event is fired by the call to this.add, above.
         */
        me.suspendEvents();

        if (me.filterOnLoad && !me.remoteFilter) {
            me.filter();
        }

        if (me.sortOnLoad && !me.remoteSort) {
            me.sort(undefined, undefined, undefined, true);
        }
        me.resumeEvents();
        me.fireEvent('datachanged', me);
        me.fireEvent('refresh', me);
    }
});
	
	
/*http://stackoverflow.com/questions/9891537/extjs-and-nested-models/9891694#9891694*/
Ext.define('Panax.form.Basic', {
     override: 'Ext.form.Basic',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	
	setValues: function(record) {
        var me = this,
            v, vLen, val, field;

		function setAttributes(fieldId, rawData) {
            var field = me.findField(fieldId);
            if (field) {
				if (rawData==null) rawData={}
				//field.raw=rawData //esta información se debe guardar en el store
				field.metaData=rawData.metaData
				//Ext.apply(field, metadata);
				//field.setContainerVisible(metadata["hidden"]!=undefined?!metadata["hidden"]:true);
				if (field.store && rawData.data) {
					field.store.raw=rawData;
					field.store.loadData(rawData.data);
				}
				if (rawData["readOnly"]!==undefined && field.setReadOnly) {	
					field.setReadOnly(rawData["readOnly"] || false);
				}
            }
        }

		var raw = record.raw;
        if (Ext.isArray(raw)) {
            // array of objects
            vLen = raw.length;

            for (v = 0; v < vLen; v++) {
                val = raw[v];
				setAttributes(val.id, val);
            }
        } else {
            // object hash
            Ext.iterate(raw, setAttributes);
        }

		function setVal(fieldId, val) {
            var field = me.findField(fieldId);
            if (field) {
                field.setValue(val);
                if (me.trackResetOnLoad) {
                    field.resetOriginalValue();
                }
            }
        }

        var values = (record.data || values);
		if (Ext.isArray(values)) {
            // array of objects
            vLen = values.length;

            for (v = 0; v < vLen; v++) {
                val = values[v];

                setVal(val.id, val.value);
            }
        } else {
            // object hash
            Ext.iterate(values, setVal);
        }
        return this;
    },
	
	loadRecord: function(record, associationId) {
		var me = this;
        if (!associationId) this._record = record; //prevents updating _record if it's been recursed
		if (!record) return false;
		for (var i = 0; i < record.associations.length; i++) {
			association = record.associations.get(i);
			if (association.type=='hasMany' || association.type=='hasOne') {
				//if (association.associationKey=='PrototiposDeInteres')
					//record[association.storeName].store=store_junction
				var control = Ext.ComponentQuery.query("#"+association.associationKey)
				var associationName = (association.type=='hasMany')?(association.storeName) : (association.instanceName)
				if (Ext.isArray(control)) control=control[0]
				if (control) {
					if (!control.getStore) {
						var TempStore = record[associationName];
						var recCurrentRecord=TempStore.getAt?TempStore.getAt(0):TempStore;
						if (!recCurrentRecord) {
							recCurrentRecord=Ext.create(TempStore.modelName, {})
							recCurrentRecord=Ext.apply(TempStore,recCurrentRecord)
							record[associationName]=recCurrentRecord
							//TempStore.insert(0, recCurrentRecord); 
						}
						//control.getForm().store = TempStore
						//control.getForm().store.data = {}
						//recCurrentRecord.idProperty = association.identityKey;
						control.loadRecord(recCurrentRecord)
						record[associationName]=control.getRecord() //reemplazamos el store asociado por el nuevo
						// var r = Ext.create(control.store.model.modelName, {
							// "NumeroDeSesiones": {value:'2'},
							// "NumeroDeGrupos": {value:'1'}
						// });
						// 
						// 
						// control.getForm().loadRecord(r)
					}
					else {
						var controlStore = control.getStore()
						if (controlStore.tree) {
							var childData = (association.type=='hasMany')? (
									record.raw[association.associationKey]
								) : (
									record[association.instanceName].raw
								);
							
							// // childStore = Ext.create('Ext.data.TreeStore', {
								// // folderSort: true
								// // ,defaultRootProperty: 'data'
								// // ,root: childData
							// // });
							if (childData) control.setRootNode(childData);
							control.getRootNode().cascadeBy(function(node){
								if (node.dirty) node.dirty=false; //por default son marcados como dirty=true así que hay que cambiarlos a false
							})
							record[associationName]=control.getStore() //reemplazamos el store asociado por el nuevo
						} else if (association.type=='hasMany') {
							childStore = record[association.storeName];
							if (childStore) {
								childStore.idProperty = association.identityKey;
								// childStore.on('load', control.onDataLoad, control);
								childStore.getProxy().setReader(association.getReader())
								control.reconfigure(childStore);
								control.doLayout();
								//childStore.fireEvent('load')
							}
						}
					}
				}
			}
		}
		/*for (i = 0; i < record.associations.length; i++) {
            var association = record.associations.get(i);
			if (association.type=='hasMany' || association.type=='hasOne') {
				childStore = record[association.storeName];
				if (childStore) this.loadRecord(childStore.data.get(0), association.name);
			}
		}*/
        return this.setValues(record, associationId);
    },
	
	updateRecord: function(record, associationId) {
        record = record || this._record;
        //<debug>
        if (!record) {
            Ext.Error.raise("A record is required.");
        }
        //</debug>

		if (record.associations) {
			for (i = 0; i < record.associations.length; i++) {
				var association = record.associations.get(i);
				if (association.type=='hasMany' || association.type=='hasOne') {
					var childStore = record[(association.type=='hasMany')? (
						association.storeName
					) : (
						association.instanceName
					)];
					if (childStore) {
						if (childStore.tree) {
							this.updateRecord(childStore.getRootNode(), association.name);
						}
						else if (childStore.data.get) {
							if (childStore.data.get(0)) {this.updateRecord(childStore.data.get(0), association.name)};
						}
						else if (childStore.data) {
							this.updateRecord(childStore, association.name)
						}
					}
				}
			}
		}

        var fields = record.fields.items,
            values = this.getFieldValues(),
            obj = {},
            i = 0,
            len = fields.length,
            name;

        for (; i < len; ++i) {
            name  = fields[i].name;

            if (values.hasOwnProperty(name)) {
                obj[name] = values[name];
            }
        }

        record.beginEdit();
        record.set(obj);
        record.endEdit();

        return this;
    }
});

Ext.define('Panax.form.RadioGroup', {
    override: 'Ext.form.RadioGroup',

	constructor: function (config) {
		this.callParent(arguments); 
	}
	
	, setReadOnly: function(readOnly) {
        var boxes = this.getBoxes(),
            b,
            bLen  = boxes.length;

        for (b = 0; b < bLen; b++) {
            boxes[b].setReadOnly(readOnly);
        }

        this.readOnly = readOnly;
    }
	
	, setValue: function(value) {
        var cbValue, first, formId, radios,
            i, len, name;
		
		if (!Ext.isObject(value) && this.name) {
			eval("value = {"+this.name+":"+Ext.XML.encodeValue(value)+"}");
		}
        if (Ext.isObject(value)) {
			this.reset()
            for (name in value) {
                if (value.hasOwnProperty(name)) {
                    cbValue = value[name];
                    first = this.items.first();
                    formId = first ? first.getFormId() : null;
                    radios = Ext.form.RadioManager.getWithValue(name, cbValue, formId).items;
                    len = radios.length;

                    for (i = 0; i < len; ++i) {
                        radios[i].setValue(true);
                    }
                }
            }
        }
        return this;
    }
});

Ext.define('Panax.form.field.Base', {
    override: 'Ext.form.field.Base',
	required: false,
	requiredDisabled: false,
	constructor: function (config) {
		config=Panax.util.updateWidth(this, config);
		this.callParent([config]);
		//this.markRequired();
		//if (width!=newWidth) this.setWidth(newWidth)
	},
	showContainer: function() { 
        this.enable(); 
        this.show(); 
        this.getEl().up('.x-form-item').setDisplayed(true); // show entire container and children (including label if applicable)
     }, 
     
    hideContainer: function() { 
        this.disable(); // for validation 
        this.hide(); 
        this.getEl().up('.x-form-item').setDisplayed(false); // hide container and children (including label if applicable)
    }
	 
	, setContainerVisible: function(visible) { 
        if (visible) { 
            this.showContainer(); 
        } else { 
            this.hideContainer(); 
        } 
        return this; 
    } 
	
	, markRequired: function() {
		var required=(this.required && !this.requiredDisabled);
		this.allowBlank=!required
		if (required) {
			this.addCls('required')
			this.removeCls('notRequired')
		} else {
			this.addCls('notRequired')
			this.removeCls('required')
		}
	}
	
	, setRequired: function(required) {
		this.required=required;
		this.markRequired();
	}
	
	, disableRequired: function(disabled) {
		this.requiredDisabled=disabled;
		this.markRequired();
	}

});

Ext.define('Ext.form.field.Number', {
    override: 'Ext.form.field.Number',
	
	constructor: function (config) {
		config=Panax.util.updateWidth(this, config);
		this.callParent([config]);
		//if (width!=newWidth) this.setWidth(newWidth)
	}
});

	
Ext.define('Panax.form.field.ComboBox', {
    override: 'Ext.form.field.ComboBox',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	anyMatch: true,
	caseSensitive: false,

	findRecordByValue: function(value) {
		return this.findRecord(this.valueField, Ext.isObject(value)?value[this.valueField]:value);
	},

	findRecordByDisplay: function(value) {
		return this.findRecord(this.displayField, Ext.isObject(value)?value[this.displayField]:value);
	},
	
	setValue: function(value, doSelect) {
        var me = this,
            valueNotFoundText = me.valueNotFoundText,
            inputEl = me.inputEl,
            i, len, record,
            dataObj,
            matchedRecords = [],
            displayTplData = [],
            processedValue = [];

        if (me.store.loading) {
            // Called while the Store is loading. Ensure it is processed by the onLoad method.
            me.value = value;
            me.setHiddenValue(me.value);
            return me;
        }

        // This method processes multi-values, so ensure value is an array.
        value = Ext.Array.from(value);

        // Loop through values, matching each from the Store, and collecting matched records
        for (i = 0, len = value.length; i < len; i++) {
            record = value[i];
			var parentTable = this.settings?Ext.getCmp(this.settings.foreignElement):undefined;
			if (parentTable && record.data) {
				record.data["fk"]=parentTable.value
				if (record.raw) record.raw["fk"]=parentTable.value
				}

            if (!record || !record.isModel) {
                record = me.findRecordByValue(record);
            }
            // record found, select it.
            if (record) {
                matchedRecords.push(record);
                displayTplData.push(record.data);
                processedValue.push(record.data/*.get(me.valueField)*/);
            }
            // record was not found, this could happen because
            // store is not loaded or they set a value not in the store
            else {
                // If we are allowing insertion of values not represented in the Store, then push the value and
                // create a fake record data object to push as a display value for use by the displayTpl
                if (!me.forceSelection) {
					processedValue.push(/*Ext.isObject(value[i])?value[i][this.valueField]:*/value[i]);
                    dataObj = {};
                    dataObj[me.displayField] = Ext.isObject(value[i])?value[i][this.displayField]:value[i];
                    displayTplData.push(dataObj);
                    // TODO: Add config to create new records on selection of a value that has no match in the Store
                }
                // Else, if valueNotFoundText is defined, display it, otherwise display nothing for this value
                else if (Ext.isDefined(valueNotFoundText)) {
                    displayTplData.push(valueNotFoundText);
                }
            }
        }

        // Set the value of this field. If we are multiselecting, then that is an array.
        me.setHiddenValue(processedValue);
        me.value = me.multiSelect ? processedValue : processedValue[0];
        if (!Ext.isDefined(me.value)) {
            me.value = null;
        }
        me.displayTplData = displayTplData; //store for getDisplayValue method
        me.lastSelection = me.valueModels = matchedRecords;

        if (inputEl && me.emptyText && !Ext.isEmpty(value)) {
            inputEl.removeCls(me.emptyCls);
        }

        // Calculate raw value from the collection of Model data
        me.setRawValue(me.getDisplayValue());
        me.checkChange();

        if (doSelect !== false) {
            me.syncSelection();
        }
        me.applyEmptyText();

        return me;
    },

	doQuery: function(queryString, forceAll, rawQuery) {
        queryString = queryString || '';

        // store in object and pass by reference in 'beforequery'
        // so that client code can modify values.
        var me = this,
            qe = {
                query: queryString,
                forceAll: forceAll,
                combo: me,
                cancel: false
            },
            store = me.store,
            isLocalMode = me.queryMode === 'local',
            needsRefresh;

        if (me.fireEvent('beforequery', qe) === false || qe.cancel) {
            return false;
        }

        // get back out possibly modified values
        queryString = qe.query;
        forceAll = qe.forceAll;

        // query permitted to run
        if (forceAll || (queryString.length >= me.minChars)) {
            // expand before starting query so LoadMask can position itself correctly
            me.expand();

            // make sure they aren't querying the same thing
            if (!me.queryCaching || me.lastQuery !== queryString) {
                me.lastQuery = queryString;

                if (isLocalMode) {
                    // forceAll means no filtering - show whole dataset.
                    store.suspendEvents();
                    needsRefresh = me.store.clearFilter();
                    if (queryString || !forceAll) {
                        me.activeFilter = new Ext.util.Filter({
                            root: 'data',
                            property: me.displayField,
                            value: queryString,
							anyMatch: me.anyMatch,
							caseSensitive: me.caseSensitive
                        });
                        store.filter(me.activeFilter);
                        needsRefresh = true;
                    } else {
                        delete me.activeFilter;
                    }
                    store.resumeEvents();
                    if (me.rendered && needsRefresh) {
                        me.getPicker().refresh();
                    }
                } else {
                    // Set flag for onLoad handling to know how the Store was loaded
                    me.rawQuery = rawQuery;

                    // In queryMode: 'remote', we assume Store filters are added by the developer as remote filters,
                    // and these are automatically passed as params with every load call, so we do *not* call clearFilter.
                    if (me.pageSize) {
                        // if we're paging, we've changed the query so start at page 1.
                        me.loadPage(1);
                    } else {
                        store.load({
                            params: me.getParams(queryString)
                        });
                    }
                }
            }

            // Clear current selection if it does not match the current value in the field
            if (me.getRawValue() !== me.getDisplayValue()) {
                me.ignoreSelection++;
                me.picker.getSelectionModel().deselectAll();
                me.ignoreSelection--;
            }

            if (isLocalMode) {
                me.doAutoSelect();
            }
            if (me.typeAhead) {
                me.doTypeAhead();
            }
        }
        return true;
    }
});

Ext.define('Panax.ux.grid.filter.DateFilter', {
    override: 'Ext.ux.grid.filter.DateFilter',
	
	constructor: function (config) {
		this.callParent(arguments);
	}
	
	, getSerialArgs : function () {
        var args = [];
        for (var key in this.fields) {
            if(this.fields[key].checked){
                args.push({
                    type: 'date',
                    comparison: this.compareMap[key],
                    value: Ext.Date.format(this.getFieldValue(key), this.dateFormat)
                });
            }
        }
        return args;
    }
});