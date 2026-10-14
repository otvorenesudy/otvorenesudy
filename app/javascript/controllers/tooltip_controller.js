import { Controller } from '@hotwired/stimulus';
import { Tooltip } from 'bootstrap';

// A Bootstrap tooltip (title attribute, HTML allowed) on the element; tooltip_tag renders it.
export default class extends Controller {
  connect() {
    this.tooltip = new Tooltip(this.element, { html: true, container: 'body' });
  }

  disconnect() {
    this.tooltip.dispose();
  }

  prevent(event) {
    event.preventDefault();
  }
}
