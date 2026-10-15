import { Controller } from '@hotwired/stimulus';

// Sorts the table by a column when its header is clicked, by the cells' data-value or text. Text compares regardless of
// diacritics and case (č with c), numbers numerically; each click on the same header reverses the order.
export default class extends Controller {
  sort(event) {
    const header = event.currentTarget;
    const index = Array.from(header.parentElement.children).indexOf(header);
    const descending = header.getAttribute('aria-sort') === 'ascending';
    const compare = event.params.type === 'digit' ? compareNumbers : compareTexts;
    const body = this.element.tBodies[0];

    const rows = Array.from(body.rows).sort((a, b) => compare(cellValue(a, index), cellValue(b, index)));
    if (descending) rows.reverse();

    body.append(...rows);

    this.element.querySelectorAll('th[aria-sort]').forEach((th) => th.removeAttribute('aria-sort'));
    header.setAttribute('aria-sort', descending ? 'descending' : 'ascending');
  }
}

const collator = new Intl.Collator('sk', { sensitivity: 'base', numeric: true });

function cellValue(row, index) {
  const cell = row.cells[index];

  return (cell?.dataset.value ?? cell?.textContent ?? '').trim();
}

function fold(text) {
  return text.normalize('NFD').replace(/\p{Mn}/gu, '');
}

function compareTexts(a, b) {
  return collator.compare(fold(a), fold(b));
}

function compareNumbers(a, b) {
  return (parseFloat(a) || 0) - (parseFloat(b) || 0);
}
