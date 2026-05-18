import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { path: String, facet: String };

  connect() {
    this.element.addEventListener('input', this.suggest.bind(this));
    this.element.addEventListener('focus', this.suggest.bind(this));
  }

  suggest() {
    const term = this.element.value;
    const url = `${this.pathValue}?facet=${encodeURIComponent(this.facetValue)}&term=${encodeURIComponent(term)}`;
    const resultsEl = this.element.closest('.facet-content')?.querySelector('.facet-results');

    if (!resultsEl) return;

    fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
      .then((r) => r.text())
      .then((html) => {
        resultsEl.innerHTML = html;
      });
  }
}
