import { Controller } from '@hotwired/stimulus';

// A link that collapses or expands a section and says which it will do: "show more" becomes "show less".
export default class extends Controller {
  static values = { alternate: String };

  swap() {
    const current = this.element.innerHTML;

    this.element.innerHTML = this.alternateValue;
    this.alternateValue = current;
    this.element.blur();
  }
}
