import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    if (window.location.hash) {
      const tab = this.element.querySelector(`a[data-toggle="tab"][href="${window.location.hash}"]`);
      if (tab) tab.click();
    }

    this.element.addEventListener('shown.bs.tab', (e) => {
      e.target.setAttribute('tabindex', '-1');
      history.replaceState(null, null, e.target.getAttribute('href'));
    });

    this.element.addEventListener('hidden.bs.tab', (e) => {
      e.target.removeAttribute('tabindex');
    });
  }
}
