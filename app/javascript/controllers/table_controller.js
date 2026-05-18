import { Controller } from '@hotwired/stimulus';

const SLOVAK_COLLATOR = new Intl.Collator('sk', { sensitivity: 'base' });

export default class extends Controller {
  connect() {
    this.element.querySelectorAll('th[data-sortable]').forEach((th) => {
      th.style.cursor = 'pointer';
      th.addEventListener('click', () => this.sortByColumn(th));
    });
  }

  sortByColumn(th) {
    const table = th.closest('table');
    const tbody = table.querySelector('tbody');
    const colIndex = Array.from(th.parentElement.children).indexOf(th);
    const rows = Array.from(tbody.querySelectorAll('tr'));
    const asc = th.dataset.sortDir !== 'asc';

    rows.sort((a, b) => {
      const aVal = a.children[colIndex]?.dataset.value ?? a.children[colIndex]?.textContent.trim() ?? '';
      const bVal = b.children[colIndex]?.dataset.value ?? b.children[colIndex]?.textContent.trim() ?? '';
      const result = SLOVAK_COLLATOR.compare(aVal, bVal);
      return asc ? result : -result;
    });

    th.dataset.sortDir = asc ? 'asc' : 'desc';
    rows.forEach((row) => tbody.appendChild(row));
  }
}
