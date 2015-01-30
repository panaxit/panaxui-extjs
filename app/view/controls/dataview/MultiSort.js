Ext.define('Panax.view.dataview.MultiSort', {
    extend: 'Ext.panel.Panel',
    xtype: 'dataview-multisort',
    layout: 'fit',

    requires: [
        'Ext.toolbar.TextItem',
        'Ext.view.View',
        'Ext.ux.DataView.Animated',
        'Ext.ux.BoxReorderer'
    ],

    initComponent: function() {
        this.tbar.plugins = {
            xclass: 'Ext.ux.BoxReorderer',
            listeners: {
                scope: this,
                drop: this.updateStoreSorters
            }
        };

        this.tbar.defaults = {
            xtype: 'dataview-multisort-sortbutton',
            listeners: {
                scope: this,
                changeDirection: this.updateStoreSorters
            }
        };

        this.callParent(arguments);
        this.updateStoreSorters();
    },

    /**
     * Returns the array of Ext.util.Sorters defined by the current toolbar button order
     * @return {Array} The sorters
     */
    getSorters: function() {
        var buttons = this.query('toolbar dataview-multisort-sortbutton'),
            sorters = [];
        Ext.Array.each(buttons, function(button) {
            sorters.push({
                property: button.getDataIndex(),
                direction: button.getDirection()
            });
        });

        return sorters;
    },

    /**
     * @private
     * Updates the DataView's Store's sorters based on the current Toolbar button configuration
     */
    updateStoreSorters: function() {
        var sorters = this.getSorters(),
            view = this.down('dataview');

        view.store.sort(sorters);
    }
});

Ext.define('Panax.view.dataview.MultiSortItem', {
    extend: 'Ext.view.View',
    xtype: 'dataview-multisort-items',
    tpl: [
        '<tpl for=".">',
        '<div class="dataview-multisort-item" id="dataview-multisort-item-{id}">',
        '</div>',
        '</tpl>'
    ],
    emptyText: 'No hay registros',
    itemSelector: 'div.dataview-multisort-item'
});

Ext.define('Panax.view.dataview.MultiSortButton', {
    extend: 'Ext.button.Button',
    xtype: 'dataview-multisort-sortbutton',

    config: {
        direction: "ASC",
        dataIndex: undefined
    },

    /**
     * @event changeDirection
     * Fired whenever the user clicks this button to change its direction
     * @param {String} direction The new direction (ASC or DESC)
     */
    handler: function() {
        this.toggleDirection();
    },

    /**
     * Updates the new direction of this button
     * @param {String} direction The new direction
     */
    updateDirection: function(direction) {
        this.setIconCls('sort-direction-' + direction.toLowerCase());
        this.fireEvent('changeDirection', this.getDirection());
    },

    /**
     * Toggles between ASC and DESC directions
     */
    toggleDirection: function() {
        this.setDirection(Ext.String.toggle(this.getDirection(), "ASC", "DESC"));
    }
});