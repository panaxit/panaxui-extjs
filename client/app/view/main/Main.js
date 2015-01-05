/**
 * This class is the main view for the application. It is specified in app.js as the
 * "autoCreateViewport" property. That setting automatically applies the "viewport"
 * plugin to promote that instance of this class to the body element.
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('Panax.view.main.Main', {
    extend: 'Ext.container.Container',
    plugins: 'viewport',
    requires: [
        'Panax.view.main.MainController',
        'Panax.view.main.MainModel'
    ],

    xtype: 'app-main',
    
    controller: 'main',
    viewModel: {
        type: 'main'
    },

    layout: {
        type: 'border'
    },

    items: [{
        xtype: 'panel',
        title: 'Navigation',
        region: 'west',
        html: '<ul><li>This area is commonly used for navigation, for example, using a "tree" component.</li></ul>',
        width: 250,
        split: true,
        collapsible: true
    },{
        region: 'north',
        xtype: 'container',
        padding: 10,
        height: 40,
        layout: {
            type: 'hbox',
            align: 'middle'
        },
        items: [{
            xtype: 'component',
            html: 'PanaxUI v13.0',
            flex: 1
        }, {
            xtype: 'button',
            text: 'Logout',
            handler: 'onLogoutClick'
        }]
    },{
        region: 'center',
        xtype: 'tabpanel',
        items:[{
            title: 'Tab 1',
            html: '<h2>Content appropriate for the current navigation.</h2>'
        }]
    }]
});
