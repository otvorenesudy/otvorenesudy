// Google Analytics counts a page view per Turbo visit. Its scripts in the layout are type="text/plain" until the
// visitor allows analytics cookies (cookie_consent.js), so gtag doesn't exist before that.
let visits = 0;

document.addEventListener('turbo:load', (event) => {
  visits += 1;

  // The gtag('config') call in the layout counts the first page itself.
  if (visits === 1 || typeof window.gtag !== 'function') return;

  window.gtag('event', 'page_view', {
    page_location: event.detail.url,
    page_title: document.title,
  });
});
