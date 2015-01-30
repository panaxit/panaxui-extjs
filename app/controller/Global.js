Ext.define('Panax.controller.Global', {
    extend: 'Ext.app.Controller',
    requires: [
        'Panax.view.*',
        'Ext.window.*'
    ],

    stores: [
        'Thumbnails'
    ],

    config: {
        control: {
            'navigation-tree': {
                selectionchange: 'onTreeNavSelectionChange'
            },
            'navigation-breadcrumb breadcrumb': {
                selectionchange: 'onBreadcrumbNavSelectionChange'
            },
            'thumbnails': {
                itemclick: 'onThumbnailClick',
                itemdblclick: 'onThumbnailClick'
            }
        },
        refs: {
            viewport: 'viewport',
            navigationTree: 'navigation-tree',
            navigationBreadcrumb: 'navigation-breadcrumb',
            contentPanel: 'contentPanel',
            descriptionPanel: 'descriptionPanel',
            thumbnails: {
                selector: 'thumbnails',
                xtype: 'thumbnails',
                autoCreate: true
            }
        },
        routes: {
            '!:controlType/:mode/:catalogName/:idValue': {
                action: 'handleRoute',
                before: 'beforeHandleRoute',
                conditions: {
                    ':idValue': '([0-9]+|)',
                    ':catalogName': '([a-zA-Z0-9\\-\\_\\.]+)'
                        //':mode' : '(readonly|edit|insert|filters|custom)',
                        //':controlType' : '([a-zA-Z0-9\\-\\_]+)'
                }
            },
            '!:controlType/:mode/:catalogName': {
                action: 'handleRoute',
                before: 'beforeHandleRouteCatalog',
                conditions: {
                    ':catalogName': '([a-zA-Z0-9\\-\\_\\.]+)'
                        //':mode' : '(readonly|edit|insert|filters|cards|custom)',
                        //':controlType' : '([a-zA-Z0-9\\-\\_]+)'
                }
            },
            ':category': {
                action: 'handleRoute',
                before: 'beforeHandleRouteCategory'
                    // conditions : {
                    //     ':category' : '([a-zA-Z0-9\\-\\_]+)'
                    // }
            }
        }
    },

    beforeHandleRouteCatalog: function(controlType, mode, catalogName, action) {
        this.beforeHandleRoute(controlType, mode, catalogName, null, action);
    },

    beforeHandleRouteCategory: function(category, action) {
        this.beforeHandleRoute(category, null, null, null, action);
    },

    beforeHandleRoute: function(controlType, mode, catalogName, idValue, action) {
        var me = this,
            hash = window.location.hash.substring(1),
            node = Ext.StoreMgr.get('navigation').getNodeById(hash);

        if (!this.getApplication().loggedIn) {
            if (hash != me.getApplication().getDefaultToken()) {
                Ext.Msg.alert(
                    'Not logged in',
                    'Please login',
                    function() {
                        me.redirectTo(me.getApplication().getDefaultToken());
                    }
                );
            }
            //stop action
            action.stop();
            return;
        }

        if (node) {
            console.info("Route changed: " + hash);
            if (node.get('pk')) {
                console.info("Route PK (filter): " + node.get('pk'));
            }
            if (node.get('filters')) {
                console.info("Route filters: " + node.get('filters'));
            }
            //resume action
            action.resume();
        } else {
            Ext.Msg.alert(
                'Route Failure',
                'The view for ' + catalogName + ' could not be found. You will be taken to the application\'s start',
                function() {
                    me.redirectTo(me.getApplication().getDefaultToken());
                }
            );
            //stop action
            action.stop();
        }
    },

    handleRoute: function(controlType, mode, catalogName, idValue) {
        var me = this,
            hash = window.location.hash.substring(1),
            navigationTree = me.getNavigationTree(),
            navigationBreadcrumb = me.getNavigationBreadcrumb(),
            store = Ext.StoreMgr.get('navigation'),
            node = store.getNodeById(hash),
            // text = node.get('text'),

            contentPanel = me.getContentPanel(),
            themeName = Ext.themeName,
            thumbnails = me.getThumbnails(),
            hasTree = navigationTree && navigationTree.isVisible(),
            thumbnailsStore, panaxCmp;

        Ext.suspendLayouts();

        if (node.isLeaf()) {
            if (thumbnails.ownerCt) {
                contentPanel.remove(thumbnails, false); // remove thumbnail view without destroying
            } else {
                contentPanel.removeAll(true);
            }

            if (hasTree) {
                navigationTree.expandPath(node.getPath());
                navigationTree.getSelectionModel().select(node);
                navigationTree.getView().focusNode(node);
            } else {
                navigationBreadcrumb.setSelection(node);
            }

            /*
            Add Panax Component
             */
            contentPanel.add(Panax.core.PanaxComponent.getComponent({
                prefix: "Cache.app",
                dbId: "Demo",
                lang: "es",
                catalogName: catalogName,
                mode: mode,
                controlType: controlType
            }, {
                idValue: idValue, // A.K.A. node.get('pk')
                filters: node.get('filters')
            }));

        } else {
            if (!hasTree) {
                navigationBreadcrumb.setSelection(node);
            } else {
                navigationTree.expandPath(node.getPath());
                navigationTree.getView().focusNode(node);
            }
            thumbnailsStore = me.getThumbnailsStore();
            thumbnailsStore.removeAll();
            thumbnailsStore.add(node.childNodes);
            if (!thumbnails.ownerCt) {
                contentPanel.removeAll(true);
            }
            contentPanel.add(thumbnails);
        }

        this.updateTitle(node);

        Ext.resumeLayouts(true);
    },

    updateTitle: function(node) {
        var text = node.get('text'),
            title = node.isLeaf() ? (node.parentNode.get('text') + ' - ' + text) : text;

        this.getContentPanel().setTitle(title);
        document.title = document.title.split(' - ')[0] + ' - ' + text;
    },

    onTreeNavSelectionChange: function(selModel, records) {
        var record = records[0];

        if (record) {
            this.redirectTo(record.getId());
        }
    },

    onBreadcrumbNavSelectionChange: function(breadcrumb, node) {
        if (node) {
            this.redirectTo(node.getId());
        }
    },

    onThumbnailClick: function(view, node) {
        this.redirectTo(node.getId());
    }
});