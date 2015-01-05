Ext.define('Panax.view.thumbnails.Thumbnails', {
    extend: 'Ext.view.View',
    xtype: 'thumbnails',
    cls: 'thumbnails',
    reference: 'contentView',
    region: 'center',
    store: 'Thumbnails',
    itemSelector: '.thumbnail-item',

    initComponent: function() {
        var backgrounds = {
            crisp: 'border-circle',
                'crisp-touch': 'circle',
                neptune: 'border-square',
                'neptune-touch': 'square',
                classic: 'rounded-square',
                gray: 'rounded-square'
        };
        
        this.tpl =
            '<tpl for=".">' +
                '<div class="thumbnail-item">' +
                    //'<div class="thumbnail-icon-wrap icon-' + backgrounds[Ext.themeName] + '">' +
                    '<div class="thumbnail-icon-wrap icon-border-circle">' +
                        '<div class="thumbnail-icon icon-{iconCls}"></div>' +
                    '</div>' +
                    '<div class="thumbnail-text">{text}</div>' +
                '</div>' +
            '</tpl>';
        
        this.callParent();
    }
});