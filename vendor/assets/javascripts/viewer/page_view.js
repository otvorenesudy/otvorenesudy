var PageView = function pageView(container, pdfPage, id, scale, stats, navigateTo) {
  this.id = id;
  this.pdfPage = pdfPage;
  
  this.scale = scale || 1.0;
  this.viewport = this.pdfPage.getViewport(this.scale, this.pdfPage.rotate);
  
  this.renderingState = RenderingStates.INITIAL;
  this.resume = null;
  
  var anchor = document.createElement('a');
  anchor.name = '' + this.id;
  
  var div = this.el = document.createElement('div');
  div.id = 'pageContainer' + this.id;
  div.className = 'page';
  div.style.width = this.viewport.width + 'px';
  div.style.height = this.viewport.height + 'px';
  
  container.appendChild(anchor);
  container.appendChild(div);
  
  this.destroy = function pageViewDestroy() {
    this.update();
    this.pdfPage.destroy();
  };
  
  this.update = function pageViewUpdate(scale) {
    this.renderingState = RenderingStates.INITIAL;
    this.resume = null;
    
    this.scale = scale || this.scale;
    
    var totalRotation = (this.pdfPage.rotate) % 360;
    var viewport = this.pdfPage.getViewport(this.scale, totalRotation);
    
    this.viewport = viewport;
    div.style.width = viewport.width + 'px';
    div.style.height = viewport.height + 'px';
    
    while (div.hasChildNodes())
      div.removeChild(div.lastChild);
    div.removeAttribute('data-loaded');
    
    delete this.canvas;
    
    this.loadingIconDiv = document.createElement('div');
    this.loadingIconDiv.className = 'loadingIcon';
    div.appendChild(this.loadingIconDiv);
  };
  
  Object.defineProperty(this, 'width', {
    get: function PageView_getWidth() {
      return this.viewport.width;
    },
    enumerable: true
  });
  
  Object.defineProperty(this, 'height', {
    get: function PageView_getHeight() {
      return this.viewport.height;
    },
    enumerable: true
  });
  
  function setupAnnotations(pdfPage, viewport) {
    function bindLink(link, dest) {
      link.href = PDFView.getDestinationHash(dest);
      link.onclick = function pageViewSetupLinksOnclick() {
        if (dest)
          PDFView.navigateTo(dest);
        return false;
      };
    }
    function createElementWithStyle(tagName, item) {
      var rect = viewport.convertToViewportRectangle(item.rect);
      rect = PDFJS.Util.normalizeRect(rect);
      var element = document.createElement(tagName);
      element.style.left = Math.floor(rect[0]) + 'px';
      element.style.top = Math.floor(rect[1]) + 'px';
      element.style.width = Math.ceil(rect[2] - rect[0]) + 'px';
      element.style.height = Math.ceil(rect[3] - rect[1]) + 'px';
      return element;
    }
    function createCommentAnnotation(type, item) {
      var container = document.createElement('section');
      container.className = 'annotComment';

      var image = createElementWithStyle('img', item);
      var type = item.type;
      var rect = viewport.convertToViewportRectangle(item.rect);
      rect = PDFJS.Util.normalizeRect(rect);
      image.src = kImageDirectory + 'annotation-' + type.toLowerCase() + '.svg';
      image.alt = mozL10n.get('text_annotation_type', {type: type},
        '[{{type}} Annotation]');
      var content = document.createElement('div');
      content.setAttribute('hidden', true);
      var title = document.createElement('h1');
      var text = document.createElement('p');
      content.style.left = Math.floor(rect[2]) + 'px';
      content.style.top = Math.floor(rect[1]) + 'px';
      title.textContent = item.title;
      
      if (!item.content && !item.title) {
        content.setAttribute('hidden', true);
      } else {
        var e = document.createElement('span');
        var lines = item.content.split('\n');
        for (var i = 0, ii = lines.length; i < ii; ++i) {
          var line = lines[i];
          e.appendChild(document.createTextNode(line));
          if (i < (ii - 1))
            e.appendChild(document.createElement('br'));
        }
        text.appendChild(e);
        image.addEventListener('mouseover', function annotationImageOver() {
           content.removeAttribute('hidden');
        }, false);
        
        image.addEventListener('mouseout', function annotationImageOut() {
           content.setAttribute('hidden', true);
        }, false);
      }
      
      content.appendChild(title);
      content.appendChild(text);
      container.appendChild(image);
      container.appendChild(content);
      
      return container;
    }
    
    pdfPage.getAnnotations().then(function(items) {
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        switch (item.type) {
          case 'Link':
            var link = createElementWithStyle('a', item);
            link.href = item.url || '';
            if (!item.url)
              bindLink(link, ('dest' in item) ? item.dest : null);
            div.appendChild(link);
            break;
          case 'Text':
            var comment = createCommentAnnotation(item.name, item);
            if (comment)
              div.appendChild(comment);
            break;
          case 'Widget':
            // TODO: support forms
            PDFView.fallback();
            break;
        }
      }
    });
  }
  
  this.getPagePoint = function pageViewGetPagePoint(x, y) {
    return this.viewport.convertToPdfPoint(x, y);
  };
  
  this.scrollIntoView = function pageViewScrollIntoView(dest) {
      if (!dest) {
        scrollIntoView(div);
        return;
      }
      
      var x = 0, y = 0;
      var width = 0, height = 0, widthScale, heightScale;
      var scale = 0;
      switch (dest[1].name) {
        case 'XYZ':
          x = dest[2];
          y = dest[3];
          scale = dest[4];
          break;
        case 'Fit':
        case 'FitB':
          scale = 'page-fit';
          break;
        case 'FitH':
        case 'FitBH':
          y = dest[2];
          scale = 'page-width';
          break;
        case 'FitV':
        case 'FitBV':
          x = dest[2];
          scale = 'page-height';
          break;
        case 'FitR':
          x = dest[2];
          y = dest[3];
          width = dest[4] - x;
          height = dest[5] - y;
          widthScale = (this.container.clientWidth - kScrollbarPadding) /
            width / kCssUnits;
          heightScale = (this.container.clientHeight - kScrollbarPadding) /
            height / kCssUnits;
          scale = Math.min(widthScale, heightScale);
          break;
        default:
          return;
      }
      
      if (scale && scale !== PDFView.currentScale)
        PDFView.parseScale(scale, true, true);
      else if (PDFView.currentScale === kUnknownScale)
        PDFView.parseScale(kDefaultScale, true, true);
      
      var boundingRect = [
        this.viewport.convertToViewportPoint(x, y),
        this.viewport.convertToViewportPoint(x + width, y + height)
      ];
      
      setTimeout(function pageViewScrollIntoViewRelayout() {
        // letting page to re-layout before scrolling
        var scale = PDFView.currentScale;
        var x = Math.min(boundingRect[0][0], boundingRect[1][0]);
        var y = Math.min(boundingRect[0][1], boundingRect[1][1]);
        var width = Math.abs(boundingRect[0][0] - boundingRect[1][0]);
        var height = Math.abs(boundingRect[0][1] - boundingRect[1][1]);
        
        scrollIntoView(div, {left: x, top: y, width: width, height: height});
      }, 0);
  };
  
  this.draw = function pageviewDraw(callback) {
    if (this.renderingState !== RenderingStates.INITIAL)
      error('Must be in new state before drawing');
    
    this.renderingState = RenderingStates.RUNNING;
    
    var canvas = document.createElement('canvas');
    canvas.id = 'page' + this.id;
    canvas.mozOpaque = true;
    div.appendChild(canvas);
    this.canvas = canvas;
    
    var textLayerDiv = null;
    if (!PDFJS.disableTextLayer) {
      textLayerDiv = document.createElement('div');
      textLayerDiv.className = 'textLayer';
      div.appendChild(textLayerDiv);
    }
    var textLayer = textLayerDiv ? new TextLayerBuilder(textLayerDiv) : null;
    
    var scale = this.scale, viewport = this.viewport;
    canvas.width = viewport.width;
    canvas.height = viewport.height;
    
    var ctx = canvas.getContext('2d');
    ctx.save();
    ctx.fillStyle = 'rgb(255, 255, 255)';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.restore();
    
    // Rendering area
    
    var self = this;
    function pageViewDrawCallback(error) {
      self.renderingState = RenderingStates.FINISHED;
      
      if (self.loadingIconDiv) {
        div.removeChild(self.loadingIconDiv);
        delete self.loadingIconDiv;
      }
      
      if (error) {
        PDFView.error(mozL10n.get('rendering_error', null,
          'An error occurred while rendering the page.'), error);
      }
      
      self.stats = pdfPage.stats;
      self.updateStats();
      if (self.onAfterDraw)
        self.onAfterDraw();
        
      cache.push(self);
      callback();
    }
    
    var renderContext = {
      canvasContext: ctx,
      viewport: this.viewport,
      textLayer: textLayer,
      continueCallback: function pdfViewcContinueCallback(cont) {
        if (PDFView.highestPriorityPage !== 'page' + self.id) {
          self.renderingState = RenderingStates.PAUSED;
          self.resume = function resumeCallback() {
            self.renderingState = RenderingStates.RUNNING;
            cont();
          };
          return;
        }
        cont();
      }
    };
    this.pdfPage.render(renderContext).then(
      function pdfPageRenderCallback() {
        pageViewDrawCallback(null);
      },
      function pdfPageRenderError(error) {
        pageViewDrawCallback(error);
      }
    );
    
    setupAnnotations(this.pdfPage, this.viewport);
    div.setAttribute('data-loaded', true);
  };
  
  this.beforePrint = function pageViewBeforePrint() {
    var pdfPage = this.pdfPage;
    var viewport = pdfPage.getViewport(1);
    
    var canvas = this.canvas = document.createElement('canvas');
    canvas.width = viewport.width;
    canvas.height = viewport.height;
    canvas.style.width = viewport.width + 'pt';
    canvas.style.height = viewport.height + 'pt';
    
    var printContainer = document.getElementById('printContainer');
    printContainer.appendChild(canvas);
    
    var self = this;
    canvas.mozPrintCallback = function(obj) {
      var ctx = obj.context;
      var renderContext = {
        canvasContext: ctx,
        viewport: viewport
      };
      
      pdfPage.render(renderContext).then(function() {
        // Tell the printEngine that rendering this canvas/page has finished.
        obj.done();
        self.pdfPage.destroy();
      }, function(error) {
        console.error(error);
        // Tell the printEngine that rendering this canvas/page has failed.
        // This will make the print proces stop.
        if ('abort' in object)
          obj.abort();
        else
          obj.done();
        self.pdfPage.destroy();
      });
    };
  };
  
  this.updateStats = function pageViewUpdateStats() {
    if (PDFJS.pdfBug && Stats.enabled) {
      var stats = this.stats;
      Stats.add(this.id, stats);
    }
  };
};
