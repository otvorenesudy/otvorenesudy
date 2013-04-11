var ThumbnailView = function thumbnailView(container, pdfPage, id) {
  var anchor = document.createElement('a');
  anchor.href = PDFView.getAnchorUrl('#page=' + id);
  anchor.title = mozL10n.get('thumb_page_title', {page: id}, 'Page {{page}}');
  anchor.onclick = function stopNavigation() {
    PDFView.page = id;
    return false;
  };

  var rotation = 0;
  var totalRotation = (rotation + pdfPage.rotate) % 360;
  var viewport = pdfPage.getViewport(1, totalRotation);
  var pageWidth = this.width = viewport.width;
  var pageHeight = this.height = viewport.height;
  var pageRatio = pageWidth / pageHeight;
  this.id = id;

  var canvasWidth = 98;
  var canvasHeight = canvasWidth / this.width * this.height;
  var scaleX = this.scaleX = (canvasWidth / pageWidth);
  var scaleY = this.scaleY = (canvasHeight / pageHeight);

  var div = this.el = document.createElement('div');
  div.id = 'thumbnailContainer' + id;
  div.className = 'thumbnail';

  var ring = document.createElement('div');
  ring.className = 'thumbnailSelectionRing';
  ring.style.width = canvasWidth + 'px';
  ring.style.height = canvasHeight + 'px';

  div.appendChild(ring);
  anchor.appendChild(div);
  container.appendChild(anchor);

  this.hasImage = false;
  this.renderingState = RenderingStates.INITIAL;

  function getPageDrawContext() {
    var canvas = document.createElement('canvas');
    canvas.id = 'thumbnail' + id;
    canvas.mozOpaque = true;

    canvas.width = canvasWidth;
    canvas.height = canvasHeight;
    canvas.className = 'thumbnailImage';
    canvas.setAttribute('aria-label', mozL10n.get('thumb_page_canvas',
      {page: id}, 'Thumbnail of Page {{page}}'));

    div.setAttribute('data-loaded', true);

    ring.appendChild(canvas);

    var ctx = canvas.getContext('2d');
    ctx.save();
    ctx.fillStyle = 'rgb(255, 255, 255)';
    ctx.fillRect(0, 0, canvasWidth, canvasHeight);
    ctx.restore();
    return ctx;
  }

  this.drawingRequired = function thumbnailViewDrawingRequired() {
    return !this.hasImage;
  };

  this.draw = function thumbnailViewDraw(callback) {
    if (this.renderingState !== RenderingStates.INITIAL)
      error('Must be in new state before drawing');

    this.renderingState = RenderingStates.RUNNING;
    if (this.hasImage) {
      callback();
      return;
    }

    var self = this;
    var ctx = getPageDrawContext();
    var drawViewport = pdfPage.getViewport(scaleX, totalRotation);
    var renderContext = {
      canvasContext: ctx,
      viewport: drawViewport,
      continueCallback: function(cont) {
        if (PDFView.highestPriorityPage !== 'thumbnail' + self.id) {
          self.renderingState = RenderingStates.PAUSED;
          self.resume = function() {
            self.renderingState = RenderingStates.RUNNING;
            cont();
          };
          return;
        }
        cont();
      }
    };
    pdfPage.render(renderContext).then(
      function pdfPageRenderCallback() {
        self.renderingState = RenderingStates.FINISHED;
        callback();
      },
      function pdfPageRenderError(error) {
        self.renderingState = RenderingStates.FINISHED;
        callback();
      }
    );
    this.hasImage = true;
  };

  this.setImage = function thumbnailViewSetImage(img) {
    if (this.hasImage || !img)
      return;
    this.renderingState = RenderingStates.FINISHED;
    var ctx = getPageDrawContext();
    ctx.drawImage(img, 0, 0, img.width, img.height,
                  0, 0, ctx.canvas.width, ctx.canvas.height);

    this.hasImage = true;
  };
  
  this.bindOnAfterDraw = function(pageView) {
    var thumbnailView = this;
    
    // when page is painted, using the image as thumbnail base
    pageView.onAfterDraw = function pdfViewLoadOnAfterDraw() {
      thumbnailView.setImage(pageView.canvas);
    };
  };
  
};
