import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.fixLinks();
    document.addEventListener('turbo:render', this.fixLinks.bind(this));
  }

  disconnect() {
    document.removeEventListener('turbo:render', this.fixLinks.bind(this));
  }

  fixLinks() {
    this.element.querySelectorAll('a[href^="http"]').forEach((a) => {
      a.setAttribute('target', '_blank');
      a.setAttribute('rel', 'noopener noreferrer');
    });

    this.element.querySelectorAll('a[href="#"]').forEach((a) => {
      a.addEventListener('click', (e) => e.preventDefault());
    });

    this.element.querySelectorAll('a[data-toggle="collapse"]').forEach((a) => {
      a.addEventListener('click', () => a.blur());
    });

    this.element.querySelectorAll('a[data-toggle="collapse"][data-content]').forEach((a) => {
      a.addEventListener('click', () => {
        const content = a.dataset.content;
        a.dataset.content = a.innerHTML;
        a.innerHTML = content;
      });
    });
  }
}
