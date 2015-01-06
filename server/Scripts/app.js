Ext.Loader.setConfig({enabled: true});
Ext.ns('Panax');
Ext.ns('Panax.util');
Ext.ns('util');

Ext.ns('app');
Panax.rootPath = "../../../../"
Ext.Loader.setPath({
	'Ext.ux': Panax.rootPath+'resources/extjs/extjs-current/examples/ux',
	'Ext.custom.ux': Panax.rootPath+'resources/extjs/custom/ux/',
	'Ext.app': Panax.rootPath+'resources/extjs/extjs-current/examples/portal/classes',
	'app': '../custom/scripts',
	'Px': '../cache/app'
});
Ext.require('app.config');
Ext.require([
	'Ext.Viewport',
	'Ext.data.JsonStore',
	'Ext.tip.QuickTipManager',
	'Ext.tab.Panel',
	'Ext.ux.GroupTabPanel',
	'Ext.grid.*',
	'Ext.app.PortalColumn',
	'Ext.app.PortalDropZone',
	'Ext.app.Portlet',
	'Ext.app.GridPortlet',
	'Ext.app.PortalPanel',
	'Ext.app.ChartPortlet',
	'Ext.ux.grid.FiltersFeature',
	'Ext.toolbar.Paging',
	'Ext.ux.ToolbarDroppable',
	'Ext.ux.BoxReorderer',
	'Ext.ux.RowExpander',
	'Ext.ux.ajax.JsonSimlet',
	'Ext.ux.ajax.SimManager',
	'Ext.ux.data.PagingMemoryProxy',
    'Ext.ux.CheckColumn',
    'Ext.custom.ux.LiveSearchGridPanel'
	//'Panax.data.writer.Xml',
]);

 Ext.apply(Ext.form.field.VTypes, {
	daterange: function(val, field) {
		var date = field.parseDate(val);

		if (!date) {
			return false;
		}
		if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
			var start = field.up('form').down('#' + field.startDateField);
			start.setMaxValue(date);
			start.validate();
			this.dateRangeMax = date;
		}
		else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
			var end = field.up('form').down('#' + field.endDateField);
			end.setMinValue(date);
			end.validate();
			this.dateRangeMin = date;
		}
		/*
		 * Always return true since we're only using this vtype to set the
		 * min/max allowed values (these are tested for after the vtype test)
		 */
		return true;
	},

	daterangeText: 'La fecha de inicio debe ser menor que la fecha de término',

	password: function(val, field) {
		if (field.confirmationPassField) {
			var pwd = field.confirmationPassField; //field.up('form').down('#' + field.confirmationPassField);
			return (val == pwd.getValue());
		}
		return true;
	},

	passwordText: 'Los passwords no coinciden'
});
// Panax.session.loginStatus

// Basado en http://stackoverflow.com/questions/10932002/how-to-create-a-field-class-containing-an-image-in-ext-js-4
Ext.define('Panax.view.base.FileManager', { 
    extend: 'Ext.container.Container', 
    alias: 'widget.filemanager', 
 
    NO_IMAGE_FILE: 'Images/FileSystem/blank.png', 
    IMAGE_ERROR:  'Images/Advise/vbExclamation.gif', 
    UPLOAD_URL:     '/UploadImage', 
    CLEAR_URL:  '/ClearImage/', 
 
    width: 205, 
	layout: { type: 'table', columns: 2 },
	// src: '../../../../Images/FileSystem/no_photo.gif',
	name: undefined,
	readOnly: false,
	title: undefined,//'Imagen',
	showPreview: false,
	showFileName: true,
	src: '',
	parentFolder: '',
	
	getFileExtension: function(filePath) {
		return "Images/FileSystem/"+filePath.replace(/.+\.(\w+)$/, '$1')+".png"
	},
		
	getFileName: function(filePath) {
		return filePath.replace(/.+[\/\\](.+?)$/, '$1')
	},
		
		
    initComponent: function() { 
        var me = this; 
		var imageHolder = { 
			xtype: 'image', 
			itemId: 'image', 
			height: 100,
			maxWidth: 100, 
			maxHeight: 100 
		}
        Ext.apply(me, { 
            items: [{
			xtype: 'container',
			layout: { type: 'vbox' , flex: 1},
			itemId: 'progressBar',
			colspan: 2,
			hidden: true,
			items: [{
				xtype: 'progressbar',
				text:'Esperando...',
				itemId:'progressBar_bar',
				cls:'custom',
				width: '220', flex: 0
				}, {
					xtype: 'hiddenfield',
					name: me.name,
					itemId: 'fileName',
					colspan: 2, 
					listeners: {
						change: function(el, val) {
							me.fileChange(el, val);
						}
					}
				}/* , {
				xtype: 'component',
				html: '<span id="p4text"></span>'
			}*/]
			}, /* {xtype:'textfield'}, */!(me.title)?imageHolder:{ 
                xtype: 'fieldset', 
                itemId: 'imageWrapper', 
                title: me.title, 
                width: 122, 
                height: 140, 
                margin: '0 0 0 0', 
                layout: 'anchor', 
                items: [imageHolder] 
            }, { 
                xtype: 'container', 
                margin: '4 0 0 5', 
                layout: {
					type:'vbox',
					padding:'5',
					pack:'end',
					align:'center'
				},
				itemId: 'buttonsContainer',
                defaults: { 
                    xtype: 'button', 
                    width: 70, 
                    margin: '0 0 5 0'
                }, 
                items: [{ 
						xtype: 'fileuploadfield', 
						buttonOnly: true, 
						hideLabel: true, 
						itemId: 'uploadButton', 
						buttonText: 'Explorar...', 
						buttonConfig: { width: 70 }, 
						hidden: true,
						listeners: { 
							change: function(el, value) {
								// this.up('window').fireEvent('uploadimage', fb, v); 
								if (value!='') {
									Ext.MessageBox.confirm('SUBIR ARCHIVO', 'Confirma que desea subir el archivo "'+value+'" al servidor?', function(result){
										if (result=="yes") me.uploadImage(el, value);
									})
								}
							}
						}
					}, { 
						itemId: 'clearButton', 
						text: 'Quitar', 
						hidden: true,
						handler: function() { 
							me.clearImage(); 
						} 
					}
					/*, { 
                    itemId: 'fullResButton', 
                    text: 'Download', 
                    hidden: me.readOnly,
                    handler: function() {  
                        window.open(me.fullImagePath); 
                    } 
                }*/]
            },
			{ 
				xtype: 'displayfield',
				itemId: 'label',
				colspan: 2,
				hidden: !(me.showFileName)
			}]
		}); 
		
        me.callParent(arguments); 
		me.loadImage(me.src);
    }, 
	
	showFileLabel: function(filePath) {
		var me = this, 
		label= me.down("[itemId=label]");
		label.setValue(me.getFileName(filePath))
	},
	
	fileChange: function(el, val) {
        var me = this, imagePath = val;
		me.showFileLabel(val);
		if (val!='' && !(me.showPreview)) imagePath=me.getFileExtension(imagePath)
		me.loadImage(imagePath);
	},
	
    success: function() { 
        var me = this, 
            fs = me.down('[itemId=imageWrapper]'), 
            b1 = me.down('[itemId=clearButton]'), 
            b2 = me.down('[itemId=fullResButton]'); 
 
        fs.enable(); 
        b1.enable(); 
        b2.enable(); 
    }, 

	renderButtons: function(val) {
        var me = this, 
			buttonsContainer = me.down('[itemId=buttonsContainer]'),
            uploadButton = me.down('[itemId=uploadButton]'), 
            clearButton = me.down('[itemId=clearButton]'), 
            img = me.down('image'); 

		if (me.readOnly) return false;
		
		if (val!='') {
			if (uploadButton && uploadButton.isVisible()) { 
				uploadButton.hide()
			}
			if (!me.readOnly && clearButton && !clearButton.isVisible()) {
				clearButton.show()
			}
		} else {
			if (clearButton && clearButton.isVisible()) {
				clearButton.hide()
			}
			if (!me.readOnly && uploadButton && !uploadButton.isVisible()) {
				uploadButton.show()
				// me.down('[itemId=buttonsContainer]').add({ 
						// xtype: 'fileuploadfield', 
						// buttonOnly: true, 
						// hideLabel: true, 
						// itemId: 'uploadButton', 
						// buttonText: 'Explorar...', 
						// buttonConfig: { width: 70 }, 
						// hidden: me.readOnly,
						// listeners: { 
							// change: function(el, value) {
								// // this.up('window').fireEvent('uploadimage', fb, v); 
								// if (value!='') {
									// Ext.MessageBox.confirm('SUBIR ARCHIVO', 'Confirma que desea subir el archivo "'+value+'" al servidor?', function(result){
										// if (result=="yes") me.uploadImage(el, value);
									// })
								// }
							// }
						// }
					// })
				// }
			}
		}
	},
	
    loadImage: function(val) { 
		var me = this,
		fileThumbnail = me.down('[itemId=image]');
		imagePath = val!=''?val : me.NO_IMAGE_FILE
		
		//img.getEl().on('load', me.success, me, { single: true }); 
		var imageEl = fileThumbnail.getEl()
		if (imageEl) {
			imageEl.on('error', function() {  
				//img.getEl().un('load', me.success, me); 
				//Panax.rootPath+me.NO_IMAGE_FILE
				if (val!='') fileThumbnail.setSrc(Panax.rootPath+me.getFileExtension(val)); 
				//fs.enable(); 
			}, me, { single: true }); 
		}

		fileThumbnail.setSrc(Panax.rootPath+imagePath);
		
		me.renderButtons(val);
		

        /*me.fullImagePath = me.DOWNLOAD_URL + '/' +recordId; 
        me.imageRecordId = recordId; 
 
        fs.disable(); 
        b1.disable(); 
        b2.disable(); 
 
        img.getEl().on('load', me.success, me, { single: true }); 
        img.getEl().on('error', function() {  
 
            img.getEl().un('load', me.success, me); 
            img.setSrc(me.NO_IMAGE_FILE); 
            fs.enable(); 
 
        }, me, { single: true }); 
 
        img.setSrc(me.DOWNLOAD_URL + '/' +recordId); */
    }, 
 
    uploadImage: function(el, val) { 
		var clonedField = Ext.clone(el);
		clonedField.name="cloned-node";
		clonedField.id="cloned-node";
		clonedField.isFieldLabelable=false;
		el.isFieldLabelable=false;
		var me = this, 
            fm = Ext.create('Ext.form.Panel', { 
                items: [ clonedField ] 
            }), 
            f = fm.getForm(); 
			clonedField.ownerCt=undefined; //esta línea es para que no marque error, ya que al clonar e insertar en el formulario, quita físicamente el botón y por lo tanto ya no existe el ownerCt.el
			
		var progressBar = me.down('[itemId=progressBar]')
		progressBar.show();
		//progressBar.show(true);
		var uploadID = Math.round(Math.random()*1000000000)
		f.submit({
			url: '../Scripts/fileUploader.asp?UploadID='+uploadID+'&parentFolder='+(app.config.filesRepositoryPath || '')+'/'+me.parentFolder/*+'saveAs=image.png'*/,
			waitMsg: 'Subiendo archivo...',
			success: function(fp, o) {
				var fileName = me.down('[itemId=fileName]');
				fileName.setValue(o.result.files[1].file);
				Ext.Msg.alert('Completo', 'Archivo procesado "' + o.result.files[1].file + '" en el servidor', function(){ progressBar.hide(true); });
			},
			exception: function(fp, o) {
				console.log('upload failed', fp, o); 
				// Ext.TaskManager.stop(task);
			}
		});
		task = { 
			run: function(){ 
				Ext.Ajax.request({
					url: '../Scripts/uploadFileManager.asp?UploadID='+uploadID,
					method: 'GET',
					success: function(xhr, r) {
						var result = Ext.JSON.decode(xhr.responseText)
						if (task && result.percent>=100) Ext.TaskManager.stop(task);
						progressBar.down('[itemId=progressBar_bar]').updateProgress(result.percent/100, Math.round(result.percent)+'% completado...');
					},
					failure: function() {
						//myMask.hide();
						Ext.MessageBox.show({
							title: 'Error de comunicación',
							msg: "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.",
							icon: Ext.MessageBox.ERROR,
							buttons: Ext.Msg.OK
						});
					}
				});
			}, 
			interval: 1500
		} 
		Ext.TaskManager.start(task); 
        // f.submit({ 
            // method: 'POST', 
            // params: { 
                // recordId: me.imageRecordId  
            // }, 
            // url: me.UPLOAD_URL, 
            // waitMsg: 'Uploading your image...', 
            // success: function(fp, o) { 
                // me.loadImage(me.imageLocation, me.imageRecordId); 
            // }, 
            // failure: function(fp, o) { 
                // console.log('upload failed', fp, o); 
            // } 
        // }); 
    }, 
 
    clearImage: function() { 
        var me = this; 
		Ext.MessageBox.confirm('SUBIR ARCHIVO', 'Confirma que desea desasignar el archivo?', function(result) {
			if (result=="yes") {
				var fileName = me.down('[itemId=fileName]');
				fileName.setValue('');
				/*Ext.Ajax.request({ 
					method: 'GET', 
					url: me.CLEAR_URL + me.imageLocation + '/' + me.imageRecordId, 
					success: function(fp, o) { me.loadImage(me.imageLocation, me.imageRecordId); }, 
					failure: function(fp, o) { console.log('upload failed', fp, o); } 
				}); */
			}
		})
    } 
}); 

Ext.define('Panax.view.base.ImageContainer', { 
    extend: 'Panax.view.base.FileManager', 
    alias: 'widget.imagemanager', 
	
    NO_IMAGE_FILE:  'Images/FileSystem/no_photo.gif', 
	fileChange: function(el, val) {
        var me = this, imagePath = val;
		me.showFileLabel(val);
		me.loadImage(imagePath);
	},
	showFileName: false,
	initComponent: function(){
		this.callParent();
	}
});

Ext.define('Panax.Facebook', {
    extend: 'Ext.Component', 
    alias: 'widget.facebook', 
	height: 100,
	html:'<div class="fb-like" data-send="true" data-width="450" data-show-faces="true" data-font="arial"></div>',
	initComponent: function(){
		this.callParent();
	}
});

/* Ext.define('Panax.Facebook', {
    extend: 'Ext.container.Container', 
    alias: 'widget.facebook', 
	
	lang: 'es',
	user: 'twitterapi',
	showCount: true,
	showScreenName: true,
	optOut: false,

    initComponent: function(){
		Ext.apply(this, {items:[{
			xtype: 'container',
			layout: {type: 'vbox' , flex: 1},
			itemId: 'holder'
			}]
		});
		this.callParent();
	}
	, loadButton: function() {
		var me = this;
        me.down('[itemId=holder]').add({
			xtype: 'component',
			html: '<iframe src="http://www.facebook.com/plugins/like.php?href=https://www.facebook.com/uriel.online" scrolling="no" frameborder="0" style="border:none; width:450px; height:80px"></iframe>'
		});
	}
	
	, listeners: {
		afterrender: function() {
		var me = this;
		me.loadButton();
		}
	}
}); */

Ext.define('Panax.Twitter', { //https://dev.twitter.com/docs/follow-button
    extend: 'Ext.container.Container', 
    alias: 'widget.twitter', 
	
	lang: 'es',
	user: 'twitterapi',
	showCount: true,
	showScreenName: true,
	optOut: false,

    initComponent: function(){
		Ext.apply(this, {items:[{
			xtype: 'container',
			layout: {type: 'vbox' , flex: 1},
			itemId: 'twitterholder'
			}]
		});
		this.callParent();
	}
	, loadButton: function() {
		var me = this;
        me.down('[itemId=twitterholder]').add({
			xtype: 'component',
			html: '<iframe allowtransparency="true" frameborder="0" scrolling="no" src="//platform.twitter.com/widgets/follow_button.html?lang='+this.lang+'&screen_name='+this.user+'&show_count='+this.showCount+'&show_screen_name='+this.showScreenName+'&dnt='+this.optOut+'" style="width:300px; height:20px;"></iframe>'
		});
	}
	
	, listeners: {
		afterrender: function() {
		var me = this;
		me.loadButton();
		}
	}
});

Ext.define('Panax.controls.monthPicker', { 
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.monthpicker'
	
	, displayField: 'text'
	, valueField: 'id'
	, queryMode: 'local'
	, forceSelection: true
	, width: 150
	, initComponent: function(){
		var me = this;
		Ext.apply(me, {
		margins: '0 6 0 0'
			, store: Ext.create('Ext.data.Store', {
				fields: ['text', 'id'],
				data: (function() {
					var data = [];
					Ext.Array.forEach(Ext.Date.monthNames, function(text, i) {
						data[i] = {text: text, id: i + 1};
					});
					return data;
				})()
			})
		});
		this.callParent();
	}
	// , setValue: function(value) {
	// }
	, listeners: {
		select: function(combo, records, eOptions) {

		}
	}
});

Ext.define('Panax.controls.yearPicker', { 
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.yearpicker'
	, startYear: new Date().getFullYear()
	, endYear: 1981
	, displayField: 'text'
	, valueField: 'id'
	, queryMode: 'local'
	, forceSelection: true
	, width: 80
	, initComponent: function(){
		var me = this;
		Ext.apply(me, {
		margins: '0 6 0 0'
			, store: Ext.create('Ext.data.Store', {
				fields: ['text', 'id'],
				data: (function() {
					var data = [];
					var descOrder = me.startYear>=me.endYear;
					var c = 0
					for (var i=me.startYear; descOrder?i>=me.endYear:i<me.startYear; descOrder?--i:++i) {
						data[c++] = {text: i, id: i};
					}
					return data;
				})()
			})
		});
		this.callParent();
	}
	// , setValue: function(value) {
	// }
	, listeners: {
		select: function(combo, records, eOptions) {
			var me = this;
			if (me.onchange_event) me.onchange_event(combo, records, eOptions);
		}
	}
});

Ext.define('Panax.controls.timePicker', { /*TODO: Cambiar este control a dos spinners*/
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.timepicker'
	, minValue: 00
	, maxValue: 23
	, increment: 15
	, displayField: 'text'
	, valueField: 'id'
	, queryMode: 'local'
	, forceSelection: true
	, width: 90
	// , setMinValue: function(minValue) {
		// var me=this;
		// me.minValue = minValue;
	// }
	// , setMaxValue: function(maxValue) {
		// var me=this;
		// me.maxValue = maxValue;
	// }
	, initComponent: function(){
		var me = this;
		me.maxValue = (me.maxValue || 23)
		Ext.apply(me, {
		margins: '0 6 0 0'
			, store: Ext.create('Ext.data.Store', {
				fields: ['text', 'id'],
				data: (function() {
					var data = [];
					var descOrder = me.minValue>=me.maxValue;
					var c = 0
					data[c++] = {text: '', id: null};
					for (var h=me.minValue; descOrder?h>=me.maxValue:h<=me.maxValue; descOrder?--h:++h) {
						for (var m=0; m<=59; m=m+me.increment) {
						
							data[c++] = {text: (h>=10?h:'0'+h)+':'+(m>=10?m:'0'+m)+' Hrs.', id: h+':'+m};
						}
					}
					return data;
				})()
			})
		});
		this.callParent();
	}
	/* , setValue: function(value) {
		var tempDate = new Date();
		tempDate.setMinutes(value.split(':')[0] || 0)
		tempDate.setSeconds(value.split(':')[1] || 0)
		oTime.setValue(value?value.getHours()+':'+value.getMinutes():'');
	} */
	, listeners: {
		select: function(combo, records, eOptions) {

		}
		, blur: function(){
			var me = this
			if (me.store) {
				me.store.clearFilter(true)
			}
		}
	}
});

Ext.define('Panax.controls.TimeField', { /*TODO: Cambiar este control a dos spinners*/
    extend: 'Ext.form.field.Spinner',
    alias: 'widget.customtimefield'
	, minValue: "00:00"
	, maxValue: "24:00"
	, increment: 30
	, step: 30
	, displayField: 'text'
	, valueField: 'id'
	, width: 60
	, editable: false
	, unformatValue: function(val) {
		return parseInt(String(val).replace(/:/i, '').split(' '), 10)
	}
	, setValue: function(val) {
        var me = this;
		if (val!=='' && val!=undefined && val!=null && val!=NaN && (!me.minValue || me.minValue && val>=me.unformatValue(me.minValue)) && (!me.maxValue || me.maxValue && val<=me.unformatValue(me.maxValue))) { 
			if (val==2400) val=0000
			val=Panax.util.lPad(val, 4, '0');
			if (val.indexOf(':')==-1) {
				val= val.slice(0,-2) + ":" + val.slice(-2);
			}
			val=Panax.util.lPad(val, 5, '0')
			val=val+' Hrs.'
			me.setRawValue(val);
		}
	}
	, onSpinUp: function() {
        var me = this;
        if (!me.readOnly) {
            var val = parseInt(String(me.getValue()||me.minValue||'24:00').replace(/:/i, '').split(' '), 10)||0;
			var time, hour, minutes, direction
			if (val==2400) val=0000
			hour=val, diference=me.step, direction=1
			minutes=hour%100%60, hour=Math.floor(hour/100), time=util.dates.convert('1900/1/1 '+String(hour)+':'+String(minutes));
			time=util.dates.dateAdd('mi', diference*direction, time)

			val=time.getHours()*100+time.getMinutes()
			if (val==0) val=2400
			if (me.maxValue && val>parseInt(String(me.maxValue).replace(/:/i, '').split(' '), 10)) val=me.maxValue
            me.setValue(val);
        }
    }

    // override onSpinDown
    , onSpinDown: function() {
        var val, me = this;
        if (!me.readOnly) {
            var val = parseInt(String(me.getValue()||me.maxValue||'00:00').replace(/:/i, '').split(' '), 10)||0;
			var time, hour, minutes, direction
			if (val==2400) val=0000
			hour=val, diference=me.step, direction=-1
			minutes=hour%100%60, hour=Math.floor(hour/100), time=util.dates.convert('1900/1/1 '+String(hour)+':'+String(minutes));
			time=util.dates.dateAdd('mi', diference*direction, time)

			val=time.getHours()*100+time.getMinutes()
			if (me.minValue && val<parseInt(me.minValue.replace(/:/i, '').split(' '), 10)) val=me.minValue

            me.setValue(val);
        }
    }
	// , setMinValue: function(minValue) {
		// var me=this;
		// me.minValue = minValue;
	// }
	// , setMaxValue: function(maxValue) {
		// var me=this;
		// me.maxValue = maxValue;
	// }
	, initComponent: function(){
		var me = this;
		me.on("change", function(control, newValue, oldValue, eOpts){ 

		});
		// me.maxValue = (me.maxValue || 23)
		// Ext.apply(me, {
		// margins: '0 6 0 0'
			// , store: Ext.create('Ext.data.Store', {
				// fields: ['text', 'id'],
				// data: (function() {
					// var data = [];
					// var descOrder = me.minValue>=me.maxValue;
					// var c = 0
					// data[c++] = {text: '', id: null};
					// for (var h=me.minValue; descOrder?h>=me.maxValue:h<=me.maxValue; descOrder?--h:++h) {
						// for (var m=0; m<=59; m=m+me.increment) {
						
							// data[c++] = {text: (h>=10?h:'0'+h)+':'+(m>=10?m:'0'+m)+' Hrs.', id: h+':'+m};
						// }
					// }
					// return data;
				// })()
			// })
		// });
		this.callParent();
	}
	/* , setValue: function(value) {
		var tempDate = new Date();
		tempDate.setMinutes(value.split(':')[0] || 0)
		tempDate.setSeconds(value.split(':')[1] || 0)
		oTime.setValue(value?value.getHours()+':'+value.getMinutes():'');
	} */
	, listeners: {
		select: function(combo, records, eOptions) {

		}
		, blur: function(){
			var me = this
			if (me.store) {
				me.store.clearFilter(true)
			}
		}
	}
});

// Ext.define('Panax.controls.FieldContainerControl', {
	// extend: 'Ext.form.FieldContainer',
	// mixins: {
		// field: 'Ext.form.field.Field'
	// },
    // initComponent: function() { 
		// var me = this;
        // me.callParent(arguments);
	// },
	// alias: 'widget.fieldcontainercontrol',
    // requires: ['Ext.form.field.Base'],
	
	// combineErrors: true,
	// baseCls: 'x-datetime',
	// fieldBodyCls: 'x-datetime-body'
	
	// , getRawValue: function() {
         // var me = this;
		 // var v = Ext.value(me.getValue(),'');
         // me.rawValue = v;
         // return v;
    // }
	// , setRequired: function(required) {
		// this.allowBlank=!required;
		// // Ext.Array.each(this.items.items, function(obj, index, thisArray){
			// // obj.allowBlank=!required;
		// // });
		// if (required) {
			// this.addCls('required')
		// } else {
			// this.removeCls('required')
		// }
	// }
// });

Ext.define('Panax.controls.DateTimeField', { 
    extend: 'Ext.form.FieldContainer',
    mixins: {
        field: 'Ext.form.field.Date'
    },
    alias: 'widget.datetimefield',
    requires: ['Ext.form.field.Base'], 
 
	layout: { type: 'table', columns: 2 },
	// src: '../../../../Images/FileSystem/no_photo.gif',
	name: undefined
	,submitValue: false
	,readOnly: false
	,combineErrors: true
	,baseCls: 'x-datetime'
	,fieldBodyCls: 'x-datetime-body'
	,minValue: undefined //new Date()
	,maxValue: undefined //new Date()
	
	,minHour: 22
	,validate: function() {
		var me=this, oDate=me.down('#date'), oTime=me.down('#time');
		return oDate.validate();
	}
	,setMaxValue: function(maxValue) {
		var me=this, oDate=me.down('#date'), oTime=me.down('#time');
		me.maxValue=maxValue;
		oDate.setMaxValue(maxValue);
		//oTime.setMaxValue(maxValue?maxValue.getHours()+':'+maxValue.getMinutes():'');
		me.validate();
	}
	,setMinValue: function(minValue) {
		var me=this, oDate=me.down('#date'), oTime=me.down('#time');
		me.minValue=minValue;
		oDate.setMinValue(minValue);
		//oTime.setMinValue(minValue?minValue.getHours()+':'+minValue.getMinutes():'');
		me.validate();
	}
    ,initComponent: function() { 
		var me = this;
		Ext.apply(me, {
			items: [{
				xtype: 'datefield'
				,itemId: 'date'
				,format: 'd/m/Y'
				,hideErrorText: true 
				,minValue: me.minValue
				,maxValue: me.maxValue
				,vtype: me.vtype
				,startDateField: me.startDateField
				,endDateField: me.endDateField
				,width: 100
				,listeners: {
					blur: function() {
						me.validate()
						me.fireEvent('change')
						}
					}
				}, {
					xtype:'timepicker'//'customtimefield'
					,itemId: 'time'
					,minValue: "07:00"
					// ,maxValue: me.maxValue?me.maxValue.getHours()*100+me.maxValue.getMinutes():me.maxHour
					,hideErrorText: true 
					,width:90
					//,format:'H:i'
					, listeners: {
						blur: function() {
							if (this.store) {
								this.store.clearFilter(true)
							}
							me.fireEvent('change')
						}
					}
				}
			]
		});
		// Set up a model to use in our Store
        me.callParent(arguments);
        me.initField();
		 Ext.Array.each(me.items.items, function(obj, index, thisArray) {
			 if (obj.name==me.name) obj.name+='_internal'
		 });
    }
	// , getErrors: function (value){
		// if(!this.allowBlank){
			// var me = this;
			// var internalErrors = [];
			// Ext.Array.each(this.items.items, function(obj, index, thisArray) {
				 // obj.getErrors();
				 // if(obj.getActiveErrors().length){
					// internalErrors.push(obj.getErrors());
				 // }
			 // });
			 // return internalErrors;
		 // }
	// }
	, getRawValue: function() {
         var me = this;
		 var v = Ext.value(me.getValue(),'');
         me.rawValue = v;
         return v;
    }
	, setValue: function(value) {
		var me = this;
		var currentValue = me.getValue()
		var oDate=me.down('#date'), oTime=me.down('#time');
		oDate.setValue(value);
		oTime.setValue(value?value.getHours()+':'+value.getMinutes():'');
		if (util.dates.compare(currentValue, me.getValue())!=0) 
			me.fireEvent('change')
	}
	, getValue: function() {
		var me = this;
		var oDate = me.down('#date');
		var oTime = me.down('#time');
		
		var value = oDate.getValue()
		if (value) {
			value.setHours(value.getHours()+(oTime.getValue() && oTime.getValue()[oTime.valueField]?oTime.getValue()[oTime.valueField].split(':')[0]:0 || 0))
			value.setMinutes(value.getMinutes()+(oTime.getValue() && oTime.getValue()[oTime.valueField]?oTime.getValue()[oTime.valueField].split(':')[1]:0 || 0));
		}
		return value
	}
	, setReadOnly: function(bReadonly) {
		var me = this;
		Ext.apply(me, {readOnly: bReadonly});
		Ext.Array.each(me.items.items, function(obj, index, thisArray) {
			obj.setReadOnly(bReadonly);
		});
	}
	, setRequired: function(required) {
		this.allowBlank=!required;
		// Ext.Array.each(this.items.items, function(obj, index, thisArray){
			// obj.allowBlank=!required;
		// });
		if (required) {
			this.addCls('required')
		} else {
			this.removeCls('required')
		}
	}
	, listeners: {
		change: function( control, newValue, oldValue, eOpts) {
			var me = this;
			if (me.onchange_event) me.onchange_event(control, newValue, oldValue, eOpts);
		}
	}

}); 

Ext.define('Panax.controls.PasswordField', { 
    extend: 'Ext.form.FieldContainer',
    alias: 'widget.passwordfield',
    requires: ['Ext.form.field.Base'], 
    mixins: {
        field: 'Ext.form.field.Field'
    },
 
	layout: { type: 'vbox' }
	,vtype:'password'
	,name: undefined
	,submitValue: false
	,readOnly: false
	,combineErrors: true
	,baseCls: 'x-password'
	,fieldBodyCls: 'x-password-body'
	
	,validate: function() {
		var me=this, oPassword=me.down('#password'), oConfirmPassword=me.down('#confirmPassword');
		oPassword.confirmationPassField=oConfirmPassword
		return oPassword.validate();
	}
    ,initComponent: function() { 
		var me = this;
		Ext.apply(me, {
			items: [{
				xtype: 'textfield'
				,inputType: 'password'
				,itemId: 'password'
				,hideErrorText: true 
				,vtype: me.vtype
				,width: 100
				,listeners: {
					blur: function() {
						me.validate()
						me.fireEvent('change')
						}
					}
				}, {
				xtype: 'textfield'
				,inputType: 'password'
				,itemId: 'confirmPassword'
				,hideErrorText: true 
				,vtype: me.vtype
				,width: 100
				,listeners: {
					blur: function() {
						me.validate()
						me.fireEvent('change')
						}
					}
				}
			]
		});
		// Set up a model to use in our Store
        me.callParent(arguments);
        me.initField();
    }
	
	, getRawValue: function() {
         var me = this;
		 var v = Ext.value(me.getValue(),'');
         me.rawValue = v;
         return v;
    }
	, setValue: function(value) {
		var me = this;
		var currentValue = me.getValue()
		var oPassword=me.down('#password'), oConfirmPassword=me.down('#confirmPassword');
		oPassword.setValue(value);
		oConfirmPassword.setValue(value);
		if (currentValue!=me.getValue()) 
			me.fireEvent('change')
	}
	, getValue: function() {
		var me = this;
		var oPassword=me.down('#password'), oConfirmPassword=me.down('#confirmPassword');
		
		var value = oPassword.getValue()
		return value
	}
	, setReadOnly: function(bReadonly) {
		var me = this;
		Ext.apply(me, {readOnly: bReadonly});
		Ext.Array.each(me.items.items, function(obj, index, thisArray) {
			obj.setReadOnly(bReadonly);
		});
	}
	, setRequired: function(required) {
		this.allowBlank=!required;
		// Ext.Array.each(this.items.items, function(obj, index, thisArray){
			// obj.allowBlank=!required;
		// });
		if (required) {
			this.addCls('required')
		} else {
			this.removeCls('required')
		}
	}
	, listeners: {
		change: function( control, newValue, oldValue, eOpts) {
			var me = this;
			if (me.onchange_event) me.onchange_event(control, newValue, oldValue, eOpts);
		}
	}

}); 

/* { type: 'hasMany', model: "dbo.SeguimientoProspecto", name: "SeguimientoProspecto", primaryKey: "IdSeguimientoProspecto", identityKey: 'IdSeguimientoProspecto', foreignKey: "IdProspecto", associationKey: "SeguimientoProspecto"}, */

Ext.define("Panax.model.treepanel", {
    extend: 'Ext.data.Model'
	, primaryKeys: 'id'
    , fields: [{name:'text'}]
	/* associations: [{
		type: 'hasMany',
		model: 'Panax.model.parentcombobox',
		identityKey: 'id',
		primaryKey: 'id',
		foreignKey: 'fk',
		autoLoad: true,
		name: 'Children',
		associationKey: 'children' // nombre de los hijos
	}], */
	, validations: []
    , initComponent: function(){
		this.callParent();
	}
});


Ext.define("Panax.model.combobox", {
    extend: 'Ext.data.Model',
	idProperty: 'id',
    fields: ['id', 'text', 'fk', 'children', 'metaData'],
	/* associations: [{
		type: 'hasMany',
		model: 'Panax.model.parentcombobox',
		identityKey: 'id',
		primaryKey: 'id',
		foreignKey: 'fk',
		autoLoad: true,
		name: 'Children',
		associationKey: 'children' // nombre de los hijos
	}], */
	validations: [],
    initComponent: function(){
		this.callParent();
	},
	proxy: {
		type: 'ajax',
		url: '../scripts/xmlCatalogOptions.asp',
		reader: {
			type: 'json',
			root: 'data',
			successProperty: 'success',
			messageProperty: 'message',
			totalProperty: 'total'
			//,idProperty: this.config.
		},
		pageParam: 'pageIndex',
		limitParam: 'pageSize',
		sortParam: 'sorters',
		extraParams: { output: 'json' },
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
	}/* ,
	associations: [
        { type: 'hasMany', model: "<xsl:value-of select="@Table_Schema" />.PhoneNumbers", name: "phonenumbers", primaryKey: 'IdProspecto', foreignKey: 'Prospecto' }
    ] */
});
/*
function convertField(v, record) {
	if (record.data.ApellidoPaterno) {
		return record.data.NombreProspecto + ', ' + record.data.ApellidoPaterno
	}
	else if(v && typeof v == 'object')
		{
		return v.value
		}
	else
		return v
}*/

Ext.define('Panax.controls.CascadedDropDown', { 
    extend: 'Ext.form.FieldContainer',
    mixins: {
        field: 'Ext.form.field.Base'
    },
    alias: 'widget.cascadeddropdown', 
 
	layout: { type: 'table', columns: 2 },
	// src: '../../../../Images/FileSystem/no_photo.gif',
	name: undefined,
	submitValue: false,
	readOnly: false,
	
    initComponent: function() { 
		var me = this;
		// Set up a model to use in our Store
        me.callParent(arguments);
        Ext.Array.each(me.items.items, function(obj, index, thisArray) {
			 if (obj.name==me.name) obj.name+='_internal'
		 });
		me.store=Ext.create('Ext.data.Store', {
			model: "Panax.model.combobox",
			listeners: {
				datachanged: function(store) {
					if (me.items.get(0) && me.items.get(0).store) {

						if (me.items.get(0).getStore().tree) {
							me.items.get(0).setRootNode(store.raw);
						}
						else {
							me.items.get(0).getStore().removeAll();
							me.items.get(0).getStore().add(store.data.items);
						}
					}					// var childStore = record[association.storeName];
					// childStore.each(function(childRecord) {


						// //Recursively get the record data for children (depth first)
						// var child = me.getRecordData.call(me, childRecord);

						// /*
						 // * If the child was marked dirty or phantom it must be added. If there was data returned that was neither
						 // * dirty or phantom, this means that the depth first recursion has detected that it has a child which is
						 // * either dirty or phantom. For this child to be put into the prepared data, it's parents must be in place whether
						 // * they were modified or not.
						 // */
						// if (childRecord.dirty | childRecord.phantom | (child && child.records != null)){
							// dataRow.associations[association.name].records.push(child);
							// //record.setDirty();
						// }
					// }, me);
				}
			}
		});
    }
	, cascadeStore: function(item, store) {
		item.data=store
	}
	, getErrors: function (value){
		var me = this, 
			errors = [],
			value = (value || me.getRawValue());
		
		if(this.allowBlank==false  && !value){
			errors.push("El campo es obligatorio");
		}
		return errors;
	}
	, setValue: function(value) {
		var me = this;
		var mainField = me.items.get(me.items.length-1)//.items.get(0)
		if (mainField) mainField.setValue(value)
	}
	, getInputEl: function() {
		var me = this;
		return me.items.get(me.items.length-1)//.items.get(0).getValue()
	}
	, getValue: function() {
		var me = this;
		var inputEl=me.getInputEl()
		return inputEl.getValue()
	}
	, getRawValue: function() {
        var me=this, 
			inputEl=me.getInputEl()
		var v = Ext.value((inputEl.getValue()||{})[inputEl.valueField],'');
        me.rawValue = v;
        return v;
    }
	, setReadOnly: function(bReadonly) {
		var me = this;
		Ext.apply(me, {readOnly: bReadonly});
		Ext.Array.each(me.items.items, function(obj, index, thisArray) {
			obj.setReadOnly(bReadonly);
		});
	}
	, setRequired: function(required) {
		this.allowBlank=!required;
		// Ext.Array.each(this.items.items, function(obj, index, thisArray){
			// obj.allowBlank=!required;
		// });
		if (required) {
			this.addCls('required')
		} else {
			this.removeCls('required')
		}
	}

}); 


Ext.define('Panax.Login', { 
    extend: 'Ext.window.Window',
    alias: 'widget.login',

	title: 'Ingrese al sistema',
	modal: true,
	width: 400,
	height:190,
	minWidth: 300,
	minHeight: 190,
	padding: 10,
	layout: 'border',
	plain: true,
	border:false,
	caseSensitive: true,
	closeAction: 'hide',
	defaults: {
		border:false
	}
	, listeners: {
		afterrender: function(thisForm, options) {
			this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
			  enter: this.onSubmitButton,
			  scope: this
			});
		}
		,beforeclose: function(panel, eOpts) {
			var continueScript
			if (this.onBeforeClose) continueScript=this.onBeforeClose(panel, eOpts)
			if (continueScript===false) return false
		}
		,close: function(panel, eOpts) {
			var login = this;
			var form = login.down('#loginForm').getForm();
			form.findField('password').setValue(''); //form.reset();
			if (this.onClose) this.onClose(panel, eOpts)
		}
	}
	, logo: undefined
	, onClose: function(panel, eOpts) {}
	, onSubmitButton: function() {
		var login = this;
		var form = login.down('#loginForm').getForm();
		if (form.isValid()) {
			Ext.Ajax.request({
				url: '../Scripts/login.asp',
				method: 'POST',
				params: {
					username: form.findField('username').getValue(),
					password: calcMD5(!(login.caseSensitive)?form.findField('password').getValue().toUpperCase():form.findField('password').getValue())
				},
				async:false,
				success: function(xhr, r) {
					var result = Ext.JSON.decode(xhr.responseText)
					if (result.success) {
						login.close();
						login.onSuccess();
					} else
					{
						Ext.MessageBox.show({
						title: 'Error',
						msg: result.message,
						icon: Ext.MessageBox.ERROR,
						buttons: Ext.Msg.OK,
						fn: function(result) {
							//form.findField('password').setValue(''); //form.reset();
							form.findField('password').focus(true, 200);
							}
						});
					}
					// if (task && result.percent>=100) Ext.TaskManager.stop(task);
					// progressBar.down('[itemId=progressBar_bar]').updateProgress(result.percent/100, Math.round(result.percent)+'% completado...');
				},
				failure: function() {
					//myMask.hide();
					Ext.MessageBox.show({
						title: 'Error de comunicación',
						msg: "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.",
						icon: Ext.MessageBox.ERROR,
						buttons: Ext.Msg.OK
					});
				}
			});
		}
	},
	onSuccess: function() {
		//location.href=location.href
	},
	items: [
		{
		region: 'west',
		id:'logoRegion',
		bodyCls: 'logoRegion',
		items: [{
				xtype: 'image',
				itemId: 'logoImage',
				baseCls: 'logo',
				padding: 15,
				width: 150
			}]
		},
		{
			region: 'center',
			items: [{
				xtype:'form',
				id: 'loginForm',
				border: false,
				fieldDefaults: {
					labelWidth: 55
				},
				defaultType: 'textfield',
				bodyPadding: 5,
				defaults: {
					labelAlign: 'top'
				},
				items: [{
					fieldLabel: 'Username',
					itemId: 'username',
					name: 'username',
					anchor: '100%'  // anchor width by percentage
				}, {
					fieldLabel: 'Password',
					inputType: 'password',
					itemId: 'password',
					name: 'password',
					anchor: '100%'
				}]
			}]
		}],

	buttons: [{
		text: 'Entrar',
		itemId: 'loginButton',
		handler: function() {
			var login = this.up('window');
			var form = login.down('#loginForm').getForm();
			login.onSubmitButton();
		}
	},{
		text: 'Cancelar',
		itemId: 'cancelButton',
		handler: function() {
			var login = this.up('window')
			login.onClose();
		}
	}]

	, initComponent: function(){
		this.callParent();
		Ext.apply(this.down("[itemId=logoImage]"), this.logo)
	}
})


Ext.define('Panax.controls.iphoneDatePicker', { 
    extend: 'Ext.container.Container', 
    alias: 'widget.iphonedatepicker'
	
	, settings:{
		yearField: {}
		, monthField: {}
		, dayField: {}
	}
	, layout: { type: 'table', columns: 3 }
	, listeners: {
		change: function() {
			
		}
	}
    , initComponent: function(){
		var me = this;
		Ext.apply(me, {items: [{
			xtype: 'numberfield',
			name: this.settings.yearField.name,
			hideLabel: true,
			width: 55,
			value: new Date().getFullYear(),
			maxValue: new Date().getFullYear(),
			allowBlank: false
		}, {
			xtype: 'combobox',
			name: this.settings.monthField.name,
			displayField: 'name',
			valueField: 'num',
			queryMode: 'local',
			emptyText: 'Month',
			hideLabel: true,
			margins: '0 6 0 0',
			store: Ext.create('Ext.data.Store', {
				fields: ['name', 'num'],
				data: (function() {
					var data = [];
					Ext.Array.forEach(Ext.Date.monthNames, function(name, i) {
						data[i] = {name: name, num: i + 1};
					});
					return data;
				})()
			}),
			allowBlank: false,
			forceSelection: true
		}, {
			xtype: 'numberfield',
			name: this.settings.dayField.name,
			hideLabel: true,
			width: 55,
			//value: new Date().getFullYear(),
			minValue: 1,
			maxValue: 31,
			maxLength: 2,
			allowBlank: false
		}]});
		this.callParent();
	}
});

Ext.define('Ext.catalogFilters', {
	extend: 'Ext.data.Store', 
	fields: ['id', 'text'],
	proxy: {
		type: 'ajax',
		url: 'request.asp',
		reader: 'array'
	}
});

Ext.apply(Panax, {
	NEW: '<new>',
	REFRESH: '<refresh>'
});

Ext.define('Panax.modalWindow', {
    extend: 'Ext.Window',
    alias: 'widget.modalWindow',
	itemId: 'modalWindow',
	title: 'Title goes here',
	modal: true,
	closable: true,
	//closeAction: 'hide',
	width: 800,
	minWidth: 350,
	height: 600,
	layout: {
		type: 'fit',
		padding: 5
	}
});

var comboManager = function(combo, records, eOptions) {
	if (combo.value["id"]==Panax.REFRESH) {
		combo.select(combo.getStore().data.items[0]);
		combo.store.reload();
		}
	else if (combo.value["id"]==Panax.NEW) {
		combo.select(combo.getStore().data.items[0]);
		/*here*/
		var instance=combo.settings
		instance["mode"]='insert'
		var content = Panax.getInstance(instance);
		// Ext.Ajax.request({
			// url: '../Templates/request.asp',
			// method: 'GET',
			// params: {
				// catalogName: combo.settings.catalogName,
				// mode: "insert",
				// output: 'extjs'
			// },
			// success: function(xhr) {
				// eval(xhr.responseText);
				
			// },
			// failure: function() {
				// myMask.hide();
				// Ext.Msg.alert("Error de comunicación: La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
			// }
		// });
		if (content) {
			var win = Ext.create('Panax.modalWindow',{title: 'Agregar nuevo registro', opener: combo});
			var container=win;
			container.add(content);
			win.show();	
			win.animateTarget=combo; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
		} /*else {
			Ext.Msg.alert("Error", "No se pudo abrir")
		}*/
	}
}

Ext.define("Panax.data.TreeStore", {
	extend: "Ext.data.TreeStore",
	initComponent: function(config){
		config=Panax.util.updateWidth(this, config);
		Ext.apply(this, config);
		this.callParent([config]);
	}
	, proxy: {type: 'memory'}
	,defaultRootProperty: 'data'
	,folderSort: true
	, root: {"text":".",leaf:true}
})
        

Ext.define("Panax.TreePanel", {
    extend: 'Ext.tree.Panel',
	alias: 'widget.customtreepanel',
	initComponent: function(config){
		config=Panax.util.updateWidth(this, config);
		Ext.apply(this, config);
		this.callParent([config]);
	}
	,store: Ext.create('Ext.data.TreeStore', {
		folderSort: true
		,defaultRootProperty: 'data'
		,root: {expanded:true}
	})
	
	,listeners: {
		checkchange: function( node, checked, eOpts) {
			var me=this,
				grid=this;
			if (grid.maxSelections) {
				if (checked==true) {
					Ext.Array.each((grid.getChecked() || []), function(record) {
						record.set('checked', false);
					})
					node.set('checked', checked);
				}
			}

			if (grid.maxSelections && grid.getChecked().length>grid.maxSelections) {
				alert("Sólo se pueden seleccionar "+grid.maxSelections+" opciones");
				// checked=false;
			}

		if (me.oncheckchange_event) me.oncheckchange_event(grid, node, checked, eOpts);
		}
	}
	
	,setValue: function(value){
		var me = this;
		var record; 
		if (value && value.id) record = me.getStore().getNodeById(value.id)
		if (record) record.set('checked', true);
	}
	,getValue: function(){
		var grid = this;
		var values=[]
		Ext.Array.each((grid.getChecked() || []), function(record) {
			values.push({id: record.data.id, text:record.data.text})
		})
		return values;
	}
			
	
	,plugins: [Ext.create('Ext.grid.plugin.CellEditing', {
		clicksToEdit:1,
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if (e.record.raw && e.record.raw.readOnly) {
					return false;
				}
				var edit = this.onBeforeEdit && this.onBeforeEdit(editor, e, eOpts)
				if (edit==false) return false;
			}
		}
	})]	
});

Ext.define("Panax.ajaxDropdownContextMenu", {
    extend: 'Ext.menu.Menu'
	,alias:'widget.ajaxdropdowncontextmenu'
	,insertEnabled: false
	,editEnabled: false
	,deleteEnabled: false
	,refreshEnabled: false
    ,initComponent: function(config){
		this.callParent([config]);
	}
	, caller:undefined
	, listeners: {
		click: function(menu,item, e, eOpts){
			var combo = this.caller
			switch(item.itemId){
				case 'Actualizar':
					combo.refreshRecords();
				break;
				case 'Editar':
					combo.editRecord();
					break;
				case 'Nuevo':
					combo.newRecord();
					break;
				case 'Eliminar':
					combo.deleteRecord();
				break;
				default: 
			}
		}
		, beforeshow: function(menu, eOpts) {
			this.removeAll()
			var combo = this.caller;
			if (this.insertEnabled) this.add({itemId: 'Nuevo', text:'Nuevo'})
			if (this.editEnabled && combo.getValue() && combo.getValue().id) this.add({itemId: 'Editar', text:'Editar'})
			if (this.deleteEnabled && combo.getValue() && combo.getValue().id) this.add({itemId: 'Eliminar', text:'Eliminar'})
			if (this.refreshEnabled || this.insertEnabled || this.editEnabled || this.deleteEnabled) this.add({itemId: 'Actualizar', text:'Actualizar'})
		}
	}
});

Ext.define("Panax.AjaxDropDown", {
    extend: 'Ext.form.field.ComboBox',
	model: 'Panax.model.combobox',
	alias:'widget.ajaxdropdown',
	valueField: 'id',
	displayField: 'text',
    initComponent: function(config){
		config=Panax.util.updateWidth(this, config);
		Ext.apply(this, config);
		this.callParent([config]);
	}
	,cls: 'ajaxdropdown'
	, afterRender: function(){
		var me = this;
		this.configButton = this.getEl().down('.configbutton');
		if(this.configButton){
			this.configButton.on("contextmenu", function(e, t, eOps){ 
				if(!this.menuContext){
					this.menuContext = Ext.create('Panax.ajaxDropdownContextMenu',{caller:me, insertEnabled: me.insertEnabled, editEnabled: me.editEnabled, deleteEnabled: me.deleteEnabled, refreshEnabled: me.refreshEnabled});
				}
				this.menuContext.showAt({x: e.browserEvent.x, y: e.browserEvent.y});
			}, null, {preventDefault: true}); 
			
			this.configButton.on("click", function(e, t, eOps){ 
				if(!this.menuContext){
					this.menuContext = Ext.create('Panax.ajaxDropdownContextMenu',{caller:me, insertEnabled: me.insertEnabled, editEnabled: me.editEnabled, deleteEnabled: me.deleteEnabled, refreshEnabled: me.refreshEnabled});
				}
				this.menuContext.showAt({x: e.browserEvent.x, y: e.browserEvent.y});
			}, null, {preventDefault: true}); 
		}
	}
	,afterSubTpl:'<div class="buttonsPanel"><span class="configbutton" style="margin-right:5px;"><a href="#" tabIndex="-1">&nbsp;</a></span></div>'
	//<span class="deletebutton" style="margin-right:5px;" onclick="alert(1);"><a href="#">&nbsp;</a></span><span class="addbutton" style="margin-right:5px;" onclick="alert(1);"><a href="#">&nbsp;</a></span><span class="editbutton" style="margin-right:5px;" onclick="alert(1);"><a href="#">&nbsp;</a></span><span class="refreshbutton" style="margin-right:5px;" onclick="alert(1);"><a href="#">&nbsp;</a></span>
	, fieldSubTpl: [
        '<div class="{hiddenDataCls}" role="presentation"></div>',
        '<input id="{id}" type="{type}" {inputAttrTpl} class="{fieldCls} {typeCls} {editableCls}" autocomplete="off"',
            '<tpl if="value"> value="{[Ext.util.Format.htmlEncode(values.value)]}"</tpl>',
            '<tpl if="name"> name="{name}"</tpl>',
            '<tpl if="placeholder"> placeholder="{placeholder}"</tpl>',
            '<tpl if="size"> size="{size}"</tpl>',
            '<tpl if="maxLength !== undefined"> maxlength="{maxLength}"</tpl>',
            '<tpl if="readOnly"> readonly="readonly"</tpl>',
            '<tpl if="disabled"> disabled="disabled"</tpl>',
            '<tpl if="tabIdx"> tabIndex="{tabIdx}"</tpl>',
            '<tpl if="fieldStyle"> style="{fieldStyle}"</tpl>',
            '/>',
        {
            compiled: true,
            disableFormats: true
        }
    ]
	,newRecord: function() {
		var combo = this;
		var instance=combo.settings
		instance["mode"]='insert'
		var content = Panax.getInstance(instance);
		if (content) {
			var win = Ext.create('Panax.modalWindow',{title: 'Agregar nuevo registro', opener: combo});
			var container=win;
			container.add(content);
			win.show();	
			win.animateTarget=combo; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
			win.on({
				close: function(){
					combo.refreshRecords();
				}
			});
		}
	}
	
	,editRecord: function() {
		var combo = this;
		var value = combo.getValue()
		if (value && value.id) {
			var instance=combo.settings
			instance["mode"]='edit'
			var content = Panax.getInstance(instance, {filters: "["+combo.settings.primaryKey+"]='"+value.id+"'"});
			if (content) {
				var win = Ext.create('Panax.modalWindow',{title: 'Agregar nuevo registro', opener: combo});
				var container=win;
				container.add(content);
				win.show();	
				win.animateTarget=combo; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
				win.on({
					close: function(){
						combo.refreshRecords();
					}
				});
			}
		}
	}

	
	,deleteRecord: function() {
		var combo = this;
		var value = combo.getValue()
		if (value && value.id) {
			var updateXML='<dataTable name="'+combo.settings.catalogName+'" primaryKey="'+combo.settings.primaryKey+'"><deleteRow primaryValue="'+value.id+'" sourceObjectId="'+combo.itemId+'"/></dataTable>'
			
			Ext.Ajax.request({
				url: '../Scripts/update.asp'
				, method: 'POST'
				, async: false
				, xmlData: updateXML
				, success: function(xhr) {
					var response=Ext.JSON.decode(xhr.responseText); 
					// parameters["success"] = (response.success/* && confirm("Se reconstruyó el módulo, continuar?")*/);
						if (response.callback) {
							response.callback();
						}					
						else {
							if (response.message) {
								Ext.MessageBox.show({
									title: 'MENSAJE DEL SISTEMA',
									msg: response.message,
									icon: response.success?Ext.MessageBox.INFO:Ext.MessageBox.ERROR,
									buttons: Ext.Msg.OK
								});
							}
						}
						combo.refreshRecords();
					// parameters = Ext.apply(parameters, response.catalog)
				}
				, failure: function() {
					Ext.Msg.alert("Error de comunicación", "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.");
					parameters["success"] = false;
				}
			});
			
		}
	}

	,refreshRecords: function() {
		var combo = this;
		combo.store.load({params: {
			catalogName: combo.settings.catalogName,
			lang: combo.settings.lang,
			filters: function(){
				var parentTable = combo.settings.foreignElement!=''?Ext.ComponentQuery.query('#'+combo.settings.foreignElement)[0]:undefined;
				if (!parentTable) return;
				var parentValue = parentTable.getValue();
				parentValue = Ext.isObject(parentValue)?parentValue["id"]:parentValue;
				return (combo.settings.foreignKey=='' || combo.settings.foreignTable=='')?"":
				(' AND ['+combo.settings.foreignKey+']='+(parentValue && parentValue!='NULL'?"'"+parentValue+"'":'NULL' || 'NULL')+' AND ('+(combo.settings.filters || '1=1').replace(/^\s*AND\s*/gi, "")+' OR '+combo.settings.dataValue+'='+("'"+combo.getValue()+"'" || 'NULL')+') ')
			}(),
			dataValue: combo.settings.dataValue,
			dataText: combo.settings.dataText,
			OptNew: String(combo.insertEnabled)
		}});
	}
	,listeners: {
		focus: function() { var element = this; 
			if (this.store.data.length>0) return false;
			this.store.load({params: {
			catalogName: this.settings.catalogName,
			lang: this.settings.lang,
			filters: (this.settings.filters || '')+(function(){
				var parentTable = element.settings.foreignElement!=''?Ext.ComponentQuery.query('#'+element.settings.foreignElement)[0]:undefined;
				if (!parentTable) return;
				var parentValue = parentTable.getValue();
				parentValue = Ext.isObject(parentValue)?parentValue["id"]:parentValue;
				return (element.settings.foreignKey=='' || element.settings.foreignTable=='')?"":
				(' AND ['+element.settings.foreignKey+']='+(parentValue && parentValue!='NULL'?"'"+parentValue+"'":'NULL' || 'NULL')+' AND ('+(element.settings.filters || '1=1').replace(/^\s*AND\s*/gi, "")+' OR '+element.settings.dataValue+'='+("'"+element.getValue()+"'" || 'NULL')+') ')
			}() || ''),
			dataValue: this.settings.dataValue,
			dataText: this.settings.dataText,
			sortDirection: this.settings.sortDirection,
			OptNew: String(this.insertEnabled)
			}})
		}
	/*beforeQuery: function(query) { 
            parentId = Ext.getCmp(element.settings.foreignElement).value;
            this.store.clearFilter();
            this.store.filter( { property: element.settings.foreignKey, value: parentId, exactMatch: true } );
        }*/
		, change:  function(control, records, eOptions) {
			if (control.loading) return;
			var element = this;
			var parentTable = element.settings.foreignElement!=''?Ext.ComponentQuery.query('#'+element.settings.foreignElement)[0]:undefined;
			if (parentTable && control.value && control.value["fk"] && (!(parentTable.value) || parentTable.value["id"]!=control.value["fk"].id)) {
				control.loading=true;
				parentTable.setValue(control.value["fk"]);
				}
			control.forceSelection = (control.enforceConstraint!==undefined?control.enforceConstraint:true);
			var selectHandler = this.onSelect
			if (selectHandler && selectHandler(control, records, eOptions)==false) {
				return true;
			} else if (control.value && control.value["id"]==Panax.REFRESH) {
				this.store.load({params: {
					catalogName: this.settings.catalogName,
					lang: this.settings.lang,
					filters: function(){
						var parentTable = element.settings.foreignElement!=''?Ext.ComponentQuery.query('#'+element.settings.foreignElement)[0]:undefined;
						if (!parentTable) return;
						var parentValue = parentTable.getValue();
						parentValue = Ext.isObject(parentValue)?parentValue["id"]:parentValue;
						return (element.settings.foreignKey=='' || element.settings.foreignTable=='')?"":
						(' AND ['+element.settings.foreignKey+']='+(parentValue && parentValue!='NULL'?"'"+parentValue+"'":'NULL' || 'NULL')+' AND ('+(element.settings.filters || '1=1').replace(/^\s*AND\s*/gi, "")+' OR '+element.settings.dataValue+'='+("'"+element.getValue()+"'" || 'NULL')+') ')
					}(),
					dataValue: this.settings.dataValue,
					dataText: this.settings.dataText,
					OptNew: String(this.insertEnabled)
					}});
				control.select(control.getStore().data.items[0]);
			} else if (control.value) {
				comboManager(control, records, eOptions);
			}
			
			var dependants = this.settings.dependants;
			if (dependants) {
				for (var i=0; i<dependants.length; ++i) {
					if (dependants[i]) {
						var dependant=dependants[i]!=''?Ext.ComponentQuery.query('#'+dependants[i])[0]:undefined;
						if (dependant && (control.value==null || !(dependant.loading) && (dependant.value && dependant.value.fk["id"])!=(control.value["id"] || control.value))) {
							var record = control.value
							dependant.store.removeAll(); dependant.clearValue(); 
							if (record && record.children) {
								dependant.store.loadData(record.children)
							}
						}
					}
				}
			control.loading=undefined;
			}
		}
	}
});
	

Ext.define('Panax.grid.ForeignTable', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.foreigntable',

    requires: [
        'Ext.grid.plugin.CellEditing',
        'Ext.form.field.Text',
        'Ext.toolbar.TextItem'
    ]

    , readOnly: false
	, initComponent: function(){
		var me = this
        me.editing = Ext.create('Ext.grid.plugin.CellEditing', {
			clicksToEdit:1,
			listeners: {
				beforeedit: function(editor, e, eOpts) {
					if (e.record.raw && e.record.raw.readOnly) {
						return false;
					}
					var edit = me.onBeforeEdit(editor, e, eOpts)
					if (edit==false) return false;
				}
			}
		});

        Ext.apply(me, {
            iconCls: 'icon-grid',
            frame: true,
            plugins: [me.editing]
        });
        me.callParent();
        me.getSelectionModel().on('selectionchange', me.onSelectChange, me);
    }
	
	, setReadOnly: function(bReadonly) {
		var me = this;
		Ext.apply(me, {readOnly: bReadonly});
		me.down('#addButton').setDisabled(bReadonly);
		if (bReadonly) {
			me.down('#addButton').hide(bReadonly);
			me.down('#deleteButton').hide(bReadonly);
		} else {
			me.down('#addButton').show(!bReadonly);
			me.down('#deleteButton').show(!bReadonly);
		}
		//Ext.Array.each(me.items.items, function(obj, index, thisArray) {
		//	obj.setReadOnly(bReadonly);
		//});
	}
    
    , onSelectChange: function(selModel, selections){
		if (!this.readOnly) {
			if (this.down('#delete')) this.down('#delete').setDisabled(selections.length === 0);
		}
    }

    , onSync: function(){
        this.store.sync();
    }

    , onDeleteClick: function(){
		if (!this.readOnly) {
			var selection = this.getView().getSelectionModel().getSelection()[0];
			if (selection) {
				this.store.remove(selection);
			}
		}
    }

    , onAddClick: function(){
		Ext.MessageBox.show({
			title: 'ERROR!',
			msg: "No implementado",
			icon: Ext.MessageBox.ERROR,
			buttons: Ext.Msg.OK
		});
    }
	
	, onBeforeEdit: function(editor, e, eOpts) {
	}
	
	, listeners: {
		reconfigure: function(grid, store, columns, oldStore, The, eOpts) {
			var me = this;
			var metaData = store.proxy.reader.metaData
			if (metaData && metaData["readOnly"]!==undefined) {
				me.setReadOnly(Boolean(metaData["readOnly"]))
			}
		}
	}
});

Ext.define('Panax.Form', {
    extend: 'Ext.form.Panel'
    , alias: 'widget.panaxform'
    , requires: ['Ext.form.field.Text']
	, resizable: true
	, autoscroll: true
	, initComponent: function(){
		var me = this;
        this.addEvents('create');
		
		this.on({
                create: function(form, data){
                    this.store.insert(0, data);
                }
            });
		
		Ext.apply(this, {
			activeRecord: null
			, width: 600
			, autoScroll: true
            , dockedItems: [{
                xtype: 'toolbar'
				, itemId: 'mainToolbar'
                , dock: 'top'
                , ui: 'header'
				, ignoreParentFrame: true
				, ignoreBorderManagement: true
                , items: []
				}]
			});
			
		if (this.store) {
			if (!this.store.settings) this.store.settings = {}
			this.store.settings.view = me;
		}
        this.callParent();
		if (this.store && this.mode!='readonly') {
			this.down('#mainToolbar').add({
				iconCls: (this.mode=='fieldselector' || this.mode=='filters')?'':'icon-save'
				, itemId: 'save'
				, text: (this.mode=='fieldselector' || this.mode=='filters')?'Continuar':'Guardar'
				, handler: this.mode=='insert'?this.saveAndNew:this.save
				//, formBind: true
				//, disabled: true
				, scope: this
			});

			this.down('#mainToolbar').add({
				xtype: 'component',
				itemId: 'formErrorState',
				baseCls: 'form-error-state',
				flex: 0,
				validText: 'El formulario es válido',
				invalidText: 'El formulario contiene errores',
				tipTpl: Ext.create('Ext.XTemplate', '<ul class="' + Ext.plainListCls + '"><tpl for="."><li><span class="field-name link">{name}</span>: <span class="error">{error}</span></li></tpl></ul>'),

				getTip: function() {
					var tip = this.tip;
					if (!tip) {
						tip = this.tip = Ext.widget('tooltip', {
							target: this.el,
							title: 'Detalle de Errores:',
							autoHide: false,
							anchor: 'top',
							mouseOffset: [-11, -2],
							closable: true,
							constrainPosition: false,
							cls: 'errors-tip'
						});
						//tip.show();
					}
					return tip;
				}
				
				, setErrors: function(errors) {
					var form = me
					var baseCls = this.baseCls,
						tip = this.getTip();
					//tip.hide(); //si se está mostrando ocultarlo, esto se hace porque para las ventanas flotantes este tipo de objetos pueden quedar atrás y no mostrarse
					if (!this.tipTpl) return;
					errors = Ext.Array.from(errors);

					// Update CSS class and tooltip content
					if (errors.length) {
						this.addCls(baseCls + '-invalid');
						this.removeCls(baseCls + '-valid');
						this.update(this.invalidText);
						tip.setDisabled(false);
						tip.update(this.tipTpl.apply(errors));
						tip.show();
					} else {
						this.addCls(baseCls + '-valid');
						this.removeCls(baseCls + '-invalid');
						this.update(this.validText);
						tip.setDisabled(true);
						tip.hide();
					}
				}
			});
		}
			
		if (this.mode=='insert') {
			this.down('#mainToolbar').add({
				text: 'Limpiar'
				, itemId: 'resetButton'
				, handler: function() {
					var form = this.up('form').getForm();
					Ext.MessageBox.confirm('BORRAR FORMULARIO', 'Confirma que desea borrar el formulario?', function(result){
						if (result=="yes") me.onReset(); //form.reset();
					});
				}
			});
		}
		if (this.toolBarItems) this.down('#mainToolbar').add(this.toolBarItems);
    }
	
	/* , listeners: {
		fieldvaliditychange: function() {
			this.updateErrorState();
		},
		fielderrorchange: function() {
			this.updateErrorState();
		}
	} */

	, updateErrorState: function() {
		var me = this,
			errorCmp, fields, errors;

		if (me.hasBeenDirty || me.getForm().isDirty()) { //prevents showing global error when form first loads
			errorCmp = me.down('#formErrorState');
			fields = me.getForm().getFields();
			errors = [];
			fields.items[1].isValid();
			fields.each(function(field) {
				Ext.Array.forEach(field.getErrors(), function(error) {
					if(!field.hideErrorText){
						errors.push({name: field.getFieldLabel(), error: error});
					}
				});
			});
			errorCmp.setErrors(errors);
			me.hasBeenDirty = true;
		}
	}
	
    , setActiveRecord: function(record){
        this.activeRecord = record;
        if (record) {
            this.down('#save').enable();
            this.getForm().loadRecord(record);
        } else {
            this.down('#save').disable();
            this.getForm().reset();
        }
    }

    , save: function(){
			/* var active = this.activeRecord,
            form = this.getForm(); */

/*-         if (!active) {
//            return;
        }
        if (form.isValid()) {
            form.updateRecord(active);
            this.onReset();
        } */
		var form = this.getForm(); // get the basic form
		/* var saveMask = new Ext.LoadMask(this, {msg:"Guardando..."});
		saveMask.show(); */
			record = form.getRecord();
		
		var store = record.store
		
		if (store.settings.mode=='fieldselector' || store.settings.mode=='filters') {
			store.getProxy().api.create='../Scripts/'+store.settings.mode+'.asp'
			store.getProxy().api.update='../Scripts/'+store.settings.mode+'.asp'
		}
		if (form.isValid()) {
			record.store.onSuccess = (store.settings.mode=='fieldselector')?record.store.OnFieldsSelected:(store.settings.mode=='filters'?record.store.OnFilters:record.store.OnSave)
			form.updateRecord(record);
			
			/* var me = this;
			record.save({
				success: function(record, args) {
					Ext.Msg.alert('Éxito', 'Datos guardados con éxito');
					var modalWindow = me.up('#modalWindow')
					if (modalWindow) modalWindow.close();
					saveMask.hide();
				},
				failure: function(record, args) {
					Ext.Msg.alert('Falló', args.error);
					saveMask.hide();
				}
			}); */
		}
		this.updateErrorState();
    }

    , saveAndNew: function(){
		var form = this.getForm(); // get the basic form
		if (form.isValid()) {
			record = form.getRecord();
			record.store.onSuccess = this.onSucessSave
			form.updateRecord(record);
		}
		this.updateErrorState();
    }
	
	, onSucessSave: function(store, operation, eOpts, scope){
		var view = scope.settings.view;
		var modalWindow = view.up('#modalWindow')
		if(modalWindow)
		{
			Ext.MessageBox.confirm('Nuevo registro', 'Desea generar un nuevo registro?', function(result){
				if (result=="yes") store.load(null);
				else {
					if (modalWindow) {
						var opener = modalWindow.opener
						modalWindow.close();
						if (opener) {
							if (opener.refresh) opener.refresh()
							else if (opener.store) opener.store.reload()
						}
					}
				}
			})
		}
		else
		{
			store.load(null);
		}
	}

    , onCreate: function(){
        var form = this.getForm();

        if (form.isValid()) {
            this.fireEvent('create', this, form.getValues());
            this.onReset();
        }

    }

    , onReset: function(){
        var form = this.getForm();
		var record = form.getRecord();
		record.store.load(null);
    }
});

Ext.define('Panax.ajaxDropDown', {
	extend: 'Ext.data.Store', 
	/*requires: ['Panax.model.combobox'],*/
	model: "Panax.model.combobox",
	/* ,
	proxy: {
		type: 'ajax',
		url: '../scripts/xmlCatalogOptions.asp',
		reader: {
			type: 'json',
			root: 'data',
			successProperty: 'success',
			messageProperty: 'message',
			totalProperty: 'total'
			//,idProperty: this.settings.
		},
		pageParam: 'pageIndex',
		limitParam: 'pageSize',
		sortParam: 'sorters',
		extraParams: { output: 'json' },
		listeners: {
			exception: function(proxy, response, operation){
				//alert(response.responseText)
				Ext.MessageBox.show({
					title: 'ERROR!',
					msg: operation.getError(),
					icon: Ext.MessageBox.ERROR,
					buttons: Ext.Msg.OK
				});
			}
		},

	}, */
	constructor: function (configuration) {
         //Ext.apply(this.proxy, config);
         this.callParent(arguments);
     }
});

var currentName;
	
var updateWorkarea = function(configuration, name) {
	var workarea = Ext.getCmp('app-workarea');
	//if (name && name != currentName) {
		currentName = name;
		workarea.remove(0);
		workarea.add(Ext.apply(configuration));
	//}
};

// function getClass(catalogName, mode) {
	// try {
		// var catalog = Ext.create('Px.'+catalogName+'.'+(mode || 'readonly'), {})
	// } catch(e) {
		
	// }
// }

function URLEncode(url) 
{
var SAFECHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_.!~*'()?&=";
var HEX = "0123456789ABCDEF";
var encoded = "";
for (var i=0; i<url.length; i++) 
	{
	var ch = url.charAt(i);
	if (ch == " ") 
		{
		encoded += "%20";
		}
	else if (ch=="&")
		{
		encoded += "%26"
		}
	else 
		{
		if (SAFECHARS.indexOf(ch) != -1) 
			{
			encoded += ch;
			}
		else
			{
			var charCode = ch.charCodeAt(0);
			if (charCode > 255) 
				{
				encoded += "+";
				} 
			else 
				{
				encoded += "%";
				encoded += HEX.charAt((charCode >> 4) & 0xF);
				encoded += HEX.charAt(charCode & 0xF);
				}
			}
		}
	}
return encoded;
}

function URLDecode(str)
{ 
return decodeURIComponent((str+'').replace(/\+/g, '%20'));
}
Ext.QuickTips.init();


Ext.define('Panax.custom.AjaxProxy', { 
    extend: 'Ext.data.proxy.Ajax', 
    alias: 'widget.customproxy'
	, root: 'data'
	, settings: {
		catalogName: undefined
		, lang: undefined
		, filters: undefined
		, identityKey: undefined
		, primaryKey: undefined
		, mode: undefined
		, view: undefined
		, identity: undefined
	}
    , api: {
		read: "../templates/request.asp"
		, create: "../Scripts/update.asp"
		, update: "../Scripts/update.asp"
		, destroy: "../Scripts/update.asp"
	}
	, writer: {
		type: 'xml'
		, writeAllFields: false
	}
	, pageParam: 'pageIndex'
	, limitParam: 'pageSize'
	, sortParam: 'sorters'
	, constructor: function(configuration) {
        var me = this; 
		me.callParent(arguments);
		Ext.apply(me, {
			extraParams: {
				catalogName: me.settings.catalogName
				, lang: me.settings.lang
				, filters: me.settings.filters
				, identityKey: me.settings.identityKey
				, primaryKey: me.settings.primaryKey
				, mode: me.settings.mode
				, output: 'json'
			}, reader: {
				type: 'json'
				, root: 'data'
				, successProperty: 'success'
				, messageProperty: 'message'
				, totalProperty: 'total'
				
				// , createAccessor: (function() {
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
								// return Ext.functionFactory('obj', 'return (obj.'+fieldName+'!==undefined?obj.'+fieldName+':undefined||{})'+String(expr).replace(re, '$2')+'');
							// }
						// }
						// return function(obj) {
							// return obj[expr];
						// };
					// };
				// }())
				, createFieldAccessExpression: (function() {
					var re = /([^\[\.]+)([\[\.].+)?/;

					return function(field, fieldVarName, dataName) {
						var me     = this,
							hasMap = (field.mapping !== null && field.mapping!=field.name),
							map    = hasMap ? field.mapping : field.name,
							result,
							operatorSearch;

						if (typeof map === 'function') {
							result = fieldVarName + '.mapping(' + dataName + ', this)';
						} else if (this.useSimpleAccessors === true || ((operatorSearch = String(map).search(re)) < 0) || !hasMap || field.mapping==field.name) {
							if (!hasMap || isNaN(map)) {
								// If we don't provide a mapping, we may have a field name that is numeric
								map = '"' + map + '"';
							}
							result = dataName + "[" + map + "]";
						} else {
							result = '('+dataName+'["'+String((field.mapping || field.name)).replace(re, '$1')+'"]||{})'+String(field.mapping).replace(re, '$2')
						}
						return result;
					};
				}())
			}
		});
	}
	, listeners: {
		write: function(proxy, operation){
			if (operation.action == 'destroy') {
				main.child('#form').setActiveRecord(null);
			}
			// Ext.example.msg(operation.action, operation.resultSet.message);
		}
		, failure: function(proxy, response, operation){
			var message = operation.getError();
			message = Ext.isObject(message)?message["statusText"]:message;
			Ext.MessageBox.show({
				title: 'RESPUESTA DEL SERVIDOR',
				msg: message,
				icon: Ext.MessageBox.ERROR,
				buttons: Ext.Msg.OK
			});
		}
		, exception: function(proxy, xhr, operation){
			var response=Ext.JSON.decode(xhr.responseText);
			var message = operation.getError();
			message = Ext.isObject(message)?message["statusText"]:message;
			Ext.MessageBox.show({
				title: 'RESPUESTA DEL SERVIDOR',
				msg: message,
				icon: Ext.MessageBox.ERROR,
				buttons: Ext.Msg.OK
				,fn: function(buttonId, text, opt) {
					if (response && response.callback) response.callback()
				}
			});
			if (this.onError) this.onError(proxy, xhr, operation)
		}
	}
});

Ext.define('Panax.custom.AjaxStore', { 
    extend: 'Ext.data.Store', 
    alias: 'widget.ajaxstore'

	, autoLoad: true
	, autoSync: true
	, autoDestroy: true
	, remoteSort: true
	, settings: {
		catalogName: undefined
		, lang: undefined
		, filters: undefined
		, identityKey: undefined
		, primaryKey: undefined
		, mode: undefined
		, view: undefined
		, identity: undefined
	}
	//, model: "dbo.Prospecto"
	//, root: 'Prospecto'
	/*{ 
		type: 'ajax'
		, root: 'data'
		, settings: {
			catalogName: undefined
			, lang: undefined
			, filters: undefined
			, identityKey: undefined
			, primaryKey: undefined
			, mode: undefined
			, view: undefined
			, identity: undefined
		}
		, api: {
			read: "../templates/request.asp"
			, create: "../Scripts/update.asp"
			, update: "../Scripts/update.asp"
			, destroy: "../Scripts/update.asp"
		}
		, reader: {
			type: 'json'
			, root: 'data'
			, successProperty: 'success'
			, messageProperty: 'message'
			, totalProperty: 'total'
		}
		, writer: {
			type: 'xml'
			, writeAllFields: false
			, root: 'data'
		}
		, pageParam: 'pageIndex'
		, limitParam: 'pageSize'
		, sortParam: 'sorters'
	}*/
	, constructor: function(configuration) { 
        var me = this; 
		me.proxy = Ext.create('Panax.custom.AjaxProxy', {/*settings: configuration["settings"]*/});
		Ext.apply(me, configuration)
		 Ext.apply(me.proxy, { 
			extraParams: {
				catalogName: configuration["settings"].catalogName
				, lang: configuration["settings"].lang
				, filters: configuration["settings"].filters
				, identityKey: configuration["settings"].identityKey
				, primaryKey: configuration["settings"].primaryKey
				, mode: configuration["settings"].mode
				, output: 'json'
			}
			, writer: {
				type: 'xml' 
				, writeAllFields: configuration["settings"].mode=='fieldselector'
			}
		}); 
		
		Ext.apply(me.customevents, {});
	
		this.callParent(arguments);//me.callParent(configuration);
	}
	, listeners: {
		beforeload: function(store, operation, eOpts){
			var view = this.settings.view;
			if (view && !view.waitingMessage) {
				view.waitingMessage = new Ext.LoadMask(view, {msg:"Cargando..."});
				view.waitingMessage.show();
			}
			if (this.settings.maskTarget) this.settings.maskTarget.mask()
			store.getProxy().onError = function() {
				if (this.settings.maskTarget) this.settings.maskTarget.unmask()
				if (view && view.waitingMessage) { 
					view.waitingMessage.hide(); view.waitingMessage = undefined;
				}
			}
		} 
		, beforesync: function(options, eOpts){
			var view = this.settings.view;
			if (view && !view.waitingMessage) {
				view.waitingMessage = new Ext.LoadMask(view, {msg:"Guardando..."});
				view.waitingMessage.show();
			}
			if (this.settings.maskTarget) this.settings.maskTarget.mask()
		} 
		, remove: function(store, record, index, eOpts){
			var view = this.settings.view;
			if (view && !view.waitingMessage) {
				view.waitingMessage = new Ext.LoadMask(view, {msg:"Eliminando..."});
				view.waitingMessage.show();
			}
			if (this.settings.maskTarget) this.settings.maskTarget.mask()
		}
		, load: function(store, records, index, eOpts){
			var view = this.settings.view;
			if (view && records) view.loadRecord(records[0])
			if (this.settings.maskTarget) this.settings.maskTarget.unmask()
			if (view && view.waitingMessage) { 
				view.waitingMessage.hide(); view.waitingMessage = undefined;
			}
		}
		, write: function(store, operation, eOpts){
			var view = this.settings.view;
			var response=Ext.JSON.decode(operation.response.responseText);
			Ext.Array.each(response.results, function(obj, index, thisArray) {
				var objStore = obj.storeId?Ext.getStore(obj.storeId):null;
				var record, recordIndex = (objStore && obj.internalId)?objStore.findBy(function(current_record){
					return current_record.internalId==obj.internalId
				}):null;
				if (parseInt(recordIndex)>=0) { 
					record = objStore.data.get(recordIndex)
					record.setId(obj["identityValue"]);
				}
			});
			if (this.settings.maskTarget) this.settings.maskTarget.unmask()
			if (view && view.waitingMessage) { 
				view.waitingMessage.hide(); view.waitingMessage = undefined;
			}
			if (store.onSuccess) store.onSuccess(store, operation, eOpts, this)
		}
		, refresh: function(){
			var view = this.settings.view;
			if (this.settings.maskTarget) this.settings.maskTarget.unmask()
			if (view && view.waitingMessage) { 
				view.waitingMessage.hide(); view.waitingMessage = undefined;
			}
		}
	}
	, OnSave: function(store, operation, eOpts, scope){
		if (this.customevents.onbeforesave) this.customevents.onbeforesave(store, operation, eOpts, scope);
		var dontStop = true
			, view = scope.settings.view
			, modalWindow = view.up('#modalWindow');
		if (modalWindow) {
			var opener = modalWindow.opener
			if (this.customevents.onaftersave) {
				dontStop = this.customevents.onaftersave(store, operation, eOpts, scope);
			} 
			if (dontStop || dontStop==undefined) { modalWindow.close(); }
			if (opener) {
				if (opener.refresh) opener.refresh()
				else if (opener.store) opener.store.reload()
			}
		} else {
			if (this.customevents.onaftersave) {
				dontStop = this.customevents.onaftersave(store, operation, eOpts, scope);
			} 
			if (dontStop || dontStop==undefined) { Ext.Msg.alert('Éxito', 'Datos guardados con éxito'); }
		}
	}
	, OnFieldsSelected: function(store, operation, eOpts, scope){
		var response = operation.response
		var response=Ext.JSON.decode(operation.response.responseText); 
		if (this.customevents.onbeforefielsdsselected) this.customevents.onbeforefielsdsselected(store, operation, eOpts, scope);
		var dontStop = true
			, view = scope.settings.view
			, modalWindow = view.up('#modalWindow');
		if (modalWindow) {
			var opener = modalWindow.opener
			if (this.customevents.onafterfieldsselected) {
				dontStop = this.customevents.onafterfieldsselected(store, operation, eOpts, scope);
			} 
			if (dontStop || dontStop==undefined) { modalWindow.close(); }
			if (opener) {
				if (opener.refresh) opener.refresh()
				else if (opener.store) opener.store.reload()
			}
		} else {
			if (this.customevents.onafterfieldsselected) {
				dontStop = this.customevents.onafterfieldsselected(store, operation, eOpts, scope);
			} else {
				var instance=operation.request.params
				instance["mode"]='readonly'
				instance["controlType"]='formView'
				
				var content = Panax.getInstance(instance,{},response.xmlData);
				if (content) {
					var win = Ext.create('Panax.modalWindow',{title: 'Ventana'/*, opener: combo*/});
					var container=win;
					container.add(content);
					win.show();	
					//win.animateTarget=combo; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
				}
			}
		}
	}
	, OnFilters: function(store, operation, eOpts, scope){
		var response = operation.response
		var response=Ext.JSON.decode(operation.response.responseText); 
		if (this.customevents.onbeforefielsdsselected) this.customevents.onbeforefielsdsselected(store, operation, eOpts, scope);
		var dontStop = true
			, view = scope.settings.view
			, modalWindow = view.up('#modalWindow');
		if (modalWindow) {
			var opener = modalWindow.opener
			if (this.customevents.onafterfieldsselected) {
				dontStop = this.customevents.onafterfieldsselected(store, operation, eOpts, scope);
			} 
			if (dontStop || dontStop==undefined) { modalWindow.close(); }
			if (opener) {
				if (opener.refresh) opener.refresh()
				else if (opener.store) opener.store.reload()
			}
		} else {
			if (this.customevents.onafterfieldsselected) {
				dontStop = this.customevents.onafterfieldsselected(store, operation, eOpts, scope);
			} else {
				var instance=operation.request.params
				instance["mode"]='readonly'
				instance["controlType"]='gridView'
				
				var content = Panax.getInstance(instance,{filters:response.filters});
				if (content) {
					var win = Ext.create('Panax.modalWindow',{title: 'Ventana'/*, opener: combo*/});
					var container=win;
					container.add(content);
					win.show();	
					//win.animateTarget=combo; // La animación tiene que hacerse después de que se abre, de lo contrario la máscara de "cargando" no se muestra correctamente. TODO: Corregir
				}
			}
		}
	}
	, customevents: {}
});

Panax.requestInstance = function(parameters, xmlData) {
	Ext.Ajax.request({
			url: '../Templates/request.asp'
			, method: xmlData?'POST':'GET'
			, async: false
			, xmlData: xmlData
			, params: parameters
			, success: function(xhr) {
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
		});
	return parameters
}

Panax.getInstance = function (model, configuration, xmlData) {
	var configuration = (configuration || {});
	if (model.rebuild==1) {
		model["output"]='json'
		model=Panax.requestInstance(model, xmlData);
	}
	else {
		model=Panax.requestInstance(function(){ 
				var params=model 
				params["getData"]=0
				params["getStructure"]=0
				params["output"]='json'
				return params;
				}(), xmlData);
	}
	if (!model.success/* && Panax.session.loginStatus!='Conected'*/) return false
	try {
		var classObject = Ext.create('Px.'+model.dbId+'.'+model.lang+'.'+model.catalogName+'.'+model.mode+'.'+model.controlType, configuration);
	} catch(e) {
		if ((e.type=="called_non_callable" || e.type===undefined) && (model.rebuild===undefined?0:model.rebuild)!=1) {
			model["rebuild"]=1
			classObject = Panax.getInstance(model, configuration, xmlData);
		} else {
			Ext.MessageBox.show({
				title: 'Error',
				msg: "Este módulo no está disponible en este momento",
				icon: Ext.MessageBox.ERROR,
				buttons: Ext.Msg.OK
			});
		}
	}
	return classObject;
}


// Source: http://stackoverflow.com/questions/497790

util.dates = {
    convert:function(d) {
        // Converts the date in d to a date-object. The input can be:
        //   a date object: returned without modification
        //  an array      : Interpreted as [year,month,day]. NOTE: month is 0-11.
        //   a number     : Interpreted as number of milliseconds
        //                  since 1 Jan 1970 (a timestamp) 
        //   a string     : Any format supported by the javascript engine, like
        //                  "YYYY/MM/DD", "MM/DD/YYYY", "Jan 31 2009" etc.
        //  an object     : Interpreted as an object with year, month and date
        //                  attributes.  **NOTE** month is 0-11.
        return (
			d === null? d :
            d.constructor === Date ? d :
            d.constructor === Array ? new Date(d[0],d[1],d[2]) :
            d.constructor === Number ? new Date(d) :
            d.constructor === String ? new Date(d) :
            typeof d === "object" ? new Date(d.year,d.month,d.date) :
            NaN
        );
    },
    compare:function(a,b) {
        // Compare two dates (could be of any type supported by the convert
        // function above) and returns:
        //  -1 : if a < b
        //   0 : if a = b
        //   1 : if a > b
        // NaN : if a or b is an illegal date
        // NOTE: The code inside isFinite does an assignment (=).
		if (!a && !b) return 0
		if (!(a && b)) return -1
        return (
            isFinite(a=this.convert(a).valueOf()) &&
            isFinite(b=this.convert(b).valueOf()) ?
            (a>b)-(a<b) :
            NaN
        );
    },
    inRange:function(d,start,end) {
        // Checks if date in d is between dates in start and end.
        // Returns a boolean or NaN:
        //    true  : if d is between start and end (inclusive)
        //    false : if d is before start or after end
        //    NaN   : if one or more of the dates is illegal.
        // NOTE: The code inside isFinite does an assignment (=).
		if (!(d && start && end)) return undefined
       return (
            isFinite(d=this.convert(d).valueOf()) &&
            isFinite(start=this.convert(start).valueOf()) &&
            isFinite(end=this.convert(end).valueOf()) ?
            start <= d && d <= end :
            NaN
        );
    }
	, dateAdd: function(timeU,offset,dateObj) {
		var millisecond=1;
		var second=millisecond*1000;
		var minute=second*60;
		var hour=minute*60;
		var day=hour*24;
		var year=day*365;

		dateObj=this.convert(dateObj.valueOf());
		switch(timeU) {
			case "ms": dateObj.setMilliseconds(dateObj.getMilliseconds()+offset); break;
			case "s": dateObj.setSeconds(dateObj.getSeconds()+offset); break;
			case "mi": dateObj.setMinutes(dateObj.getMinutes()+offset); break;
			case "h": dateObj.setHours(dateObj.getHours()+offset); break;
			case "d": dateObj.setDate(dateObj.getDate()+offset); break;
			case "m": dateObj.setMonth(dateObj.getMonth()+offset); break;
			case "y": dateObj.setFullYear(dateObj.getFullYear()+offset); break;
		}
		return dateObj;
	}
}

Panax.util.updateWidth=function(source, config) {
	var config = config || {}
	var width = (config.width || source.width);
	if (width) {
		var newWidth=width + (isNaN(width)?"":((config.hideLabel || source.hideLabel)!==true && (config.labelAlign || source.labelAlign)!='top'?(config.labelWidth || source.labelWidth || 100):0));
		if (newWidth && String(newWidth)!='NaN') config["width"]=newWidth
	}
	return config;
}

Panax.util.replicate = function(sString, iTimes)
{
var sNewString='';
while(iTimes) 
	{
	if(iTimes&1) {sNewString+=sString;}
	sString+=sString;
	iTimes>>=1;
	}
return sNewString;
}

Panax.util.lPad = function(sValue, iLength, sFill)
{
var sNewString=''
var sValue=String(sValue)
var iCurrentLength=sValue.length;
var sFilled=Panax.util.replicate(sFill, iLength-iCurrentLength)
sNewString= sFilled+sValue
return sNewString
}

Panax.util.rPad = function(sValue, iLength, sFill)
{
var sNewString=''
var sValue=String(sValue)
var iCurrentLength=sValue.length;
var sFilled=Panax.util.replicate(sFill, iLength-iCurrentLength)
sNewString= sValue+sFilled
return sNewString
}

Panax.util.isEmptyObject = function(obj) {
    for(var attrib in obj) {
        if(obj.hasOwnProperty(attrib))
            return false;
    }
    return true;
}

Panax.util.clearTime = function(dateValue) {
	dateValue.setHours(0);
	dateValue.setMinutes(0);
	return dateValue;
}

	
/*
 * GNU General Public License Usage
 * This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 *
 * http://www.gnu.org/licenses/lgpl.html
 *
 * @description: This class provide aditional format to numbers by extending Ext.form.field.Number
 *
 * @author: Greivin Britton
 * @email: brittongr@gmail.com
 * @version: 2 compatible with ExtJS 4
 */
Ext.define('Ext.ux.form.CurrencyField', 
{
    extend: 'Ext.form.field.Number',//Extending the NumberField
    alias: 'widget.currencyfield',//Defining the xtype,
    currencySymbol: '$',
    useThousandSeparator: true,
    thousandSeparator: ',',
    alwaysDisplayDecimals: true,
    fieldStyle: 'text-align: right;',
	initComponent: function(){
        if (this.useThousandSeparator && this.decimalSeparator == ',' && this.thousandSeparator == ',') 
            this.thousandSeparator = '.';
        else 
            if (this.allowDecimals && this.thousandSeparator == '.' && this.decimalSeparator == '.') 
                this.decimalSeparator = ',';
        
        this.callParent(arguments);
    },
    setValue: function(value){
        Ext.ux.form.CurrencyField.superclass.setValue.call(this, value != null ? value.toString().replace('.', this.decimalSeparator) : value);
        
        this.setRawValue(this.getFormattedValue(this.getValue()));
    },
    getFormattedValue: function(value){
        if (Ext.isEmpty(value) || !this.hasFormat()) 
            return value;
        else 
        {
            var neg = null;
            
            value = (neg = value < 0) ? value * -1 : value;
            value = this.allowDecimals && this.alwaysDisplayDecimals ? value.toFixed(this.decimalPrecision) : value;
            
            if (this.useThousandSeparator) 
            {
                if (this.useThousandSeparator && Ext.isEmpty(this.thousandSeparator)) 
                    throw ('NumberFormatException: invalid thousandSeparator, property must has a valid character.');
                
                if (this.thousandSeparator == this.decimalSeparator) 
                    throw ('NumberFormatException: invalid thousandSeparator, thousand separator must be different from decimalSeparator.');
                
                value = value.toString();
                
                var ps = value.split('.');
                ps[1] = ps[1] ? ps[1] : null;
                
                var whole = ps[0];
                
                var r = /(\d+)(\d{3})/;
                
                var ts = this.thousandSeparator;
                
                while (r.test(whole)) 
                    whole = whole.replace(r, '$1' + ts + '$2');
                
                value = whole + (ps[1] ? this.decimalSeparator + ps[1] : '');
            }
            
            return Ext.String.format('{0}{1}{2}', (neg ? '-' : ''), (Ext.isEmpty(this.currencySymbol) ? '' : this.currencySymbol + ' '), value);
        }
    },
    /**
     * overrides parseValue to remove the format applied by this class
     */
    parseValue: function(value){
        //Replace the currency symbol and thousand separator
        return Ext.ux.form.CurrencyField.superclass.parseValue.call(this, this.removeFormat(value));
    },
    /**
     * Remove only the format added by this class to let the superclass validate with it's rules.
     * @param {Object} value
     */
    removeFormat: function(value){
        if (Ext.isEmpty(value) || !this.hasFormat()) 
            return value;
        else 
        {
            value = value.toString().replace(this.currencySymbol + ' ', '');
            
            value = this.useThousandSeparator ? value.replace(new RegExp('[' + this.thousandSeparator + ']', 'g'), '') : value;
            
            return value;
        }
    },
    /**
     * Remove the format before validating the the value.
     * @param {Number} value
     */
    getErrors: function(value){
        return Ext.ux.form.CurrencyField.superclass.getErrors.call(this, this.removeFormat(value));
    },
    hasFormat: function(){
        return this.decimalSeparator != '.' || (this.useThousandSeparator == true && this.getRawValue() != null) || !Ext.isEmpty(this.currencySymbol) || this.alwaysDisplayDecimals;
    },
    /**
     * Display the numeric value with the fixed decimal precision and without the format using the setRawValue, don't need to do a setValue because we don't want a double
     * formatting and process of the value because beforeBlur perform a getRawValue and then a setValue.
     */
    onFocus: function(){
        this.setRawValue(this.removeFormat(this.getRawValue()));
        
        this.callParent(arguments);
    }
});
