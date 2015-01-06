Ext.define('Panax.view.PanaxForm', {
    extend: 'Ext.form.Panel',
    alias: 'widget.panaxform',
    bodyPadding: 10,
    closable: false,
    border: true,
    autoScroll: true,
    layout: {
        type: 'vbox', // Arrange child items vertically
        align: 'stretch', // Each takes up full width
    },
    initComponent: function() {
        var me = this;

        console.info("PanaxForm initiated: " + this.id);

        this.callParent();
    }
});