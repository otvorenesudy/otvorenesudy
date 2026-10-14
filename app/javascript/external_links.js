// Links to other sites open in a new tab, without giving that tab access to this one.
document.addEventListener('turbo:load', () => {
  document.querySelectorAll('a[href^="http"]').forEach((link) => {
    if (link.host === window.location.host) return;

    link.target = '_blank';
    link.rel = 'noopener';
  });
});
