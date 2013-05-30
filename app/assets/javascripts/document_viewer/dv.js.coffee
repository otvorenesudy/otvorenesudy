window.DV = {}

class DV.DocumentViewer
  @init = (options) ->
    @dv = new DV.Viewer
      documents: _(options.attachments).map (attachment) ->
        new DV.Document(attachment)
      comments: _(options.comments).map (comment) ->
        new DV.Comment(comment)
      currentUser: options.currentUser,
      onReply: options.onReply,
      onShowReplies: options.onShowReplies,
      size: {width: parseInt(options.width), height: parseInt(options.height)},
      annotationsAllowed: options.annotationsAllowed
      zoom: options.zoom
      commentList: options.commentList
      search: options.search

    chrome = new DV.ChromeView(dv: @dv, el: $(options.container))
    chrome.render()

    router = new DV.DocumentViewerRouter(dv: @dv)
    Backbone.history.start()
    @
