// The cookie consent banner (vanilla-cookieconsent). It enables the scripts marked data-category="analytics" (Google
// Analytics) only once the visitor accepts analytics cookies, and stays on the page across Turbo visits.
import * as CookieConsent from 'vanilla-cookieconsent';

const contactLink = (text) => `<a href="/contact">${text}</a>`;

const translations = {
  en: {
    consentModal: {
      title: 'Cookies',
      description:
        'We use cookies to ensure you get the best experience on our website. Please choose your preferences.',
      acceptAllBtn: 'Accept All',
      acceptNecessaryBtn: 'Reject All',
      showPreferencesBtn: 'Manage Individual Preferences',
    },
    preferencesModal: {
      title: 'Manage Your Cookie Preferences',
      acceptAllBtn: 'Accept All',
      acceptNecessaryBtn: 'Reject All',
      savePreferencesBtn: 'Accept Current Selection',
      closeIconLabel: 'Close Modal',
      sections: [
        {
          title: 'Strictly Necessary Cookies',
          description:
            'These cookies are essential for the proper functioning of the website and cannot be disabled. If you register and log in to the site, we will use a cookie to remember if you are logged in.',
          linkedCategory: 'necessary',
        },
        {
          title: 'Performance and Analytics',
          description:
            'These cookies collect information about how you use our website. All of the data is anonymized and cannot be used to identify you.',
          linkedCategory: 'analytics',
        },
        {
          title: 'More information',
          description: `For any queries in relation to our policy on cookies and your choices, please ${contactLink(
            'contact us',
          )}`,
        },
      ],
    },
  },
  sk: {
    consentModal: {
      title: 'Cookies',
      description:
        'Používame cookies, aby sme zaistili, že na našej webovej stránke získate čo najlepší zážitok. Prosím, vyberte si svoje preferencie.',
      acceptAllBtn: 'Prijať všetky',
      acceptNecessaryBtn: 'Odmietnuť všetky',
      showPreferencesBtn: 'Spravovať individuálne preferencie',
    },
    preferencesModal: {
      title: 'Spravujte svoje preferencie cookies',
      acceptAllBtn: 'Prijať všetky',
      acceptNecessaryBtn: 'Odmietnuť všetky',
      savePreferencesBtn: 'Prijať aktuálny výber',
      closeIconLabel: 'Zatvoriť okno',
      sections: [
        {
          title: 'Nevyhnutné cookies',
          description:
            'Tieto cookies sú nevyhnutné pre správne fungovanie webovej stránky a nemožno ich deaktivovať. Ak sa zaregistrujete a prihlásite na stránku, použijeme cookie na zapamätanie, či ste prihlásení.',
          linkedCategory: 'necessary',
        },
        {
          title: 'Výkon a analytika',
          description:
            'Tieto cookies zhromažďujú informácie o tom, ako používate našu webovú stránku. Všetky údaje sú anonymizované a nemožno ich použiť na vašu identifikáciu.',
          linkedCategory: 'analytics',
        },
        {
          title: 'Viac informácií',
          description: `Pre akékoľvek otázky týkajúce sa našej politiky cookies a vašich možností, prosím ${contactLink(
            'kontaktujte nás',
          )}`,
        },
      ],
    },
  },
};

CookieConsent.run({
  categories: {
    necessary: { enabled: true, readOnly: true },
    analytics: { enabled: true },
  },
  language: {
    default: document.documentElement.lang === 'en' ? 'en' : 'sk',
    translations,
  },
});

// Turbo replaces <body> on every visit; carry the banner over to the new one.
document.addEventListener('turbo:before-render', (event) => {
  const banner = document.getElementById('cc-main');

  if (banner) event.detail.newBody.append(banner);
});
