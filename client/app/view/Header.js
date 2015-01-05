Ext.define('Panax.view.Header', {
    extend: 'Ext.Container',
    xtype: 'appHeader',
    id: 'app-header',
    title: 'Panax UI',
    height: 52,
    layout: {
        type: 'hbox',
        align: 'middle'
    },

    initComponent: function() {
        document.title = this.title;

        this.items = [{
            xtype: 'component',
            id: 'app-header-logo'
        },{
            xtype: 'component',
            id: 'app-header-title',
            html: this.title,
            flex: 1
        }, {
            xtype: 'button',
            text: 'Logout',
            handler: 'onLogoutClick'
        }];

        // if (!Ext.getCmp('options-toolbar')) {
        //     this.items.push({
        //         xtype: 'themeSwitcher'
        //     });
        // }

        this.callParent();
    }
});
