class DV.Comment extends Backbone.Model
  url: ->
    location.href.replace(location.hash, '') + '/comments'

  initialize: (options) ->
    @set(area: $.parseJSON(options.area)) if options.area
    @set(created_at: new Date(options.created_at)) if options.created_at
    replies = _(options.replies).map (reply) ->
      new DV.Comment(reply)
    @set(replies: replies)
    @set(avatar_url: options.user.avatar_url) if options.user
    @set(user_name: options.user.name) if options.user
    @set(is_annotation: @isAnnotation)

  show: ->
    @trigger("highlight")

  y1: ->
    @get("area").y1

  x1: ->
    @get("area").x1

  width: ->
    @get("area").width

  height: ->
    @get("area").height

  isAnonymous: ->
    typeof @get("user") is "undefined"

  isAnnotation: ->
    if @get("area")
      true
    else
      false
