Ext.define("Panax.view.login.Login", {
    extend: 'Ext.window.Window',
    xtype: 'login',

    requires: [
        'Panax.view.login.LoginController',
        'Panax.view.login.LoginModel',
        'Ext.form.Panel'
    ],

    viewModel: 'login',
    controller: 'login',

    bodyPadding: 10,
    title: 'Welcome',
    closable: false,
    autoShow: true,

    items: {
        xtype: 'form',
        reference: 'loginForm',
        items: [{
            xtype: 'textfield',
            name: 'username',
            bind: '{username}',
            fieldLabel: 'Username',
            allowBlank: false,
            enableKeyEvents: true,
            listeners: {
                specialKey: 'onSpecialKey'
            }
        }, {
            xtype: 'textfield',
            name: 'password',
            inputType: 'password',
            fieldLabel: 'Password',
            allowBlank: false,
            enableKeyEvents: true,
            listeners: {
                specialKey: 'onSpecialKey'
            }
        }]
    },

    buttons: [{
        text: 'Login',
        formBind: true,
        listeners: {
            click: 'onLoginClick'
        }
    }]
});