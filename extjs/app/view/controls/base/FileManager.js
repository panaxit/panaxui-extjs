Ext.define('Panax.view.base.FileManager', {
	extend: 'Ext.form.FieldContainer',
	alias: 'widget.filemanager',

	NO_IMAGE_FILE: 'Images/FileSystem/blank.png',
	IMAGE_ERROR: 'Images/Advise/vbExclamation.gif',
	UPLOAD_URL: '/FilesRepository/',
	CLEAR_URL: '/ClearImage/',

	width: 205,
	layout: {
		type: 'table',
		columns: 4,
		rows: 1
	},
	// src: '../../../../../Images/FileSystem/no_photo.gif',
	name: undefined,
	readOnly: false,
	title: 'Archivo Adjunto',
	showPreview: false,
	showFileName: true,
	src: '',
	parentFolder: '',

	getFileExtension: function(filePath) {
		return "Images/FileSystem/" + filePath.replace(/.+\.(\w+)$/, '$1') + ".png";
	},

	getFileName: function(filePath) {
		return filePath.replace(/.+[\/\\](.+?)$/, '$1');
	},

	setValue: function(value) {
		var me = this;
		var fileName = me.down('[itemId=fileName]');
		fileName.setValue(value);
	},

	getValue: function() {
		var me = this;
		var fileName = me.down('[itemId=fileName]');
		fileName.getValue();
		return value;
	},

	initComponent: function() {
		var me = this;
		var imageHolder = {
			xtype: 'image',
			itemId: 'image',
			height: 100,
			maxWidth: 100,
			maxHeight: 100
		};
		Ext.apply(me, {
			items: [{
				xtype: 'container',
				layout: {
					type: 'vbox',
					flex: 1
				},
				itemId: 'progressBar',
				colspan: 2,
				hidden: true,
				items: [{
					xtype: 'progressbar',
					text: 'Esperando...',
					itemId: 'progressBar_bar',
					cls: 'custom',
					width: '220',
					flex: 0
				}, {
					xtype: 'textfield',
					name: me.name,
					itemId: 'fileName',
					colspan: 2,
					listeners: {
						change: function(el, val) {
							me.fileChange(el, val);
						}
					}
				}]
			}, !(me.title) ? imageHolder : {
				xtype: 'fieldset',
				itemId: 'imageWrapper',
				title: me.title,
				width: 122,
				height: 140,
				bodyPadding: 0,
				padding: 8,
				layout: 'anchor',
				items: [imageHolder]
			}, {
				xtype: 'container',
				layout: {
					type: 'vbox',
					padding: '5',
					pack: 'end',
					align: 'center'
				},
				defaults: {
					xtype: 'button',
					width: 70
				},
				items: [{
					xtype: 'fieldcontainer',
					border: false,
					itemId: 'buttonsContainer',
					items: [{
						xtype: 'filefield',
						name: 'test',
						buttonOnly: true,
						hideLabel: true,
						itemId: 'uploadButton',
						buttonText: 'Explorar...',
						buttonConfig: {
							width: 70
						},
						hidden: true,
						listeners: {
							change: function(el, value) {
								// this.up('window').fireEvent('uploadimage', fb, v); 
								if (value !== '') {
									Ext.MessageBox.confirm('SUBIR ARCHIVO', 'Confirma que desea subir el archivo "' + value + '" al servidor?', function(result) {
										if (result == "yes") me.uploadImage(el, value);
									});
								}
							}
						}
					}]
				}, {
					itemId: 'clearButton',
					text: 'Quitar',
					hidden: true,
					handler: function() {
						me.clearImage();
					}
				}]
			}, {
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
			label = me.down("[itemId=label]");
		label.setValue(me.getFileName(filePath));
	},

	fileChange: function(el, val) {
		var me = this,
			imagePath = val;
		me.showFileLabel(val);
		if (val !== '' && !(me.showPreview)) imagePath = me.getFileExtension(imagePath);
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

		if (val !== '') {
			if (uploadButton && uploadButton.isVisible()) {
				uploadButton.hide();
			}
			if (!me.readOnly && clearButton && !clearButton.isVisible()) {
				clearButton.show();
			}
		} else {
			if (clearButton && clearButton.isVisible()) {
				clearButton.hide();
			}
			if (!me.readOnly && uploadButton && !uploadButton.isVisible()) {
				uploadButton.show();
					// me.down('[itemId=buttonsContainer]').add({ 
					// 		xtype: 'fileuploadfield', 
					// 		buttonOnly: true, 
					// 		hideLabel: true, 
					// 		itemId: 'uploadButton', 
					// 		buttonText: 'Explorar...', 
					// 		buttonConfig: { width: 70 }, 
					// 		hidden: me.readOnly,
					// 		listeners: { 
					// 			change: function(el, value) {
					// 				// this.up('window').fireEvent('uploadimage', fb, v); 
					// 				if (value!='') {
					// 					Ext.MessageBox.confirm('SUBIR ARCHIVO', 'Confirma que desea subir el archivo "'+value+'" al servidor?', function(result){
					// 						if (result=="yes") me.uploadImage(el, value);
					// 					})
					// 				}
					// 			}
					// 		}
					// 	})
					// }
			}
		}
	},

	loadImage: function(val) {
		var me = this,
			fileThumbnail = me.down('[itemId=image]');
		imagePath = val !== '' ? me.UPLOAD_URL + val : me.NO_IMAGE_FILE;

		//img.getEl().on('load', me.success, me, { single: true }); 
		var imageEl = fileThumbnail.getEl();
		if (imageEl) {
			imageEl.on('error', function() {
				//img.getEl().un('load', me.success, me); 
				//(Panax.app.config.rootPath+'/' || '')+me.NO_IMAGE_FILE
				if (val !== '') fileThumbnail.setSrc((Panax.app.config.rootPath + '/' || '') + me.getFileExtension(val));
				//fs.enable(); 
			}, me, {
				single: true
			});
		}

		fileThumbnail.setSrc((Panax.app.config.rootPath + '/' || '') + imagePath);

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
		clonedField.name = "cloned-node";
		clonedField.id = "cloned-node";
		clonedField.isFieldLabelable = false;
		el.isFieldLabelable = false;
		var me = this,
			fm = Ext.create('Ext.form.Panel', {
				items: [clonedField]
			}),
			f = fm.getForm(); //el.up('form').getForm(); 
		clonedField.ownerCt = undefined; //esta línea es para que no marque error, ya que al clonar e insertar en el formulario, quita físicamente el botón y por lo tanto ya no existe el ownerCt.el

		var progressBar = me.down('[itemId=progressBar]');
		progressBar.show();
		//progressBar.show(true);
		var uploadID = Math.round(Math.random() * 1000000000);
		if (f.isValid()) {
			f.errorReader = {
				read: function(response) {
					return Ext.decode(response.responseText, true);
				}
			};
			f.submit({
				//method: 'POST',
				url: (Panax.app.config.scriptsPath + '/' || '') + 'fileUploader.asp?UploadID=' + uploadID + '&parentFolder=' + (Panax.app.config.filesRepositoryPath + '/' || '') + me.parentFolder /*+'saveAs=image.png'*/ ,
				waitMsg: 'Subiendo archivo...',
				success: function(fp, o) {
					var fileName = me.down('[itemId=fileName]');
					fileName.setValue(o.result.files[1].file);
					Ext.Msg.alert('Completo', 'Fue procesado con éxito el archivo "' + (o.result.files ? o.result.files[1].file : '') + '"', function() {
						progressBar.hide(true);
					});
				},
				failure: function(fp, o) {
					var errorMessage;
					if (o.result.files) {
						errorMessage = 'El archivo "' + o.result.files[1].file + '" no pudo ser procesado en el servidor';
					} else {
						errorMessage = 'La carga del archivo no pudo ser completada. Revise los errores en la consola';
					}
					Ext.Msg.alert('Error', errorMessage, function() {
						progressBar.hide(true);
					});
				},
				exception: function(fp, o) {
					console.log('upload failed', fp, o);
					// Ext.TaskManager.stop(task);
				}
			});
		}
		task = {
			run: function() {
				Ext.Ajax.request({
					url: (Panax.app.config.scriptsPath + '/' || '') + 'uploadFileManager.asp?UploadID=' + uploadID,
					method: 'GET',
					success: function(xhr, r) {
						var result = Ext.JSON.decode(xhr.responseText);
						if (task && result.percent >= 100) Ext.TaskManager.stop(task);
						progressBar.down('[itemId=progressBar_bar]').updateProgress(result.percent / 100, Math.round(result.percent) + '% completado...');
					},
					failure: function() {
						//myMask.hide();
						Ext.TaskManager.stop(task);
						// Ext.MessageBox.show({
						// title: 'Error de comunicación',
						// msg: "La conexión con el servidor falló, favor de intentarlo nuevamente en unos segundos.",
						// icon: Ext.MessageBox.ERROR,
						// buttons: Ext.Msg.OK
						// });
					}
				});
			},
			interval: 1500
		};
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
			if (result == "yes") {
				var fileName = me.down('[itemId=fileName]');
				fileName.setValue('');
				/*Ext.Ajax.request({ 
					method: 'GET', 
					url: me.CLEAR_URL + me.imageLocation + '/' + me.imageRecordId, 
					success: function(fp, o) { me.loadImage(me.imageLocation, me.imageRecordId); }, 
					failure: function(fp, o) { console.log('upload failed', fp, o); } 
				}); */
			}
		});
	}
});