import { Controller } from '@hotwired/stimulus';
import { Popover } from 'bootstrap';

// A Bootstrap popover (data-bs-content, HTML allowed) on the element; popover_tag and help_tag render it.
export default class extends Controller {
  connect() {
    this.popover = new Popover(this.element, { html: true, container: 'body' });
  }

  disconnect() {
    this.popover.dispose();
  }

  prevent(event) {
    event.preventDefault();
  }
}
