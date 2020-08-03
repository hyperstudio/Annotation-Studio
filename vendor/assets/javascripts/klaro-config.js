// By default, Klaro will load the config from  a global "klaroConfig" variable.
// You can change this by specifying the "data-config" attribute on your
// script take, e.g. like this:
// <script src="klaro.js" data-config="myConfigVariableName" />
// You can also disable auto-loading of the consent notice by adding
// data-no-auto-load=true to the script tag.
var klaroConfig = {
    // You can customize the ID of the DIV element that Klaro will create
    // when starting up. If undefined, Klaro will use 'klaro'.
    elementID: 'klaro',

    // How Klaro should store the user's preferences. It can be either 'cookie'
    // (the default) or 'localStorage'.
    storageMethod: 'cookie',

    // You can customize the name of the cookie that Klaro uses for storing
    // user consent decisions. If undefined, Klaro will use 'klaro'.
    cookieName: 'klaro',

    // You can also set a custom expiration time for the Klaro cookie.
    // By default, it will expire after 120 days.
    cookieExpiresAfterDays: 365,

    // You can change to cookie domain for the consent manager itself.
    // Use this if you want to get consent once for multiple matching domains.
    // If undefined, Klaro will use the current domain.
    //cookieDomain: '.github.com',

    // Put a link to your privacy policy here (relative or absolute).
    privacyPolicy: '/pages/privacypolicy',

    // Defines the default state for applications (true=enabled by default).
    default: true,

    // If "mustConsent" is set to true, Klaro will directly display the consent
    // manager modal and not allow the user to close it before having actively
    // consented or declines the use of third-party apps.
    mustConsent: false,

    // Show "accept all" to accept all apps instead of "ok" that only accepts
    // required and "default: true" apps
    acceptAll: false,

    // replace "decline" with cookie manager modal
    hideDeclineAll: true,

    // hide "learnMore" link
    hideLearnMore: false,

    // You can define the UI language directly here. If undefined, Klaro will
    // use the value given in the global "lang" variable. If that does
    // not exist, it will use the value given in the "lang" attribute of your
    // HTML tag. If that also doesn't exist, it will use 'en'.
    lang: 'en',

    // You can overwrite existing translations and add translations for your
    // app descriptions and purposes. See `src/translations/` for a full
    // list of translations that can be overwritten:
    // https://github.com/KIProtect/klaro/tree/master/src/translations

    // Example config that shows how to overwrite translations:
    // https://github.com/KIProtect/klaro/blob/master/src/configs/i18n.js
    translations: {
        en: {
            consentNotice: {
                // uncomment and edit this to add extra HTML to the consent notice below the main text
                extraHTML: "<p>Please see our <a href=\"/pages/cookiepolicy\">Cookie Policy</a> for further information.</p>",
            },
            consentModal: {
                // uncomment and edit this to add extra HTML to the consent modal below the main text
                extraHTML: "<p>Please see our <a href=\"/pages/cookiepolicy\">Cookie Policy</a> for information about individual cookies.</p>",
                description:
                    'Here you can see and customize the information that we collect about you.',
            },
            'annotation-studio': {
                description: 'Used to preserve visitors\' user configurations'
            },
            'google-analytics': {
                description: 'Collection of visitor statistics',
            },
            typekit: {
                description: 'Web fonts hosted by Adobe',
            },
            purposes: {
                analytics: 'This helps us keep track of how many active users we have, where they are from, and how they got here.',
                configuration: 'This allows us to save your settings for next time you log in.',
                security: 'Security',
                styling: 'This helps us display various fonts used throughout Annotation Studio.',
            },
        },
    },

    // This is a list of third-party apps that Klaro will manage for you.
    apps: [
        {  
            name: 'annotation-studio',
            title: 'Annotation Studio',
            purposes: ['configuration'],
            required: true,
        },
        {
            // Each app should have a unique (and short) name.
            name: 'google-analytics',

            // If "default" is set to true, the app will be enabled by default
            // Overwrites global "default" setting.
            // We recommend leaving this to "false" for apps that collect
            // personal information.
            default: true,

            // The title of you app as listed in the consent modal.
            title: 'Google Analytics',

            // The purpose(s) of this app. Will be listed on the consent notice.
            // Do not forget to add translations for all purposes you list here.
            purposes: ['analytics'],

            // A list of regex expressions or strings giving the names of
            // cookies set by this app. If the user withdraws consent for a
            // given app, Klaro will then automatically delete all matching
            // cookies.
            cookies: [
                // you can also explicitly provide a path and a domain for
                // a given cookie. This is necessary if you have apps that
                // set cookies for a path that is not "/" or a domain that
                // is not the current domain. If you do not set these values
                // properly, the cookie can't be deleted by Klaro
                // (there is no way to access the path or domain of a cookie in JS)
                // Notice that it is not possible to delete cookies that were set
                // on a third-party domain! See the note at mdn:
                // https://developer.mozilla.org/en-US/docs/Web/API/Document/cookie#new-cookie_domain
                [/^__utma.*$/, '/', 'annotationstudio.org'], //for the production version
                [/^__utma.*$/, '/', 'annotationstudio-next.herokuapp.com'], //for the staging version
                [/^__utma.*$/, '/', 'localhost'], //for the local version
                [/^__utmb.*$/, '/', 'annotationstudio.org'], 
                [/^__utmb.*$/, '/', 'annotationstudio-next.herokuapp.com'], 
                [/^__utmb.*$/, '/', 'localhost'],
                [/^__utmc.*$/, '/', 'annotationstudio.org'],
                [/^__utmc.*$/, '/', 'annotationstudio-next.herokuapp.com'],
                [/^__utmc.*$/, '/', 'localhost'],
                [/^__utmt.*$/, '/', 'annotationstudio.org'],
                [/^__utmt.*$/, '/', 'annotationstudio-next.herokuapp.com'],
                [/^__utmt.*$/, '/', 'localhost'],
                [/^__utmz.*$/, '/', 'annotationstudio.org'], 
                [/^__utmz.*$/, '/', 'annotationstudio-next.herokuapp.com'], 
                [/^__utmz.*$/, '/', 'localhost'], 
            ],

            // If "required" is set to true, Klaro will not allow this app to
            // be disabled by the user.
            required: false,

            // If "optOut" is set to true, Klaro will load this app even before
            // the user gave explicit consent.
            // We recommend always leaving this "false".
            optOut: false,

            // If "onlyOnce" is set to true, the app will only be executed
            // once regardless how often the user toggles it on and off.
            onlyOnce: false,
        },

        // The apps will appear in the modal in the same order as defined here.
        {
            name: 'typekit',
            title: 'Adobe TypeKit',
            purposes: ['styling'],
        },
    ],
};
