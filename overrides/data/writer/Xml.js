Ext.define('Panax.data.writer.Xml', {
	override: 'Ext.data.writer.Xml',

	constructor: function (config) {
		this.callParent(arguments); 
	},
	
	documentRoot: 'dataTable',
	//record: 'dataRow',
	
	createXMLTable: function(dataTable) {
            var me = this,
                xml = [],
                i = 0,
                records = dataTable.records,
                len = records.length,
                root = me.documentRoot,
                item,
                key;
            xml.push('<', root, ' name="', dataTable.params.catalogName,'"',function(){return (dataTable.identityKey?' identityKey="'+dataTable.identityKey+'"':'')}(),'',function(){return (dataTable.params.primaryKey && dataTable.params.primaryKey.length?' primaryKey="'+dataTable.params.primaryKey.join('],[')+'"':'')}(), function(){return (dataTable.params.foreignKey?' foreignKey="'+dataTable.params.foreignKey+'"':'')}(),'>');
				xml.push(this.createXMLRows(dataTable));
            xml.push('</', root, '>');
            return xml.join('');
	},
	
	createXMLRows: function(dataTable){
            var me = this
                , xml = []
                , i = 0
				, records = dataTable.records
                , len = records.length
                , root = me.getDocumentRoot()
                , record
                , key
				, association
				, transform;
                
			transform = this.getTransform();
			if (transform) {
				data = transform(data, request);
			}
				
            // may not exist
            xml.push(me.getHeader() || '');
			var deleteXML = [] 
			for (; i < len; ++i) {
                var record = records[i];
    			var dataRow=(record.action=='destroy'?'deleteRow':'dataRow');
				var currentXMLNode=[]
                currentXMLNode.push('<', dataRow, function() { return !dataTable.identityKey?'':(' identityValue="'+(record.action=='create'?'NULL':Ext.XML.encodeValue(record.data[dataTable.identityKey]))+'"')}()
				,function(){
					var attributesString='';
					for (var attribute in record.data["metaData"]) {
						attributesString+=' '+attribute+'="'+record.data["metaData"][attribute]+'"';
					}
					return attributesString;
				}()
				,'>');// renovado
				
				delete record.data["metaData"];
    			if (record.action!='destroy') {
    				for (key in record.data) {
						if (key && record.data.hasOwnProperty(key) && key!=dataTable.identityKey) { // && key!=dataTable.identityKey
							var pv = record.previousValues[key], value = record.data[key]
    						currentXMLNode.push('<dataField name="', key, '"'
								, (record.primaryValues[key] && pv && pv!==value)?' previousValue="'+Ext.XML.encodeValue(pv)+'"':''
								, record.primaryValues[key]?' isPK="true"':''
							,'>', Ext.XML.encodeValue(value), '</dataField>');// renovado
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