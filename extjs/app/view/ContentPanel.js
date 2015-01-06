Ext.define('Panax.view.ContentPanel', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.contentpanel',
    xtype: 'contentPanel',
    id: 'content-panel',
    requires: [
        'Ext.ux.statusbar.StatusBar'
    ],

    header: {
        hidden: false
    },

    layout: 'center',

    tools: [{
        type: 'pin',
        tooltip: 'Agragar a favoritos',
        handler: ''
    }, {
        type: 'print',
        tooltip: 'Imprimir Reporte (printView)',
        handler: ''
    }, {
        type: 'help',
        tooltip: 'Ayuda de Modulo',
        handler: ''
    }, {
        type: 'refresh',
        tooltip: 'Refrescar Modulo',
        handler: ''
    }]
});