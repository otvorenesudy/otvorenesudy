import { Controller } from '@hotwired/stimulus';
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);

const GRID_COLOR = '#d1dee8';
const LABEL_FONT = { family: 'Ubuntu', weight: 300, size: 12.8 };

// Draws a judge's indicators: a radar of scores from 0 to 10 per series (the average, the judge, the judges compared)
// or a polar area of one judge's scores. Each series takes the color of its swatch in the legend (CSS), in order.
export default class extends Controller {
  static targets = ['canvas', 'swatch'];
  static values = { type: String, labels: Array, series: Array };

  connect() {
    const colors = this.swatchTargets.map((swatch) => getComputedStyle(swatch).backgroundColor);
    const config = this.typeValue === 'polarArea' ? this.polarArea(colors) : this.radar(colors);

    this.chart = new Chart(this.canvasTarget, config);
    this.canvasTarget.dataset.indicatorsChartDrawn = '';
  }

  disconnect() {
    this.chart?.destroy();
    delete this.canvasTarget.dataset.indicatorsChartDrawn;
  }

  radar(colors) {
    const datasets = this.seriesValue.map(({ label, data }, index) => ({
      label,
      data,
      borderColor: colors[index],
      backgroundColor: 'transparent',
      pointRadius: 0,
    }));

    return {
      type: 'radar',
      data: { labels: this.labelsValue, datasets },
      options: {
        ...this.options(),
        scales: {
          r: {
            min: 0,
            max: 10,
            ticks: { display: false, stepSize: 1 },
            angleLines: { color: GRID_COLOR },
            grid: { color: GRID_COLOR },
            pointLabels: { color: '#1b325f', font: LABEL_FONT },
          },
        },
      },
    };
  }

  polarArea(colors) {
    const [{ data }] = this.seriesValue;

    return {
      type: 'polarArea',
      data: { labels: this.labelsValue, datasets: [{ data, backgroundColor: colors }] },
      options: { ...this.options(), scales: { r: { ticks: { display: false }, grid: { color: GRID_COLOR } } } },
    };
  }

  options() {
    return {
      animation: false,
      responsive: true,
      maintainAspectRatio: true,
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
    };
  }
}
