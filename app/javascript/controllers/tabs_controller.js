import { Controller } from '@hotwired/stimulus';
import { Tab } from 'bootstrap';

// Tabs that keep the open tab in the URL: the address's hash opens its tab, and opening a tab updates the hash.
export default class extends Controller {
  connect() {
    const link =
      window.location.hash && this.element.querySelector(`[data-bs-toggle="tab"][href="${window.location.hash}"]`);

    if (link) Tab.getOrCreateInstance(link).show();
  }

  shown(event) {
    event.target.setAttribute('tabindex', -1);

    history.replaceState(history.state, '', event.target.getAttribute('href'));
  }

  hidden(event) {
    event.target.removeAttribute('tabindex');
  }
}
