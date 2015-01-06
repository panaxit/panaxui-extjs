/**
 * The main application class. An instance of this class is created by app.js when it calls
 * Ext.application(). This is the ideal place to handle application launch and initialization
 * details.
 */
Ext.define('Panax.Application', {
    extend: 'Ext.app.Application',

    name: 'Panax',

    stores: [
        'Panax.store.Navigation'
    ],

    views: [
        'Panax.view.login.Login',
        'Panax.view.main.Main'
    ],

    requires: [
        'Ext.tip.QuickTipManager',
        'Ext.state.CookieProvider',
        'Ext.ux.BoxReorderer',
        'Ext.ux.colorpick.Field',
        'Panax.LoginManager',
        'Panax.core.PanaxComponent'
    ],

    controllers: [
        'Global'
    ],

    loadingText: 'Loading...',

    init: function() {

        Ext.create('Panax.store.Navigation', {
            storeId: 'navigation'
        });

        // Set the default route to start the application.
        this.setDefaultToken('home');

        Ext.setGlyphFontFamily('Pictos');
        Ext.tip.QuickTipManager.init();
        Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));

        this.config = {
            rootPath: '../../..'
            ,filesRepositoryPath: 'FilesRepository'
            ,scriptsPath: 'Scripts'
        }
    },

    launch: function() {
        var supportsLocalStorage = Ext.supports.LocalStorage;

        if (Ext.isIE8) {
            Ext.Msg.alert('Not Supported', 'Internet Explorer 8 is not supported. Please use a different browser.');
            return;
        }

        if (!supportsLocalStorage) {
            Ext.Msg.alert('Your Browser Does Not Support Local Storage');
            return;
        }

        this.loggedIn = localStorage.getItem("PanaxLoggedIn");

        // this.session = new Ext.data.Session({
        //     autoDestroy: false
        // });
        if (this.loggedIn) {
            this.showUI();
        } else {
            this.showLogin();
        }
    },

    /**
     * Called when the login controller fires the "login" event.
     *
     * @param loginController
     * @param loginManager
     */
    onLogin: function(loginController, loginManager) {
        this.login.destroy();

        this.loginManager = loginManager;

        localStorage.setItem("PanaxLoggedIn", true);

        this.showUI();
    },

    /**
     * Called when the login controller fires the "logout" event.
     */
    onLogout: function() {
        //this.loginManager.logout();

        this.viewport.destroy();

        localStorage.removeItem('PanaxLoggedIn');

        this.showLogin();
    },

    /**
     * Show Login Window
     */
    showLogin: function() {
        this.login = new Panax.view.login.Login({
            // session: this.session,
            autoShow: true,
            listeners: {
                scope: this,
                login: 'onLogin'
            }
        });
    },

    /**
     * Show Main View
     */
    showUI: function() {
        this.viewport = new Panax.view.main.Main({
            // session: this.session,
            listeners: {
                scope: this,
                logout: 'onLogout'
            }
        });
    }

    /**
     * Get Session
     */
    // getSession: function() {
    //     return this.session;
    // }
});