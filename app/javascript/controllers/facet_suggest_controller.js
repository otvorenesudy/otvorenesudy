import { Controller } from '@hotwired/stimulus';

// Narrows a facet to the values containing what the visitor types: after a pause in typing it fetches the facet's
// values (an HTML fragment) and replaces the listed ones. A newer request cancels an older one still under way.
export default class extends Controller {
  static targets = ['input', 'results'];
  static values = { url: String, delay: { type: Number, default: 300 } };

  disconnect() {
    clearTimeout(this.timeout);
    this.request?.abort();
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => this.load(), this.delayValue);
  }

  async load() {
    this.request?.abort();
    this.request = new AbortController();

    const url = new URL(this.urlValue, window.location.origin);
    url.searchParams.set('term', this.inputTarget.value);
    this.resultsTarget.setAttribute('aria-busy', 'true');

    try {
      const response = await fetch(url, { signal: this.request.signal, headers: { Accept: 'text/html' } });

      if (response.ok) this.resultsTarget.innerHTML = await response.text();
    } catch (error) {
      if (error.name !== 'AbortError') throw error;
    } finally {
      this.resultsTarget.removeAttribute('aria-busy');
    }
  }
}
