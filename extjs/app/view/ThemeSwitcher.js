Ext.define('Panax.view.ThemeSwitcher', function() {
    return {
        extend: 'Ext.Container',
        xtype: 'themeSwitcher',
        id: 'theme-switcher-btn',
        margin: '0 10 0 0',
        layout: 'hbox',

        initComponent: function() {
            var me = this;

            var menu = new Ext.menu.Menu({
                items: [{
                    text: 'Logout',
                    handler: 'onLogoutClick'
                }]
            });

            this.items = [{
                xtype: 'component',
                id: 'theme-switcher',
                cls: 'ks-theme-switcher',
                margin: '0 5 0 0',
                listeners: {
                    scope: this,
                    click: function(e) {
                        menu.showBy(this);
                    },
                    element: 'el'
                }
            }];

            this.callParent();
        }
    };
});