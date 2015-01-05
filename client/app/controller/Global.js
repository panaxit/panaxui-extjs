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
            },
            'tool[regionTool]': {
                click: 'onSetRegion'
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
        routes  : {
            '!:controlType/:mode/:catalogName/:idValue': {
                action: 'handleRoute',
                before: 'beforeHandleRoute',
                conditions : {
                    ':idValue' : '([0-9]+|)',
                    ':catalogName' : '([a-zA-Z0-9\\-\\_\\.]+)'
                    //':mode' : '(readonly|edit|insert|filters|custom)',
                    //':controlType' : '([a-zA-Z0-9\\-\\_]+)'
                }
            },
            '!:controlType/:mode/:catalogName': {
                action: 'handleRoute',
                before: 'beforeHandleRouteCatalog',
                conditions : {
                    ':catalogName' : '([a-zA-Z0-9\\-\\_\\.]+)'
                    //':mode' : '(readonly|edit|insert|filters|cards|custom)',
                    //':controlType' : '([a-zA-Z0-9\\-\\_]+)'
                }
            },
            // '!:controlType/:mode': {
            //     action: 'handleRoute',
            //     before: 'beforeHandleRoute',
            //     conditions : {
            //         ':mode' : '(readonly|edit|insert|filters|cards)',
            //         ':controlType' : '([a-zA-Z0-9\\-\\_]+)'
            //     }
            // },
            // '!:controlType': {
            //     action: 'handleRoute',
            //     before: 'beforeHandleRoute',
            //     conditions : {
            //         ':controlType' : '([a-zA-Z0-9\\-\\_]+)'
            //     }
            // },
            ':category': {
                action: 'handleRoute',
                before: 'beforeHandleRouteCategory'
                // conditions : {
                //     ':category' : '([a-zA-Z0-9\\-\\_]+)'
                // }
            },
            '!action=:action': {
                action: 'handleActionRoute',
                //before: 'beforeHandleRouteCategory'
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

        if(!this.getApplication().loggedIn) {
            if(hash!=me.getApplication().getDefaultToken()) {
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
            console.info("Route changed: "+hash);
            if(node.get('pk')) {
                console.info("Route PK (filter): "+node.get('pk'));
            } 
            if(node.get('filters')) {
                console.info("Route filters: "+node.get('filters'));
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

    handleActionRoute: function(action) {
        var me = this,
            store = Ext.StoreMgr.get('navigation'),
            hash = window.location.hash.substring(1),
            node = store.getNodeById(hash);

        if(action=="logout") {
            Ext.Msg.show({
                title:'Salir del Sistema',
                message: 'Salir?',
                buttons: Ext.Msg.YESNO,
                icon: Ext.Msg.QUESTION,
                fn: function(btn) {
                    if (btn === 'yes') {
                        debugger;
                        //me.getApplication().fireViewEvent('logout');
                    } else {
                        Ext.History.back();
                    }
                }
            });
        } else {
            me.redirectTo(me.getApplication().getDefaultToken());
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
            panaxCmp, thumbnailsStore;

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

            panaxCmp = Panax.getPanaxComponent({
                prefix: "Cache.app"
                , dbId: "Demo"
                , lang: "es"
                , catalogName: catalogName
                , mode: mode
                , controlType: controlType
            },{
                idValue: idValue, // A.K.A. node.get('pk')
                filters: node.get('filters')
            });

            contentPanel.add(panaxCmp);

            this.updateTitle(node);

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
            this.updateTitle(node);
        }

        Ext.resumeLayouts(true);
    },
    
    updateTitle: function(node) {
        var text = node.get('text'),
            title = node.isLeaf() ? (node.parentNode.get('text') + ' - ' + text) : text;
        
        this.getContentPanel().setTitle(title);
        document.title = document.title.split(' - ')[0] + ' - ' + text;
    },

    exampleRe: /^\s*\/\/\s*(\<\/?example\>)\s*$/,
    themeInfoRe: /this\.themeInfo\.(\w+)/g,

    renderCodeMarkup: function(loader, response) {
        var code = this.processText(response.responseText, loader.themeInfo);
        // Passed in from the block above, we keep the proto cloned copy.
        loader.resource.html = code;
        loader.getTarget().setHtml(code);
        prettyPrint();
        return true;
    },

    processText: function (text, themeInfo) {
        var lines = text.split('\n'),
            removing = false,
            keepLines = [],
            len = lines.length,
            exampleRe = this.exampleRe,
            themeInfoRe = this.themeInfoRe,
            encodeTheme = function (text, match) {
                return Ext.encode(themeInfo[match]);
            },
            i, line, code;

        for (i = 0; i < len; ++i) {
            line = lines[i];
            if (removing) {
                if (exampleRe.test(line)) {
                    removing = false;
                }
            } else if (exampleRe.test(line)) {
                removing = true;
            } else {
                // Replace "this.themeInfo.foo" with the value of "foo" properly encoded
                // for JavaScript (otherwise strings would not be quoted).
                line = line.replace(themeInfoRe, encodeTheme);
                keepLines.push(line);
            }
        }

        code = Ext.htmlEncode(keepLines.join('\n'));
        return '<pre class="prettyprint">' + code + '</pre>';
    },

    onSetRegion: function (tool) {
        var panel = tool.toolOwner;

        var regionMenu = panel.regionMenu || (panel.regionMenu =
            Ext.widget({
                xtype: 'menu',
                items: [{
                    text: 'North',
                    checked: panel.region === 'north',
                    group: 'mainregion',
                    handler: function () {
                        panel.setBorderRegion('north');
                    }
                },{
                    text: 'South',
                    checked: panel.region === 'south',
                    group: 'mainregion',
                    handler: function () {
                        panel.setBorderRegion('south');
                    }
                },{
                    text: 'East',
                    checked: panel.region === 'east',
                    group: 'mainregion',
                    handler: function () {
                        panel.setBorderRegion('east');
                    }
                },{
                    text: 'West',
                    checked: panel.region === 'west',
                    group: 'mainregion',
                    handler: function () {
                        panel.setBorderRegion('west');
                    }
                }]
            }));

        regionMenu.showBy(tool.el);
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