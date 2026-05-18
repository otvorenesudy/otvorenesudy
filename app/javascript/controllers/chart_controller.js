import { Controller } from '@hotwired/stimulus';
import Chart from 'chart.js/auto';

const DATASETS_BY_YEAR = {
  2013: {
    labels: [
      'Počet reštančných',
      'Vybavenosť',
      'Kapacita vybavovať',
      'Reštančné z nevybavených',
      'Počet nevybavených',
      'Frekvencia odvolaní',
      'Potvrdené rozhodnutia',
      'Zmenené alebo zrušené z celku',
    ],
    datasets: [
      { label: 'Maximum', borderColor: 'transparent', backgroundColor: 'transparent', data: [10, 10, 10, 10, 10, 10, 10, 10] },
      { label: 'Priemer', borderColor: '#8392ac', backgroundColor: 'transparent', data: [] },
    ],
  },
  2015: {
    labels: ['Vybavenosť', 'Reštančné z nevybavených', 'Kapacita vybavovať', 'Potvrdené rozhodnutia'],
    datasets: [
      { label: 'Maximum', borderColor: 'transparent', backgroundColor: 'transparent', data: [10, 10, 10, 10] },
      { label: 'Priemer', borderColor: '#8392ac', backgroundColor: 'transparent', data: [] },
    ],
  },
  2017: {
    labels: ['Vybavenosť', 'Reštančné z nevybavených', 'Kapacita vybavovať', 'Potvrdené rozhodnutia'],
    datasets: [
      { label: 'Maximum', borderColor: 'transparent', backgroundColor: 'transparent', data: [10, 10, 10, 10] },
      { label: 'Priemer', borderColor: '#8392ac', backgroundColor: 'transparent', data: [] },
    ],
  },
};

export default class extends Controller {
  static values = { year: Number, average: Array, judges: Array };

  connect() {
    const year = this.yearValue;
    const config = structuredClone(DATASETS_BY_YEAR[year]);

    if (!config) return;

    config.datasets[1].data = this.averageValue;

    this.judgesValue.forEach(({ label, data, color }) => {
      config.datasets.push({ label, borderColor: color, backgroundColor: 'transparent', data });
    });

    const canvas = this.element.querySelector('.chart-canvas');
    if (!canvas) return;

    this.chart = new Chart(canvas, {
      type: 'radar',
      data: config,
      options: {
        animation: false,
        responsive: true,
        plugins: { legend: { display: false } },
        elements: { point: { radius: 0 } },
        scales: {
          r: {
            angleLines: { color: '#d1dee8' },
            grid: { color: '#d1dee8' },
            pointLabels: { color: '#1b325f', font: { family: 'Ubuntu', size: 12.8, weight: '300' } },
          },
        },
      },
    });

    const legendEl = this.element.querySelector('.chart-legend');
    if (legendEl) {
      legendEl.innerHTML = config.datasets
        .slice(1)
        .map(
          (ds) =>
            `<li class="facet-item"><span class="d-inline-block align-top mr-2 my-1" style="width:16px;height:16px;background:${ds.borderColor}"></span>${ds.label}</li>`
        )
        .join('');
    }
  }

  disconnect() {
    this.chart?.destroy();
  }
}
