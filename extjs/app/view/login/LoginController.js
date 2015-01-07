Ext.define('Panax.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login',

    loginText: 'Logging in...',

    onSpecialKey: function(field, e) {
        if (e.getKey() === e.ENTER) {
            this.doLogin();
        }
    },

    onLoginClick: function() {
        this.doLogin();
    },

    doLogin: function() {
        var form = this.lookupReference('loginForm').getForm();

        if (form.isValid()) {
            Ext.getBody().mask(this.loginText);

            if (!this.loginManager) {
                this.loginManager = new Panax.LoginManager({
                    session: this.getView().getSession()
                });
            }

            this.loginManager.login({
                data: {
                    username: form.findField('username').getValue(),
                    password: calcMD5(form.findField('password').getValue())
                    //password: calcMD5(!(this.caseSensitive)?form.findField('password').getValue().toUpperCase():form.findField('password').getValue())
                },
                scope: this,
                success: 'onLoginSuccess',
                failure: 'onLoginFailure'
            });
        }
    },

    onLoginFailure: function(response) {
        Ext.getBody().unmask();

        Ext.Msg.show({
            title: (response.message ? '' : 'Communication ') + 'Error',
            msg: response.message ? response.message : "Server request failed.",
            icon: Ext.MessageBox.ERROR,
            buttons: Ext.Msg.OK
        });
    },

    onLoginSuccess: function(response) {
        Ext.getBody().unmask();

        this.fireViewEvent('login', this.getView(), this.loginManager);
    }
});