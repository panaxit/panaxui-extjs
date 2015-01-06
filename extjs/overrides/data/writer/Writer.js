Ext.define('Panax.data.writer.Writer', {
	override: 'Ext.data.writer.Writer',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	nameProperty: 'fieldName',
	write: function(request) {
        var operation = request.getOperation(),
            records = operation.getRecords() || [],
            len = records.length,
			i         = 0,
			dataRows  = [];

		var dataTable = { params: request.getParams() }
		for (; i < len; i++) {
			var currentRecord = records[i];
			var record = {};
			record.action=operation.action;
			record.data=this.getFixedRecordData(currentRecord, operation)
			record.previousValues=(currentRecord.previousValues || {});
			record.primaryValues={}
			var fields = currentRecord.getFieldsMap();
			for (field in fields) {
				if (fields[field].unique) {
					record.primaryValues[field] = record.data[field];
				}
			}
			//record.associations=currentRecord.associations;
			if (record) dataRows.push(record);
		}
		dataTable["identityKey"]=request.getProxy().getModel().idProperty;
		dataTable["records"]=dataRows;
		//{ settings: { catalogName: request.params.catalogName, foreignKey:request.params.foreignKey, identityKey: request.identityKey, primaryKey: request.params.primaryKey, mode: request.params.mode, filters: request.params.filters }, records:dataRows }
		request.setXmlData(this.writeRecords(dataTable));
		return request;
	}
        
	, getFixedRecordData: function(record, operation) {
		var field, newRecord = this.getRecordData(record, operation);

		for(var i=0; i<record.fields.items.length; i++) {
			field = record.fields.items[i];
    		if(!(field.submitValue==undefined || field.submitValue==true)) {
    			delete newRecord[field.name];
    		}
		}

		return newRecord;
	}
 //        var me = this, name,
 //        // i, association, childStore,
	// 		// isPhantom = record.phantom === true,
 //   //          writeAll = this.writeAllFields || isPhantom,
 //            nameProperty = this.nameProperty,
 //            // fields = record.fields,
 //            // fieldItems = fields.items,
 //            dataRow = {};
 //            // clientIdProperty = record.clientIdProperty,
 //            // changes,
 //            // name,
 //            // field,
 //            // key,
 //            // f, fLen;
 //  //      	debugger;
	// 	// if (operation.action!='destroy') {
	//     	Ext.Array.each(record.fields.items, function(field){
	//     		if(!(field.submitValue==undefined || field.submitValue==true)) {
	//     			field.persist = false;
	//     		}
	//     	});
	// 	// }
	// 	debugger;
	// 	this.callSuper(record, operation);

 //        //Only return data if it was dirty, new or marked for deletion.
 //        // if (record.dirty | record.phantom | operation.action=='destroy') {
 //        //     return dataRow;
 //        // }
	// }

	// 	if (dataRow.action!='destroy') {
	// 		if (writeAll) {
	// 			fLen = fieldItems.length;
	// 			for (f = 0; f < fLen; f++) {
	// 				field = fieldItems[f];

	// 				if (field.persist && (field.submitValue==undefined || field.submitValue==true)) {
	// 					name       = field[nameProperty] || field.name;
	// 					dataRow.data[name] = record.get(field.name);
	// 				}
	// 			}
	// 		} else {
	// 			changes = record.getChanges();
	// 			if (dataRow.action=='update' && changes["checked"]!=undefined && changes["checked"]==false) {
	// 				dataRow.action='destroy'
	// 				}
	// 			else {
	// 				fLen = fieldItems.length;
	// 				for (f = 0; f < fLen; f++) {
	// 					field = fieldItems[f];

	// 					if (field[nameProperty] && field.isAlwaysSubmitable && (field.submitValue==undefined || field.submitValue==true)) {
	// 						name       = field[nameProperty] || field.name;
	// 						dataRow.data[name] = record.get(field.name);
	// 					}
	// 				}
	// 				// Also write the changes
	// 				for (key in changes) {
	// 					if (key && (fields.get(key).submitValue==undefined || fields.get(key).submitValue) && changes.hasOwnProperty(key)) {
	// 						field      = fields.get(key);
	// 						name       = field[nameProperty] || field.name;
	// 						if (field[nameProperty]) {
	// 							dataRow.data[name] = changes[key];
	// 						}
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
        
 //        if(isPhantom) {
 //            if(clientIdProperty && operation && operation.records.length > 1) {
 //                // include clientId for phantom records, if multiple records are being written to the server in one operation.
 //                // The server can then return the clientId with each record so the operation can match the server records with the client records
 //                dataRow.data[clientIdProperty] = record.internalId;
 //            }
 //        } else {
 //            // always include the id for non phantoms
 //            if (fields.get(record.idProperty)[nameProperty]) dataRow.data[fields.get(record.idProperty)[nameProperty]] = record.getId();
 //        }
	// 	dataRow.data.metaData=(dataRow.data.metaData || {});
	// 	if (record.store) {
	// 		if (!record.store.storeId) record.store.storeId='Store-'+Ext.id()
	// 		if (!Ext.getStore(record.store.storeId)) Ext.data.StoreManager.register(record.store)
	// 		dataRow.data.metaData["storeId"] = record.store.storeId;
	// 		dataRow.data.metaData["internalId"] = record.internalId;
	// 	}
	// 	//Ext.getStore(record.store.storeId).getById(record.internalId)
		
	// //http://www.sencha.com/forum/showthread.php?141957-Saving-objects-that-are-linked-hasMany-relation-with-a-single-Store
 //        //Iterate over all the hasMany associations
	// 	for (i = 0; i < record.associations.length; i++) {
 //            association = record.associations.get(i);
	// 		if (association.type=='hasMany' || association.type=='hasOne') {
	// 			childStore = record[(association.type=='hasMany')? (
	// 				association.storeName
	// 			) : (
	// 				association.instanceName
	// 			)];

	// 			var associationStore = { settings: {catalogName:association.tableName/*association.associatedName*/, identityKey: association.identityKey, primaryKey: association.primaryKey, foreignKey:association.foreignKey }, records: [] };

	// 			dataRow.associations[association.name]=associationStore;
				
	// 			if (childStore.getRootNode) {
	// 				childStore.getRootNode().cascadeBy(function(childRecord) {


	// 				//Recursively get the record data for children (depth first)
	// 				var child = me.getRecordData.call(me, childRecord);

	// 				/*
	// 				 * If the child was marked dirty or phantom it must be added. If there was data returned that was neither
	// 				 * dirty or phantom, this means that the depth first recursion has detected that it has a child which is
	// 				 * either dirty or phantom. For this child to be put into the prepared data, it's parents must be in place whether
	// 				 * they were modified or not.
	// 				 */
	// 				if (childRecord.dirty | childRecord.phantom | (child && child.records != null)){
	// 					dataRow.associations[association.name].records.push(child);
	// 					//record.setDirty();
	// 				}
	// 			}, me);
	// 			} else if (childStore.each) {
	// 			//Iterate over all the children in the current association
	// 			childStore.each(function(childRecord) {


	// 				//Recursively get the record data for children (depth first)
	// 				var child = me.getRecordData.call(me, childRecord);

	// 				/*
	// 				 * If the child was marked dirty or phantom it must be added. If there was data returned that was neither
	// 				 * dirty or phantom, this means that the depth first recursion has detected that it has a child which is
	// 				 * either dirty or phantom. For this child to be put into the prepared data, it's parents must be in place whether
	// 				 * they were modified or not.
	// 				 */
	// 				if (childRecord.dirty | childRecord.phantom | (child && child.records != null)){
	// 					dataRow.associations[association.name].records.push(child);
	// 					//record.setDirty();
	// 				}
	// 			}, me);
	// 			} else {
	// 				var child = me.getRecordData.call(me, childStore);
	// 				if (child && (child.records != null || child.data)) {
	// 					dataRow.associations[association.name].records.push(child);
	// 				}
	// 			}

	// 			/*
	// 			 * Iterate over all the removed records and add them to the preparedData. Set a flag on them to show that
	// 			 * they are to be deleted
	// 			 */
	// 			Ext.each(childStore.removed, function(removedChildRecord) {
	// 				//Set a flag here to identify removed records
	// 				removedChildRecord.set('forDeletion', true);
	// 				var removedChildData = me.getRecordData.call(me, removedChildRecord);
	// 				dataRow.associations[association.name].records.push(removedChildData);
	// 				//record.setDirty();
	// 			});
	// 		}
 //        }
 //    }
});	