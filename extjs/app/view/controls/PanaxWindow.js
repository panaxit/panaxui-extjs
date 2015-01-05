Ext.define('Panax.view.PanaxWindow', {
	extend: 'Ext.window.Window',
    alias: 'widget.panaxwindow',

    //autoShow: true,
    modal: true,
	maximizable: true,
	closable: false,
	layout: 'fit',
    autoScroll: true,
    width: 800,
    height: 600
});