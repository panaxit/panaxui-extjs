/**
 * This class manages the login process.
 */
Ext.define('Panax.LoginManager', {
    // config: {
        /**
         * @cfg {Ext.data.Session} session
         */
    //     session: null
    // },

    // constructor: function (config) {
    //     this.initConfig(config);
    // },

    login: function(options) {
        Ext.Ajax.request({
            url: '/SINCO/Version/Beta_12.6/extjs/Scripts/login.asp',
            async:false,
            method: 'POST',
            params: options.data,
            scope: this,
            callback: this.onLoginReturn,
            original: options
        });
    },
    
    onLoginReturn: function(options, success, response) {
        options = options.original;

        if (success) {
            var responseText = Ext.JSON.decode(response.responseText);

            if (responseText.success) {
                Ext.callback(options.success, options.scope, [responseText]);
                return;
            } else {
                Ext.callback(options.failure, options.scope, [responseText]);
                return;
            }
        }

        Ext.callback(options.failure, options.scope, [response]);
    },

    // logout: function(options) {
    //     Ext.Ajax.request({
    //         url: '/SINCO/Version/Beta_12.6/extjs/Scripts/logout.asp',
    //         method: 'GET',
    //         scope: this,
    //         callback: this.onLogoutReturn,
    //         original: options
    //     });
    // },
    
    // onLogoutReturn: function(options, success, response) {
    //     options = options.original;

    //     if (success) {
    //         var responseText = Ext.JSON.decode(response.responseText);
    //         if (responseText.success) {
    //             // ToDo
    //         }
    //     }
    // }
});
