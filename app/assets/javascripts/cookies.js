window.addEventListener("load", function () {
  const language = document.documentElement.lang || "en";

  CookieConsent.run({
    categories: {
      necessary: {
        enabled: true,
        readOnly: true,
      },
      analytics: {
        enabled: true,
      },
    },

    language: {
      default: language,
      translations: {
        en: {
          consentModal: {
            title: "Cookies",
            description:
              "We use cookies to ensure you get the best experience on our website. Please choose your preferences.",
            acceptAllBtn: "Accept All",
            acceptNecessaryBtn: "Reject All",
            showPreferencesBtn: "Manage Individual Preferences",
          },
          preferencesModal: {
            title: "Manage Your Cookie Preferences",
            acceptAllBtn: "Accept All",
            acceptNecessaryBtn: "Reject All",
            savePreferencesBtn: "Accept Current Selection",
            closeIconLabel: "Close Modal",
            sections: [
              {
                title: "Strictly Necessary Cookies",
                description:
                  "These cookies are essential for the proper functioning of the website and cannot be disabled. If you register and log in to the site, we will use a cookie to remember if you are logged in.",

                linkedCategory: "necessary",
              },
              {
                title: "Performance and Analytics",
                description:
                  "These cookies collect information about how you use our website. All of the data is anonymized and cannot be used to identify you.",
                linkedCategory: "analytics",
              },
              {
                title: "More information",
                description:
                  'For any queries in relation to my policy on cookies and your choices, please <a href="/contact">contact us</a>',
              },
            ],
          },
        },

        sk: {
          consentModal: {
            title: "Cookies",
            description:
              "Používame cookies, aby sme zaistili, že na našej webovej stránke získate čo najlepší zážitok. Prosím, vyberte si svoje preferencie.",
            acceptAllBtn: "Prijať všetky",
            acceptNecessaryBtn: "Odmietnuť všetky",
            showPreferencesBtn: "Spravovať individuálne preferencie",
          },
          preferencesModal: {
            title: "Spravujte svoje preferencie cookies",
            acceptAllBtn: "Prijať všetky",
            acceptNecessaryBtn: "Odmietnuť všetky",
            savePreferencesBtn: "Prijať aktuálny výber",
            closeIconLabel: "Zatvoriť okno",
            sections: [
              {
                title: "Nevyhnutné cookies",
                description:
                  "Tieto cookies sú nevyhnutné pre správne fungovanie webovej stránky a nemožno ich deaktivovať. Ak sa zaregistrujete a prihlásite na stránku, použijeme cookie na zapamätanie, či ste prihlásení.",
                linkedCategory: "necessary",
              },
              {
                title: "Výkon a analytika",
                description:
                  "Tieto cookies zhromažďujú informácie o tom, ako používate našu webovú stránku. Všetky údaje sú anonymizované a nemožno ich použiť na vašu identifikáciu.",
                linkedCategory: "analytics",
              },
              {
                title: "Viac informácií",
                description:
                  'Pre akékoľvek otázky týkajúce sa mojej politiky cookies a vašich možností, prosím <a href="/contact">kontaktujte nás</a>',
              },
            ],
          },
        },
      },
    },
  });
});
