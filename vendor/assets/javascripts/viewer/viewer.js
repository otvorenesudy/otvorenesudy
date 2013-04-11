/* -*- Mode: Java; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set shiftwidth=2 tabstop=2 autoindent cindent expandtab: */
/* Copyright 2012 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

var kDefaultScale = 'auto';
var kDefaultScaleDelta = 1.1;
var kUnknownScale = 0;
var kCacheSize = 20;
var kCssUnits = 96.0 / 72.0;
var kScrollbarPadding = 40;
var kMinScale = 0.25;
var kMaxScale = 4.0;
var kImageDirectory = './images/';
var kSettingsMemory = 20;
var RenderingStates = {
  INITIAL: 0,
  RUNNING: 1,
  PAUSED: 2,
  FINISHED: 3
};

  // !NOTE: PDF.JS is able to use a background "Web Worker"
  // to crunch some numbers. We are disabling this functionality
  // for the moment because pdf.js will be compiled with other
  // application assets in the Asset Pipeline.
  //
  // It wouldn't be too much trouble to reenable it. We may
  // revisit that later.
  //
  PDFJS.disableWorker = true;
  // PDFJS.workerSrc = '/assets/pdf.js';

var mozL10n = document.mozL10n || document.webL10n;

function getFileName(url) {
  var anchor = url.indexOf('#');
  var query = url.indexOf('?');
  var end = Math.min(
    anchor > 0 ? anchor : url.length,
    query > 0 ? query : url.length);
  return url.substring(url.lastIndexOf('/', end) + 1, end);
}

function scrollIntoView(element, spot) {
  var parent = element.offsetParent,
      offsetY = element.offsetTop;
  
  if(!parent) return;
  
  while (parent.clientHeight == parent.scrollHeight) {
    offsetY += parent.offsetTop;
    parent = parent.offsetParent;
    
    if(!parent) return; // no need to scroll
  }
  if (spot)
    offsetY += spot.top;
  parent.scrollTop = offsetY;
}





var cache = new Cache(kCacheSize);
var currentPageNumber = 1;

var PDFView = {
  pages: [],
  thumbnails: [],
  currentScale: kUnknownScale,
  currentScaleValue: null,
  initialBookmark: document.location.hash.substring(1),
  startedTextExtraction: false,
  pageText: [],
  container: null,
  thumbnailContainer: null,
  initialized: false,
  fellback: false,
  pdfDocument: null,
  sidebarOpen: false,
  pageViewScroll: null,
  thumbnailViewScroll: null,
  isFullscreen: false,
  previousScale: null,
  pageRotation: 0,

  // called once when the document is loaded
  initialize: function pdfViewInitialize() {
    var container = this.container = document.getElementById('viewerContainer');
    this.pageViewScroll = {};
    this.watchScroll(container, this.pageViewScroll, function() {
      updateViewarea();
    });
    
    this.thumbnailContainer = document.getElementById('thumbnailView');
    this.thumbnailViewScroll = {};
    if(this.thumbnailContainer) {
      this.watchScroll(this.thumbnailContainer, this.thumbnailViewScroll,
                       this.renderHighestPriority.bind(this));
    }
    
    this.initialized = true;
  },
  
  // Helper function to keep track whether a div was scrolled up or down and
  // then call a callback.
  watchScroll: function pdfViewWatchScroll(viewAreaElement, state, callback) {
    state.down = true;
    state.lastY = viewAreaElement.scrollTop;
    viewAreaElement.addEventListener('scroll', function webViewerScroll(evt) {
      var currentY = viewAreaElement.scrollTop;
      var lastY = state.lastY;
      if (currentY > lastY)
        state.down = true;
      else if (currentY < lastY)
        state.down = false;
      // else do nothing and use previous value
      state.lastY = currentY;
      callback();
    }, true);
  },
  
  setScale: function pdfViewSetScale(val, resetAutoSettings, noScroll) {
    if (val == this.currentScale)
      return;
    
    var pages = this.pages;
    for (var i = 0; i < pages.length; i++)
      pages[i].update(val * kCssUnits);
    
    if (!noScroll && this.currentScale != val)
      this.pages[this.page - 1].scrollIntoView();
    this.currentScale = val;
    
    var event = document.createEvent('UIEvents');
    event.initUIEvent('scalechange', false, false, window, 0);
    event.scale = val;
    event.resetAutoSettings = resetAutoSettings;
    window.dispatchEvent(event);
  },
  
  parseScale: function pdfViewParseScale(value, resetAutoSettings, noScroll) {
    if('custom' == value) return;
    
    var scale = parseFloat(value);
    this.currentScaleValue = value;
    if (scale) {
      this.setScale(scale, true, noScroll);
      return;
    }
    
    var container = this.container;
    var currentPage = this.pages[this.page - 1];
    
    var pageWidthScale = (container.clientWidth - kScrollbarPadding) /
                          currentPage.width * currentPage.scale / kCssUnits;
    var pageHeightScale = (container.clientHeight - kScrollbarPadding) /
                           currentPage.height * currentPage.scale / kCssUnits;
    switch (value) {
      case 'page-actual':
        scale = 1;
        break;
      case 'page-width':
        scale = pageWidthScale;
        break;
      case 'page-height':
        scale = pageHeightScale;
        break;
      case 'page-fit':
        scale = Math.min(pageWidthScale, pageHeightScale);
        break;
      case 'auto':
        scale = Math.min(1.0, pageWidthScale);
        break;
    }
    this.setScale(scale, resetAutoSettings, noScroll);
    
    selectScaleOption(value);
  },
  
  zoomIn: function pdfViewZoomIn() {
    var newScale = (this.currentScale * kDefaultScaleDelta).toFixed(2);
    newScale = Math.min(kMaxScale, newScale);
    this.parseScale(newScale, true);
  },
  
  zoomOut: function pdfViewZoomOut() {
    var newScale = (this.currentScale / kDefaultScaleDelta).toFixed(2);
    newScale = Math.max(kMinScale, newScale);
    this.parseScale(newScale, true);
  },
  
  set page(val) {
    var pages = this.pages;
    var input = document.getElementById('pageNumber');
    var event = document.createEvent('UIEvents');
    event.initUIEvent('pagechange', false, false, window, 0);
    
    if (!(0 < val && val <= pages.length)) {
      event.pageNumber = this.page;
      window.dispatchEvent(event);
      return;
    }
    
    pages[val - 1].updateStats();
    currentPageNumber = val;
    event.pageNumber = val;
    window.dispatchEvent(event);
    
    // checking if the this.page was called from the updateViewarea function:
    // avoiding the creation of two "set page" method (internal and public)
    if (updateViewarea.inProgress) return;
    
    // Avoid scrolling the first page during loading
    if (this.loading && val == 1) return;
    
    pages[val - 1].scrollIntoView();
  },
  
  get page() {
    return currentPageNumber;
  },
  
  get supportsPrinting() {
    var canvas = document.createElement('canvas');
    var value = 'mozPrintCallback' in canvas;
    // shadow
    Object.defineProperty(this, 'supportsPrinting', { value: value,
                                                      enumerable: true,
                                                      configurable: true,
                                                      writable: false });
    return value;
  },
  
  get supportsFullscreen() {
    var doc = document.documentElement;
    var support = doc.requestFullScreen || doc.mozRequestFullScreen ||
                  doc.webkitRequestFullScreen;
    Object.defineProperty(this, 'supportsFullScreen', { value: support,
                                                        enumerable: true,
                                                        configurable: true,
                                                        writable: false });
    return support;
  },
  
  initPassiveLoading: function pdfViewInitPassiveLoading() {
    if (!PDFView.loadingBar) {
      PDFView.loadingBar = new ProgressBar('#loadingBar', {});
    }
    
    window.addEventListener('message', function window_message(e) {
      var args = e.data;
      
      if (typeof args !== 'object' || !('pdfjsLoadAction' in args))
        return;
      switch (args.pdfjsLoadAction) {
        case 'progress':
          PDFView.progress(args.loaded / args.total);
          break;
        case 'complete':
          if (!args.data) {
            PDFView.error(mozL10n.get('loading_error', null,
                          'An error occurred while loading the PDF.'), e);
            break;
          }
          PDFView.open(args.data, 0);
          break;
      }
    });
    FirefoxCom.requestSync('initPassiveLoading', null);
  },
  
  setUrl: function pdfViewSetTitleUsingUrl(url) {
    this.url = url;
    // try {
    //       document.title = decodeURIComponent(getFileName(url)) || url;
    //     } catch (e) {
    //       // decodeURIComponent may throw URIError,
    //       // fall back to using the unprocessed url in that case
    //       document.title = url;
    //     }
  },
  
  open: function pdfViewOpen(url, options) {
    if(PDFView.webViewerLoad) {
      PDFView.webViewerLoad();
      PDFView.webViewerLoad = null;
    }
    
    var _ref;
    options = options || {};
    var scale = (_ref = options.scale) != null ? _ref : 0;
    this.useHotkeys = (_ref = options.useHotkeys) != null ? _ref : true;
    this.rememberViewState = (_ref = options.rememberViewState) != null ? _ref : true;
    
    var parameters = {password: options.password};
    if (typeof url === 'string') { // URL
      this.setUrl(url);
      parameters.url = url;
    } else if (url && 'byteLength' in url) { // ArrayBuffer
      parameters.data = url;
    }
    
    if (!PDFView.loadingBar) {
      PDFView.loadingBar = new ProgressBar('#loadingBar', {});
    }
    
    this.pdfDocument = null;
    var self = this;
    self.loading = true;
    PDFJS.getDocument(parameters).then(
      function getDocumentCallback(pdfDocument) {
        self.load(pdfDocument, scale);
        self.loading = false;
      },
      function getDocumentError(message, exception) {
        if (exception && exception.name === 'PasswordException') {
          if (exception.code === 'needpassword') {
            var promptString = mozL10n.get('request_password', null,
                                      'PDF is protected by a password:');
            password = prompt(promptString);
            if (password && password.length > 0) {
              return PDFView.open(url, scale, password);
            }
          }
        }

        var loadingIndicator = document.getElementById('loading');
        loadingIndicator.textContent = mozL10n.get('loading_error_indicator',
          null, 'Error');
        var moreInfo = {
          message: message
        };
        self.error(mozL10n.get('loading_error', null,
          'An error occurred while loading the PDF.'), moreInfo);
        self.loading = false;
      },
      function getDocumentProgress(progressData) {
        self.progress(progressData.loaded / progressData.total);
      }
    );
    
    return this;
  },
  
  download: function pdfViewDownload() {
    function noData() {
      FirefoxCom.request('download', { originalUrl: url });
    }
    
    var url = this.url.split('#')[0];
    url += '#pdfjs.action=download';
    window.open(url, '_parent');
  },
  
  fallback: function pdfViewFallback() {
    return;
  },
  
  navigateTo: function pdfViewNavigateTo(dest) {
    if (typeof dest === 'string')
      dest = this.destinations[dest];
    if (!(dest instanceof Array))
      return; // invalid destination
    // dest array looks like that: <page-ref> </XYZ|FitXXX> <args..>
    var destRef = dest[0];
    var pageNumber = destRef instanceof Object ?
      this.pagesRefMap[destRef.num + ' ' + destRef.gen + ' R'] : (destRef + 1);
    if (pageNumber > this.pages.length)
      pageNumber = this.pages.length;
    if (pageNumber) {
      this.page = pageNumber;
      var currentPage = this.pages[pageNumber - 1];
      currentPage.scrollIntoView(dest);
    }
  },

  getDestinationHash: function pdfViewGetDestinationHash(dest) {
    if (typeof dest === 'string')
      return PDFView.getAnchorUrl('#' + escape(dest));
    if (dest instanceof Array) {
      var destRef = dest[0]; // see navigateTo method for dest format
      var pageNumber = destRef instanceof Object ?
        this.pagesRefMap[destRef.num + ' ' + destRef.gen + ' R'] :
        (destRef + 1);
      if (pageNumber) {
        var pdfOpenParams = PDFView.getAnchorUrl('#page=' + pageNumber);
        var destKind = dest[1];
        if (typeof destKind === 'object' && 'name' in destKind &&
            destKind.name == 'XYZ') {
          var scale = (dest[4] || this.currentScale);
          pdfOpenParams += '&zoom=' + (scale * 100);
          if (dest[2] || dest[3]) {
            pdfOpenParams += ',' + (dest[2] || 0) + ',' + (dest[3] || 0);
          }
        }
        return pdfOpenParams;
      }
    }
    return '';
  },

  /**
   * For the firefox extension we prefix the full url on anchor links so they
   * don't come up as resource:// urls and so open in new tab/window works.
   * @param {String} anchor The anchor hash include the #.
   */
  getAnchorUrl: function getAnchorUrl(anchor) {
    return anchor;
  },

  /**
   * Show the error box.
   * @param {String} message A message that is human readable.
   * @param {Object} moreInfo (optional) Further information about the error
   *                            that is more technical.  Should have a 'message'
   *                            and optionally a 'stack' property.
   */
  error: function pdfViewError(message, moreInfo) {
    var moreInfoText = mozL10n.get('error_build', {build: PDFJS.build},
      'PDF.JS Build: {{build}}') + '\n';
    if (moreInfo) {
      moreInfoText +=
        mozL10n.get('error_message', {message: moreInfo.message},
        'Message: {{message}}');
      if (moreInfo.stack) {
        moreInfoText += '\n' +
          mozL10n.get('error_stack', {stack: moreInfo.stack},
          'Stack: {{stack}}');
      } else {
        if (moreInfo.filename) {
          moreInfoText += '\n' +
            mozL10n.get('error_file', {file: moreInfo.filename},
            'File: {{file}}');
        }
        if (moreInfo.lineNumber) {
          moreInfoText += '\n' +
            mozL10n.get('error_line', {line: moreInfo.lineNumber},
            'Line: {{line}}');
        }
      }
    }
    
    var loadingBox = document.getElementById('loadingBox');
    if(loadingBox) loadingBox.setAttribute('hidden', 'true');
    
    var errorWrapper = document.getElementById('errorWrapper');
    if(errorWrapper) errorWrapper.removeAttribute('hidden');
    
    var errorMessage = document.getElementById('errorMessage');
    if(errorMessage) errorMessage.textContent = message;
    
    var closeButton = document.getElementById('errorClose');
    if(closeButton) {
      closeButton.onclick = function() {
        errorWrapper.setAttribute('hidden', 'true');
      };
    }
    
    var errorMoreInfo = document.getElementById('errorMoreInfo');
    var moreInfoButton = document.getElementById('errorShowMore');
    var lessInfoButton = document.getElementById('errorShowLess');
    if(errorMoreInfo && moreInfoButton && lessInfoButton) {
      moreInfoButton.onclick = function() {
        errorMoreInfo.removeAttribute('hidden');
        moreInfoButton.setAttribute('hidden', 'true');
        lessInfoButton.removeAttribute('hidden');
      };
      lessInfoButton.onclick = function() {
        errorMoreInfo.setAttribute('hidden', 'true');
        moreInfoButton.removeAttribute('hidden');
        lessInfoButton.setAttribute('hidden', 'true');
      };
      moreInfoButton.removeAttribute('hidden');
      lessInfoButton.setAttribute('hidden', 'true');
      errorMoreInfo.value = moreInfoText;
      
      errorMoreInfo.rows = moreInfoText.split('\n').length - 1;
    }
  },

  progress: function pdfViewProgress(level) {
    var percent = Math.round(level * 100);
    PDFView.loadingBar.percent = percent;
  },

  load: function pdfViewLoad(pdfDocument, scale) {
    this.pdfDocument = pdfDocument;
    
    var errorWrapper = document.getElementById('errorWrapper');
    errorWrapper.setAttribute('hidden', 'true');
    
    var loadingBox = document.getElementById('loadingBox');
    loadingBox.setAttribute('hidden', 'true');
    var loadingIndicator = document.getElementById('loading');
    loadingIndicator.textContent = '';
    
    var thumbsView = document.getElementById('thumbnailView');
    if(thumbsView) {
      thumbsView.parentNode.scrollTop = 0;
      
      while (thumbsView.hasChildNodes())
        thumbsView.removeChild(thumbsView.lastChild);
      
      if ('_loadingInterval' in thumbsView)
        clearInterval(thumbsView._loadingInterval);
    }

    var container = document.getElementById('viewer');
    while (container.hasChildNodes())
      container.removeChild(container.lastChild);
    
    var pagesCount = pdfDocument.numPages;
    var id = pdfDocument.fingerprint;
    var storedHash = null;
    
    var numPagesInput = document.getElementById('numPages');
    if(numPagesInput) {
      numPagesInput.textContent = mozL10n.get('page_of', {pageCount: pagesCount}, 'of {{pageCount}}');
    }
    
    var pageNumberInput = document.getElementById('pageNumber');
    if(pageNumberInput) pageNumberInput.max = pagesCount;
    
    PDFView.documentFingerprint = id;
    var store = PDFView.store = new Settings(id);
    if (store.get('exists', false)) {
      var page = store.get('page', '1');
      var zoom = store.get('zoom', PDFView.currentScale);
      var left = store.get('scrollLeft', '0');
      var top = store.get('scrollTop', '0');
      
      storedHash = 'page=' + page + '&zoom=' + zoom + ',' + left + ',' + top;
    }
    
    this.pageRotation = 0;
    
    var pages = this.pages = [];
    this.pageText = [];
    this.startedTextExtraction = false;
    var pagesRefMap = {};
    var thumbnails = this.thumbnails = [];
    
    var pagePromises = [];
    for(var i = 1; i <= pagesCount; i++)
      pagePromises.push(pdfDocument.getPage(i));
    
    var self = this;
    var pagesPromise = PDFJS.Promise.all(pagePromises);
    pagesPromise.then(function(promisedPages) {
      for (var i = 1; i <= pagesCount; i++) {
        var page = promisedPages[i - 1];
        var pageView = new PageView(container, page, i, scale, page.stats, self.navigateTo.bind(self));
        
        if(thumbsView) {
          var thumbnailView = new ThumbnailView(thumbsView, page, i);
          thumbnailView.bindOnAfterDraw(pageView);
          thumbnails.push(thumbnailView);
        }
        
        pages.push(pageView);
        var pageRef = page.ref;
        pagesRefMap[pageRef.num + ' ' + pageRef.gen + ' R'] = i;
      }
      
      self.pagesRefMap = pagesRefMap;
    });
    
    var destinationsPromise = pdfDocument.getDestinations();
    destinationsPromise.then(function(destinations) {
      self.destinations = destinations;
    });
    
    // outline and initial view depends on destinations and pagesRefMap
    var outlineView = document.getElementById('outlineView');
    
    PDFJS.Promise.all([pagesPromise, destinationsPromise]).then(function() {
      if(outlineView) {
        pdfDocument.getOutline().then(function(outline) {
          self.outline = new DocumentOutlineView(outlineView, outline);
        });
      }
      
      self.setInitialView(storedHash, scale);
    });
    
    pdfDocument.getMetadata().then(function(data) {
      var info = data.info, metadata = data.metadata;
      self.documentInfo = info;
      self.metadata = metadata;
      
      var pdfTitle;
      if (metadata) {
        if (metadata.has('dc:title'))
          pdfTitle = metadata.get('dc:title');
      }
      
      if (!pdfTitle && info && info['Title'])
        pdfTitle = info['Title'];
    });
  },
  
  setInitialView: function pdfViewSetInitialView(storedHash, scale) {
    // Reset the current scale, as otherwise the page's scale might not get
    // updated if the zoom level stayed the same.
    this.currentScale = 0;
    this.currentScaleValue = null;
    if(this.initialBookmark) {
      if(window.console && window.console.log) window.console.log('[setInitialView] setBookmark: ' + this.initialBookmark);
      this.setHash(this.initialBookmark);
      this.initialBookmark = null;
    }
    else if(storedHash && this.rememberViewState) {
      if(window.console && window.console.log) window.console.log('[setInitialView] setHash: ' + storedHash);
      this.setHash(storedHash);
    }
    else if(scale) {
      if(window.console && window.console.log) window.console.log('[setInitialView] parseScale: ' + scale);
      this.parseScale(scale, true);
      this.page = 1;
    }
    
    if (PDFView.currentScale === kUnknownScale) {
      // Scale was not initialized: invalid bookmark or scale was not specified.
      // Setting the default one.
      if(window.console && window.console.log) window.console.log('[setInitialView] parseScale (default: ' + kDefaultScale + ')');
      this.parseScale(kDefaultScale, true);
    }
  },
  
  renderHighestPriority: function pdfViewRenderHighestPriority() {
    // Pages have a higher priority than thumbnails, so check them first.
    var visiblePages = this.getVisiblePages();
    var pageView = this.getHighestPriority(visiblePages, this.pages,
                                           this.pageViewScroll.down);
    if (pageView) {
      this.renderView(pageView, 'page');
      return;
    }
    // No pages needed rendering so check thumbnails.
    if (this.sidebarOpen) {
      var visibleThumbs = this.getVisibleThumbs();
      var thumbView = this.getHighestPriority(visibleThumbs,
                                              this.thumbnails,
                                              this.thumbnailViewScroll.down);
      if (thumbView)
        this.renderView(thumbView, 'thumbnail');
    }
  },
  
  getHighestPriority: function pdfViewGetHighestPriority(visible, views,
                                                         scrolledDown) {
    // The state has changed figure out which page has the highest priority to
    // render next (if any).
    // Priority:
    // 1 visible pages
    // 2 if last scrolled down page after the visible pages
    // 2 if last scrolled up page before the visible pages
    var visibleViews = visible.views;
    
    var numVisible = visibleViews.length;
    if (numVisible === 0) {
      return false;
    }
    for (var i = 0; i < numVisible; ++i) {
      var view = visibleViews[i].view;
      if (!this.isViewFinished(view))
        return view;
    }
    
    // All the visible views have rendered, try to render next/previous pages.
    if (scrolledDown) {
      var nextPageIndex = visible.last.id;
      // ID's start at 1 so no need to add 1.
      if (views[nextPageIndex] && !this.isViewFinished(views[nextPageIndex]))
        return views[nextPageIndex];
    } else {
      var previousPageIndex = visible.first.id - 2;
      if (views[previousPageIndex] &&
          !this.isViewFinished(views[previousPageIndex]))
        return views[previousPageIndex];
    }
    // Everything that needs to be rendered has been.
    return false;
  },
  
  isViewFinished: function pdfViewNeedsRendering(view) {
    return view.renderingState === RenderingStates.FINISHED;
  },

  // Render a page or thumbnail view. This calls the appropriate function based
  // on the views state. If the view is already rendered it will return false.
  renderView: function pdfViewRender(view, type) {
    var state = view.renderingState;
    switch (state) {
      case RenderingStates.FINISHED:
        return false;
      case RenderingStates.PAUSED:
        PDFView.highestPriorityPage = type + view.id;
        view.resume();
        break;
      case RenderingStates.RUNNING:
        PDFView.highestPriorityPage = type + view.id;
        break;
      case RenderingStates.INITIAL:
        PDFView.highestPriorityPage = type + view.id;
        view.draw(this.renderHighestPriority.bind(this));
        break;
    }
    return true;
  },
  
  search: function pdfViewStartSearch() {
    // Limit this function to run every <SEARCH_TIMEOUT>ms.
    var SEARCH_TIMEOUT = 250;
    var lastSearch = this.lastSearch;
    var now = Date.now();
    if (lastSearch && (now - lastSearch) < SEARCH_TIMEOUT) {
      if (!this.searchTimer) {
        this.searchTimer = setTimeout(function resumeSearch() {
            PDFView.search();
          },
          SEARCH_TIMEOUT - (now - lastSearch)
        );
      }
      return;
    }
    this.searchTimer = null;
    this.lastSearch = now;
    
    function bindLink(link, pageNumber) {
      link.href = '#' + pageNumber;
      link.onclick = function searchBindLink() {
        PDFView.page = pageNumber;
        return false;
      };
    }
    
    var searchResults = document.getElementById('searchResults');
    
    var searchTermsInput = document.getElementById('searchTermsInput');
    searchResults.removeAttribute('hidden');
    searchResults.textContent = '';
    
    var terms = searchTermsInput.value;
    
    if (!terms)
      return;
    
    // simple search: removing spaces and hyphens, then scanning every
    terms = terms.replace(/\s-/g, '').toLowerCase();
    var index = PDFView.pageText;
    var pageFound = false;
    for (var i = 0, ii = index.length; i < ii; i++) {
      var pageText = index[i].replace(/\s-/g, '').toLowerCase();
      var j = pageText.indexOf(terms);
      if (j < 0)
        continue;

      var pageNumber = i + 1;
      var textSample = index[i].substr(j, 50);
      var link = document.createElement('a');
      bindLink(link, pageNumber);
      link.textContent = 'Page ' + pageNumber + ': ' + textSample;
      searchResults.appendChild(link);
      
      pageFound = true;
    }
    if (!pageFound) {
      searchResults.textContent = '';
      var noResults = document.createElement('div');
      noResults.classList.add('noResults');
      noResults.textContent = mozL10n.get('search_terms_not_found', null,
                                              '(Not found)');
      searchResults.appendChild(noResults);
    }
  },
  
  setHash: function pdfViewSetHash(hash) {
    if (!hash)
      return;
    
    if (hash.indexOf('=') >= 0) {
      var params = PDFView.parseQueryString(hash);
      // borrowing syntax from "Parameters for Opening PDF Files"
      if ('nameddest' in params) {
        PDFView.navigateTo(params.nameddest);
        return;
      }
      if ('page' in params) {
        var pageNumber = (params.page | 0) || 1;
        if ('zoom' in params) {
          var zoomArgs = params.zoom.split(','); // scale,left,top
          // building destination array

          // If the zoom value, it has to get divided by 100. If it is a string,
          // it should stay as it is.
          var zoomArg = zoomArgs[0];
          var zoomArgNumber = parseFloat(zoomArg);
          if (zoomArgNumber)
            zoomArg = zoomArgNumber / 100;
          
          var dest = [null, {name: 'XYZ'}, (zoomArgs[1] | 0),
            (zoomArgs[2] | 0), zoomArg];
          var currentPage = this.pages[pageNumber - 1];
          currentPage.scrollIntoView(dest);
        } else {
          this.page = pageNumber; // simple page
        }
      }
    } else if (/^\d+$/.test(hash)) // page number
      this.page = hash;
    else // named destination
      PDFView.navigateTo(unescape(hash));
  },
  
  switchSidebarView: function pdfViewSwitchSidebarView(view) {
    var thumbsView = document.getElementById('thumbnailView');
    var outlineView = document.getElementById('outlineView');
    var searchView = document.getElementById('searchView');
    
    var thumbsButton = document.getElementById('viewThumbnail');
    var outlineButton = document.getElementById('viewOutline');
    var searchButton = document.getElementById('viewSearch');
    
    switch (view) {
      case 'thumbs':
        thumbsButton.classList.add('toggled');
        outlineButton.classList.remove('toggled');
        searchButton.classList.remove('toggled');
        thumbsView.classList.remove('hidden');
        outlineView.classList.add('hidden');
        searchView.classList.add('hidden');
        
        PDFView.renderHighestPriority();
        break;
        
      case 'outline':
        thumbsButton.classList.remove('toggled');
        outlineButton.classList.add('toggled');
        searchButton.classList.remove('toggled');
        thumbsView.classList.add('hidden');
        outlineView.classList.remove('hidden');
        searchView.classList.add('hidden');
        
        if (outlineButton.getAttribute('disabled'))
          return;
        break;
        
      case 'search':
        thumbsButton.classList.remove('toggled');
        outlineButton.classList.remove('toggled');
        searchButton.classList.add('toggled');
        thumbsView.classList.add('hidden');
        outlineView.classList.add('hidden');
        searchView.classList.remove('hidden');
        
        var searchTermsInput = document.getElementById('searchTermsInput');
        searchTermsInput.focus();
        // Start text extraction as soon as the search gets displayed.
        this.extractText();
        break;
    }
  },
  
  extractText: function() {
    if (this.startedTextExtraction)
      return;
    this.startedTextExtraction = true;
    var self = this;
    function extractPageText(pageIndex) {
      self.pages[pageIndex].pdfPage.getTextContent().then(
        function textContentResolved(textContent) {
          self.pageText[pageIndex] = textContent;
          self.search();
          if ((pageIndex + 1) < self.pages.length)
            extractPageText(pageIndex + 1);
        }
      );
    }
    extractPageText(0);
  },
  
  getVisiblePages: function pdfViewGetVisiblePages() {
    return this.getVisibleElements(this.container,
                                   this.pages, true);
  },
  
  getVisibleThumbs: function pdfViewGetVisibleThumbs() {
    return this.getVisibleElements(this.thumbnailContainer,
                                   this.thumbnails);
  },

  // Generic helper to find out what elements are visible within a scroll pane.
  getVisibleElements: function pdfViewGetVisibleElements(
      scrollEl, views, sortByVisibility) {
    var currentHeight = 0, view;
    var top = scrollEl.scrollTop;

    for (var i = 1, ii = views.length; i <= ii; ++i) {
      view = views[i - 1];
      currentHeight = view.el.offsetTop;
      if (currentHeight + view.el.clientHeight > top)
        break;
      currentHeight += view.el.clientHeight;
    }

    var visible = [];

    // Algorithm broken in fullscreen mode
    if (this.isFullscreen) {
      var currentPage = this.pages[this.page - 1];
      visible.push({
        id: currentPage.id,
        view: currentPage
      });
      
      return { first: currentPage, last: currentPage, views: visible};
    }
    
    var bottom = top + scrollEl.clientHeight;
    var nextHeight, hidden, percent, viewHeight;
    for (; i <= ii && currentHeight < bottom; ++i) {
      view = views[i - 1];
      viewHeight = view.el.clientHeight;
      currentHeight = view.el.offsetTop;
      nextHeight = currentHeight + viewHeight;
      hidden = Math.max(0, top - currentHeight) +
               Math.max(0, nextHeight - bottom);
      percent = Math.floor((viewHeight - hidden) * 100.0 / viewHeight);
      visible.push({ id: view.id, y: currentHeight,
                     view: view, percent: percent });
      currentHeight = nextHeight;
    }

    var first = visible[0];
    var last = visible[visible.length - 1];

    if (sortByVisibility) {
      visible.sort(function(a, b) {
        var pc = a.percent - b.percent;
        if (Math.abs(pc) > 0.001)
          return -pc;
        
        return a.id - b.id; // ensure stability
      });
    }
    
    return {first: first, last: last, views: visible};
  },
  
  // Helper function to parse query string (e.g. ?param1=value&parm2=...).
  parseQueryString: function pdfViewParseQueryString(query) {
    var parts = query.split('&');
    var params = {};
    for (var i = 0, ii = parts.length; i < parts.length; ++i) {
      var param = parts[i].split('=');
      var key = param[0];
      var value = param.length > 1 ? param[1] : null;
      params[unescape(key)] = unescape(value);
    }
    return params;
  },
  
  beforePrint: function pdfViewSetupBeforePrint() {
    if (!this.supportsPrinting) {
      var printMessage = mozL10n.get('printing_not_supported', null,
          'Warning: Printing is not fully supported by this browser.');
      this.error(printMessage);
      return;
    }
    var body = document.querySelector('body');
    body.setAttribute('data-mozPrintCallback', true);
    for (var i = 0, ii = this.pages.length; i < ii; ++i) {
      this.pages[i].beforePrint();
    }
  },
  
  afterPrint: function pdfViewSetupAfterPrint() {
    var div = document.getElementById('printContainer');
    while (div.hasChildNodes())
      div.removeChild(div.lastChild);
  },
  
  fullscreen: function pdfViewFullscreen() {
    var isFullscreen = document.fullscreen || document.mozFullScreen || document.webkitIsFullScreen;
    
    if(isFullscreen) return false;
    
    var wrapper = document.getElementById('viewerContainer');
    if (document.documentElement.requestFullScreen) {
      wrapper.requestFullScreen();
    } else if (document.documentElement.mozRequestFullScreen) {
      wrapper.mozRequestFullScreen();
    } else if (document.documentElement.webkitRequestFullScreen) {
      wrapper.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
    } else {
      return false;
    }
    
    this.isFullscreen = true;
    var currentPage = this.pages[this.page - 1];
    this.previousScale = this.currentScaleValue;
    this.parseScale('page-fit', true);
    
    // Wait for fullscreen to take effect
    setTimeout(function() {
      currentPage.scrollIntoView();
    }, 0);
    
    return true;
  },
  
  exitFullscreen: function pdfViewExitFullscreen() {
    this.isFullscreen = false;
    this.parseScale(this.previousScale);
    this.page = this.page;
  }
};



PDFView.webViewerLoad = function() {
  PDFView.initialize();
  var params = PDFView.parseQueryString(document.location.search.substring(1));
  
  if (!window.File || !window.FileReader || !window.FileList || !window.Blob) {
    var openFile = document.getElementById('openFile');
    if(openFile) openFile.setAttribute('hidden', 'true');
  } else {
    var fileInput = document.getElementById('fileInput')
    if(fileInput) fileInput.value = null;
  }
  
  // Special debugging flags in the hash section of the URL.
  var hash = document.location.hash.substring(1);
  var hashParams = PDFView.parseQueryString(hash);
  
  if ('disableWorker' in hashParams)
    PDFJS.disableWorker = (hashParams['disableWorker'] === 'true');
  
  // NOTE: mozL10n.language doesn't have a 'code' property
  // var locale = navigator.language;
  // if ('locale' in hashParams)
  //   locale = hashParams['locale'];
  // mozL10n.language.code = locale;
  
  if ('textLayer' in hashParams) {
    switch (hashParams['textLayer']) {
      case 'off':
        PDFJS.disableTextLayer = true;
        break;
      case 'visible':
      case 'shadow':
      case 'hover':
        var viewer = document.getElementById('viewer');
        viewer.classList.add('textLayer-' + hashParams['textLayer']);
        break;
    }
  }
  
  if ('pdfBug' in hashParams) {
    PDFJS.pdfBug = true;
    var pdfBug = hashParams['pdfBug'];
    var enabled = pdfBug.split(',');
    PDFBug.enable(enabled);
    PDFBug.init();
  }
  
  if (!PDFView.supportsPrinting) {
    var printButton = document.getElementById('print');
    if(printButton) printButton.classList.add('hidden');
  }
  
  if (!PDFView.supportsFullscreen) {
    var fullscreenButton = document.getElementById('fullscreen');
    if(fullscreenButton) fullscreenButton.classList.add('hidden');
  }
  
  // Listen for warnings to trigger the fallback UI.  Errors should be caught
  // and call PDFView.error() so we don't need to listen for those.
  PDFJS.LogManager.addLogger({
    warn: function() {
      PDFView.fallback();
    }
  });
  
  var mainContainer = document.getElementById('mainContainer');
  var outerContainer = document.getElementById('outerContainer');
  mainContainer.addEventListener('transitionend', function(e) {
    if (e.target == mainContainer) {
      var event = document.createEvent('UIEvents');
      event.initUIEvent('resize', false, false, window, 0);
      window.dispatchEvent(event);
      outerContainer.classList.remove('sidebarMoving');
    }
  }, true);
  
  var sidebarToggle = document.getElementById('sidebarToggle');
  if(sidebarToggle) {
    document.getElementById('sidebarToggle').addEventListener('click',
      function() {
        this.classList.toggle('toggled');
        outerContainer.classList.add('sidebarMoving');
        outerContainer.classList.toggle('sidebarOpen');
        PDFView.sidebarOpen = outerContainer.classList.contains('sidebarOpen');
        PDFView.renderHighestPriority();
      });
  }
  
  var viewThumbnail = document.getElementById('viewThumbnail');
  if(viewThumbnail) {
    viewThumbnail.addEventListener('click', function() {
      PDFView.switchSidebarView('thumbs');
    });
  }
  
  var viewOutline = document.getElementById('viewOutline');
  if(viewOutline) {
    viewOutline.addEventListener('click', function() {
      PDFView.switchSidebarView('outline');
    });
  }
  
  var viewSearch = document.getElementById('viewSearch');
  if(viewOutline) {
    viewOutline.addEventListener('click', function() {
      PDFView.switchSidebarView('search');
    });
  }
  
  var searchButton = document.getElementById('searchButton');
  if(searchButton) {
    searchButton.addEventListener('click', function() {
      PDFView.search();
    });
  }
  
  var previousButton = document.getElementById('previous');
  if(previousButton) {
    previousButton.addEventListener('click', function() {
      PDFView.page--;
    });
  }
  
  var nextButton = document.getElementById('next');
  if(nextButton) {
    nextButton.addEventListener('click', function() {
      PDFView.page++;
    });
  }
  
  var zoomInButton = document.querySelector('.zoomIn');
  if(zoomInButton) {
    zoomInButton.addEventListener('click', function() {
      PDFView.zoomIn();
    });
  }
  
  var zoomOutButton = document.querySelector('.zoomOut');
  if(zoomOutButton) {
    zoomOutButton.addEventListener('click', function() {
      PDFView.zoomOut();
    });
  }
  
  var fullscreenButton = document.getElementById('fullscreen');
  if(fullscreenButton) {
    fullscreenButton.addEventListener('click', function() {
      PDFView.fullscreen();
    });
  }
  
  var openFileButton = document.getElementById('openFile'),
      fileInput = document.getElementById('fileInput');
  if(openFileButton && fileInput) {
    openFileButton.addEventListener('click', function() {
      fileInput.click();
    });
  }
  
  var printButton = document.getElementById('print');
  if(printButton) {
    printButton.addEventListener('click', function() {
      window.print();
    });
  }
  
  var downloadButton = document.getElementById('download');
  if(downloadButton) {
    downloadButton.addEventListener('click', function() {
      PDFView.download();
    });
  }
  
  var searchTermsInput = document.getElementById('searchTermsInput');
  if(searchTermsInput) {
    searchTermsInput.addEventListener('keydown', function(event) {
      if (event.keyCode == 13) {
        PDFView.search();
      }
    });
  }
  
  var pageNumber = document.getElementById('pageNumber');
  if(pageNumber) {
    pageNumber.addEventListener('change', function() {
      PDFView.page = this.value;
    });
  }
  
  var scaleSelect = document.getElementById('scaleSelect');
  if(scaleSelect) {
    scaleSelect.addEventListener('change', function() {
      PDFView.parseScale(this.value);
    });
  }

};

function updateViewarea() {
  if(!PDFView.initialized) return;
  if(PDFView.loading) return;
  
  var visible = PDFView.getVisiblePages();
  var visiblePages = visible.views;
  
  PDFView.renderHighestPriority();
  
  var currentId = PDFView.page;
  var firstPage = visible.first;
  
  for(var i=0, ii=visiblePages.length, stillFullyVisible=false; i < ii; ++i) {
    var page = visiblePages[i];
    
    if (page.percent < 100)
      break;
    
    if (page.id === PDFView.page) {
      stillFullyVisible = true;
      break;
    }
  }
  
  if(!stillFullyVisible && visiblePages[0]) {
    currentId = visiblePages[0].id;
  }
  
  if(!PDFView.isFullscreen) {
    updateViewarea.inProgress = true; // used in "set page"
    PDFView.page = currentId;
    updateViewarea.inProgress = false;
  }
  
  var currentScale = PDFView.currentScale;
  var currentScaleValue = PDFView.currentScaleValue;
  var normalizedScaleValue = currentScaleValue == currentScale ? currentScale * 100 : currentScaleValue;
  
  var pageNumber = firstPage.id;
  var pdfOpenParams = '#page=' + pageNumber + '&zoom=' + normalizedScaleValue;
  var currentPage = PDFView.pages[pageNumber - 1];
  var topLeft = currentPage.getPagePoint(PDFView.container.scrollLeft,
                                        (PDFView.container.scrollTop - firstPage.y));
  pdfOpenParams += ',' + Math.round(topLeft[0]) + ',' + Math.round(topLeft[1]);
  
  var store = PDFView.store;
  store.set('exists', true);
  store.set('page', pageNumber);
  store.set('zoom', normalizedScaleValue);
  store.set('scrollLeft', Math.round(topLeft[0]));
  store.set('scrollTop', Math.round(topLeft[1]));
  
  var viewBookmarkButton = document.getElementById('viewBookmark');
  if(viewBookmarkButton) {
    var href = PDFView.getAnchorUrl(pdfOpenParams);
    viewBookmarkButton.href = href;
  }
}

window.addEventListener('resize', function webViewerResize(evt) {
  if(!PDFView.initialized) return;
  
  var pageWidthOption = document.getElementById('pageWidthOption'),
      pageFitOption = document.getElementById('pageFitOption'),
      pageAutoOption = document.getElementById('pageAutoOption');
  
  if((pageWidthOption && pageWidthOption.selected) ||
     (pageFitOption && pageFitOption.selected) ||
     (pageAutoOption && pageAutoOption.selected)) {
     var scaleSelect = document.getElementById('scaleSelect');
     if(scaleSelect) PDFView.parseScale(scaleSelect.value);
  }
  updateViewarea();
});

window.addEventListener('hashchange', function webViewerHashchange(evt) {
  PDFView.setHash(document.location.hash.substring(1));
});

window.addEventListener('change', function webViewerChange(evt) {
  var files = evt.target.files;
  if (!files || files.length == 0)
    return;

  // Read the local file into a Uint8Array.
  var fileReader = new FileReader();
  fileReader.onload = function webViewerChangeFileReaderOnload(evt) {
    var buffer = evt.target.result;
    var uint8Array = new Uint8Array(buffer);
    PDFView.open(uint8Array, 0);
  };

  var file = files[0];
  fileReader.readAsArrayBuffer(file);
  PDFView.setUrl(file.name);

  // URL does not reflect proper document location - hiding some icons.
  var viewBookmarkButton = document.getElementById('viewBookmark');
  if(viewBookmarkButton) viewBookmarkButton.setAttribute('hidden', 'true');
  
  var downloadButton = document.getElementById('download');
  if(downloadButton) downloadButton.setAttribute('hidden', 'true');
}, true);

function selectScaleOption(value) {
  var predefinedValueFound = false;
  var scaleSelect = document.getElementById('scaleSelect');
  if(scaleSelect) {
    var options = scaleSelect.options;
    for (var i = 0; i < options.length; i++) {
      var option = options[i];
      if (option.value != value) {
        option.selected = false;
        continue;
      }
      option.selected = true;
      predefinedValueFound = true;
    }
  }
  return predefinedValueFound;
}

window.addEventListener('localized', function localized(evt) {
  document.getElementsByTagName('html')[0].dir = mozL10n.language.direction;
}, true);

window.addEventListener('scalechange', function scalechange(evt) {
  var customScaleOption = document.getElementById('customScaleOption');
  if(customScaleOption) {
    customScaleOption.selected = false;
    
    if(!evt.resetAutoSettings &&
       (document.getElementById('pageWidthOption').selected ||
        document.getElementById('pageFitOption').selected ||
        document.getElementById('pageAutoOption').selected)) {
      updateViewarea();
      return;
    }
    
    var predefinedValueFound = selectScaleOption('' + evt.scale);
    if (!predefinedValueFound) {
      customScaleOption.textContent = Math.round(evt.scale * 10000) / 100 + '%';
      customScaleOption.selected = true;
    }
  }
  updateViewarea();
}, true);

window.addEventListener('pagechange', function pagechange(evt) {
  var page = evt.pageNumber;
  var pageNumber = document.getElementById('pageNumber');
  if (pageNumber && pageNumber.value != page) {
    pageNumber.value = page;
    var selected = document.querySelector('.thumbnail.selected');
    if (selected)
      selected.classList.remove('selected');
    var thumbnail = document.getElementById('thumbnailContainer' + page);
    thumbnail.classList.add('selected');
    var visibleThumbs = PDFView.getVisibleThumbs();
    var numVisibleThumbs = visibleThumbs.views.length;
    // If the thumbnail isn't currently visible scroll it into view.
    if (numVisibleThumbs > 0) {
      var first = visibleThumbs.first.id;
      // Account for only one thumbnail being visible.
      var last = numVisibleThumbs > 1 ?
                  visibleThumbs.last.id : first;
      if (page <= first || page >= last)
        scrollIntoView(thumbnail);
    }
  }
  
  var previousButton = document.getElementById('previous');
  if(previousButton) previousButton.disabled = (page <= 1);
  
  var nextButton = document.getElementById('next');
  if(nextButton) nextButton.disabled = (page >= PDFView.pages.length);
}, true);

// Firefox specific event, so that we can prevent browser from zooming
window.addEventListener('DOMMouseScroll', function(evt) {
  if (evt.ctrlKey) {
    evt.preventDefault();
    
    var ticks = evt.detail;
    var direction = (ticks > 0) ? 'zoomOut' : 'zoomIn';
    for (var i = 0, length = Math.abs(ticks); i < length; i++)
      PDFView[direction]();
  }
}, false);

window.addEventListener('keydown', function keydown(evt) {
  var handled = false;
  var cmd = (evt.ctrlKey ? 1 : 0) |
            (evt.altKey ? 2 : 0) |
            (evt.shiftKey ? 4 : 0) |
            (evt.metaKey ? 8 : 0);
  
  if(!PDFView.useHotkeys) return;
  
  // First, handle the key bindings that are independent whether an input
  // control is selected or not.
  if (cmd == 1 || cmd == 8) { // either CTRL or META key.
    switch (evt.keyCode) {
      case 61: // FF/Mac '='
      case 107: // FF '+' and '='
      case 187: // Chrome '+'
        PDFView.zoomIn();
        handled = true;
        break;
      case 173: // FF/Mac '-'
      case 109: // FF '-'
      case 189: // Chrome '-'
        PDFView.zoomOut();
        handled = true;
        break;
      case 48: // '0'
        PDFView.parseScale(kDefaultScale, true);
        handled = true;
        break;
    }
  }
  
  if (handled) {
    evt.preventDefault();
    return;
  }
  
  // Some shortcuts should not get handled if a control/input element
  // is selected.
  var curElement = document.activeElement;
  if (curElement && (curElement.tagName == 'INPUT' || curElement.tagName == 'TEXTAREA'))
    return;
  var controlsElement = document.getElementById('controls');
  while (curElement) {
    if (curElement === controlsElement && !PDFView.isFullscreen)
      return; // ignoring if the 'controls' element is focused
    curElement = curElement.parentNode;
  }
  
  if (cmd == 0) { // no control key pressed at all.
    switch (evt.keyCode) {
      case 37: // left arrow
      case 75: // 'k'
      case 80: // 'p'
        PDFView.page--;
        handled = true;
        break;
      case 39: // right arrow
      case 74: // 'j'
      case 78: // 'n'
        PDFView.page++;
        handled = true;
        break;
      
      case 32: // spacebar
        if (PDFView.isFullscreen) {
          PDFView.page++;
          handled = true;
        }
        break;
    }
  }
  
  if (handled) {
    evt.preventDefault();
  }
});

window.addEventListener('beforeprint', function beforePrint(evt) {
  PDFView.beforePrint();
});

window.addEventListener('afterprint', function afterPrint(evt) {
  PDFView.afterPrint();
});

(function fullscreenClosure() {
  function fullscreenChange(e) {
    var isFullscreen = document.fullscreen || document.mozFullScreen || document.webkitIsFullScreen;
    
    if (!isFullscreen) {
      PDFView.exitFullscreen();
    }
  }
  
  window.addEventListener('fullscreenchange', fullscreenChange, false);
  window.addEventListener('mozfullscreenchange', fullscreenChange, false);
  window.addEventListener('webkitfullscreenchange', fullscreenChange, false);
})();
