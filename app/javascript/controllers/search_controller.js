import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['facetTitle'];

  connect() {
    this.model = this.element.dataset.model;
  }

  collapseToggle(event) {
    const facetEl = event.currentTarget.closest('.facet');
    const name = facetEl.dataset.id;
    const collapsed = !event.currentTarget.classList.contains('collapsed');
    const url = `/search/collapse?model=${encodeURIComponent(this.model)}&facet=${encodeURIComponent(name)}&collapsed=${collapsed}`;

    fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
  }
}
