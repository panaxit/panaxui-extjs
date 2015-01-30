Ext.define('Panax.view.base.ImageContainer', {
	extend: 'Panax.view.base.FileManager',
	alias: 'widget.imagemanager',

	NO_IMAGE_FILE: 'Images/FileSystem/no_photo.gif',
	UPLOAD_URL: '/FilesRepository/Test/',
	title: 'Imagen Adjunta',

	fileChange: function(el, val) {
		var me = this,
			imagePath = val;
		me.showFileLabel(val);
		me.loadImage(imagePath);
	},
	showFileName: false,
	initComponent: function() {
		this.callParent();
	}
});