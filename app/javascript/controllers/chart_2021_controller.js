import { Controller } from '@hotwired/stimulus';
import Chart from 'chart.js/auto';

const COLORS = ['#f16c4f', '#00aeef', '#e19e41', '#73be1e', '#8392ac'];

export default class extends Controller {
  static values = { data: Object };

  connect() {
    const entries = Object.entries(this.dataValue);
    const labels = entries.map(([k]) => k);
    const values = entries.map(([, v]) => v);
    const backgroundColors = entries.map((_, i) => COLORS[i % COLORS.length]);

    const canvas = this.element.querySelector('.chart-canvas');
    if (!canvas) return;

    this.chart = new Chart(canvas, {
      type: 'polarArea',
      data: { labels, datasets: [{ data: values, backgroundColor: backgroundColors }] },
      options: {
        animation: false,
        responsive: true,
        scales: { r: { display: false } },
        plugins: { legend: { display: false } },
      },
    });

    const legendEl = this.element.querySelector('.chart-legend');
    if (legendEl) {
      legendEl.innerHTML = `<ul class="list-inline mt-4">${labels.map((l, i) => `<li class="list-inline-item"><span class="d-inline-block align-top mr-2 my-1" style="width:16px;height:16px;background:${backgroundColors[i]}"></span>${l}</li>`).join('')}</ul>`;
    }
  }

  disconnect() {
    this.chart?.destroy();
  }
}
