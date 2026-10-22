import { Controller } from '@hotwired/stimulus';
import { Tab } from 'bootstrap';

// Tabs that keep the open tab in the URL: the address's hash opens its tab, and opening a tab updates the hash.
export default class extends Controller {
  connect() {
    const { hash } = window.location;
    const link = hash && [...this.element.querySelectorAll('[data-bs-toggle="tab"]')].find((tab) => tab.hash === hash);

    if (link) Tab.getOrCreateInstance(link).show();
  }

  shown(event) {
    history.replaceState(history.state, '', event.target.getAttribute('href'));
  }
}
