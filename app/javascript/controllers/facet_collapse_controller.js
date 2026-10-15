import { Controller } from '@hotwired/stimulus';

// Remembers in the session which facets the visitor folded, so they stay folded on the next page. The facet is busy
// (aria-busy) until the session has it; keepalive lets the request finish when the visitor leaves the page meanwhile.
export default class extends Controller {
  static values = { url: String, model: String, facet: String };

  expand(event) {
    if (event.target === this.element) this.save(false);
  }

  collapse(event) {
    if (event.target === this.element) this.save(true);
  }

  async save(collapsed) {
    const body = new FormData();
    body.append('model', this.modelValue);
    body.append('facet', this.facetValue);
    body.append('collapsed', collapsed);

    const token = document.querySelector('meta[name="csrf-token"]')?.content;

    this.element.setAttribute('aria-busy', 'true');

    try {
      await fetch(this.urlValue, { method: 'POST', body, headers: { 'X-CSRF-Token': token }, keepalive: true });
    } finally {
      this.element.removeAttribute('aria-busy');
    }
  }
}
