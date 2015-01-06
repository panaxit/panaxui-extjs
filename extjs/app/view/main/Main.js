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
        'Panax.view.main.MainModel',
        'Panax.view.Header',
        'Panax.view.ContentPanel',
        'Panax.view.navigation.Tree',
        'Panax.view.navigation.Breadcrumb'
    ],

    xtype: 'app-main',

    controller: 'main',
    viewModel: {
        type: 'main'
    },

    layout: {
        type: 'border'
    },

    stateful: true,
    stateId: 'Px-viewport',

    items: [{
        region: 'north',
        xtype: 'appHeader'
    }, {
        region: 'west',
        reference: 'tree',
        xtype: 'navigation-tree'
    }, {
        region: 'center',
        xtype: 'contentPanel',
        reference: 'contentPanel'
        // dockedItems: [{
        //     xtype: 'navigation-breadcrumb',
        //     reference: 'breadcrumb>'
        // }]
    }]

    // applyState: function(state) {
    //     this.getController().applyState(state);
    // },

    // getState: function() {
    //     return this.getController().getState();
    // }
});