Ext.define('Panax.view.main.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.main',

    onLogoutClick: function(action) {
        var me = this;

        Ext.Msg.show({
            title: 'Logout',
            message: 'Logout?',
            buttons: Ext.Msg.YESNO,
            icon: Ext.Msg.QUESTION,
            fn: function(btn) {
                if (btn === 'yes') {
                    me.fireViewEvent('logout');
                }
            }
        });
    },

    // applyState: function(state) {
    //     var refs = this.getReferences();
    //     if (state.hasTreeNav) {
    //         this.getView().moveBefore({
    //             region: 'west',
    //             reference: 'tree',
    //             xtype: 'navigation-tree'
    //         }, refs.contentPanel);


    //         refs.breadcrumb.hide();
    //         refs.contentPanel.header.hidden = false;
    //         this._hasTreeNav = true;
    //     } else {
    //         this._hasTreeNav = false;
    //     }
    // },

    // getState: function() {
    //     return {
    //         hasTreeNav: this._hasTreeNav
    //     };
    // },

    showBreadcrumbNav: function() {
        var refs = this.getReferences(),
            breadcrumbNav = refs.breadcrumb,
            treeNav = refs.tree,
            selection = treeNav.getSelectionModel().getSelection()[0];

        if (breadcrumbNav) {
            breadcrumbNav.show();
        } else {
            refs.contentPanel.addDocked({
                xtype: 'navigation-breadcrumb',
                reference: 'breadcrumb>',
                selection: selection
            });
        }

        refs['breadcrumb.toolbar'].setSelection(selection || 'root');

        treeNav.hide();
        refs.contentPanel.getHeader().hide();

        this._hasTreeNav = false;
        this.getView().saveState();
    },

    showTreeNav: function() {
        var refs = this.getReferences(),
            treeNav = refs.tree,
            breadcrumbNav = refs.breadcrumb,
            selection = refs['breadcrumb.toolbar'].getSelection();

        if (treeNav) {
            treeNav.show();
        } else {
            treeNav = this.getView().moveBefore({
                region: 'west',
                reference: 'tree',
                xtype: 'navigation-tree'
            }, refs.contentPanel);
        }

        if (selection) {
            treeNav.getSelectionModel().select([
                selection
            ]);

            breadcrumbNav.hide();
            refs.contentPanel.getHeader().show();

            this._hasTreeNav = true;
            this.getView().saveState();
        }
    }
});