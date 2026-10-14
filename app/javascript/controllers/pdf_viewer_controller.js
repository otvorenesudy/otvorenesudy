import { Controller } from '@hotwired/stimulus';

// A decree's document in pdf.js: page by page, with the words the decrees were searched for highlighted, and a search
// in the document regardless of case and diacritics. pdf.js loads only here, on first use.
export default class extends Controller {
  static targets = [
    'toolbar',
    'frame',
    'container',
    'viewer',
    'loading',
    'error',
    'pageNumber',
    'previousPage',
    'nextPage',
    'query',
    'clear',
    'matches',
    'matchCount',
    'help',
  ];

  static values = { url: String, worker: String, highlights: Array };

  async connect() {
    try {
      const pdfjs = await import('pdfjs-dist');
      globalThis.pdfjsLib = pdfjs;
      const { EventBus, PDFFindController, PDFLinkService, PDFViewer } = await import('pdfjs-dist/web/pdf_viewer');

      pdfjs.GlobalWorkerOptions.workerSrc = this.workerValue;

      this.eventBus = new EventBus();
      const linkService = new PDFLinkService({ eventBus: this.eventBus });
      const findController = new PDFFindController({ eventBus: this.eventBus, linkService });

      this.viewer = new PDFViewer({
        container: this.containerTarget,
        viewer: this.viewerTarget,
        eventBus: this.eventBus,
        linkService,
        findController,
      });
      linkService.setViewer(this.viewer);

      this.eventBus.on('pagesinit', () => {
        this.showPage(this.viewer.currentPageNumber);
        this.highlight();
      });
      this.eventBus.on('pagechanging', ({ pageNumber }) => this.showPage(pageNumber));
      this.eventBus.on('updatefindmatchescount', ({ matchesCount }) => this.showMatches(matchesCount));
      this.eventBus.on('updatefindcontrolstate', ({ matchesCount }) => this.showMatches(matchesCount));

      this.loadingTask = pdfjs.getDocument({ url: this.urlValue });
      const document = await this.loadingTask.promise;

      this.loadingTarget.hidden = true;
      this.viewer.setDocument(document);
      linkService.setDocument(document, null);
    } catch (error) {
      if (this.disconnected) return;

      console.error(error);
      this.fail();
    }
  }

  disconnect() {
    this.disconnected = true;
    this.loadingTask?.destroy();
  }

  previousPage() {
    if (this.viewer.currentPageNumber > 1) this.viewer.currentPageNumber -= 1;
  }

  nextPage() {
    if (this.viewer.currentPageNumber < this.viewer.pagesCount) this.viewer.currentPageNumber += 1;
  }

  search() {
    const searching = this.query !== '';

    this.clearTarget.hidden = !searching;
    this.matchesTarget.hidden = !searching;
    this.helpTarget.hidden = !searching;

    if (searching) {
      this.find({ query: this.query });
    } else {
      this.viewer.currentPageNumber = 1;
      this.highlight();
    }
  }

  // Enter moves to the next match, Shift + Enter to the previous one.
  navigate(event) {
    if (event.key !== 'Enter') return;

    event.preventDefault();
    this.findAgain(event.shiftKey);
  }

  previousMatch() {
    this.findAgain(true);
  }

  nextMatch() {
    this.findAgain(false);
  }

  clear() {
    this.queryTarget.value = '';
    this.search();
    this.queryTarget.focus();
  }

  get query() {
    return this.queryTarget.value.trim();
  }

  highlight() {
    this.find({ query: this.highlightsValue });
  }

  findAgain(previous) {
    if (this.query === '') return;

    this.find({ type: 'again', query: this.query, findPrevious: previous });
  }

  find(options) {
    this.eventBus?.dispatch('find', {
      source: this,
      type: '',
      caseSensitive: false,
      entireWord: false,
      highlightAll: true,
      findPrevious: false,
      matchDiacritics: false,
      ...options,
    });
  }

  showPage(pageNumber) {
    const { pagesCount } = this.viewer;

    this.pageNumberTarget.textContent = `${pageNumber} / ${pagesCount}`;
    this.previousPageTarget.disabled = pageNumber <= 1;
    this.nextPageTarget.disabled = pageNumber >= pagesCount;
  }

  showMatches({ current, total } = {}) {
    if (total === undefined) return;

    this.matchCountTarget.textContent = `${current} / ${total}`;
  }

  fail() {
    this.toolbarTarget.hidden = true;
    this.frameTarget.hidden = true;
    this.errorTarget.hidden = false;
  }
}
