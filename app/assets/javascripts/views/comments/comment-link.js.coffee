define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'views/comments/status_message'
  'views/comments/comment-link-content'
  'modules/base/view'
  'globals'
  'bootstrap'
], ($, _, Backbone, Link, StatusMessageView, CommentLinkContentView, BaseView, globals) ->

  class CommentLinkView extends BaseView
    className: 'link'
    template: _.template '
      <div class="link-inner"
           data-toggle="popover">
        <div class="url">
          <a href="<%= url %>">
            <span class="favicon"><img src="<%= faviconUrl %>" /></span>
            <span class="site"><%= siteName %></span>
            <span class="lang">(<%= sourceLocale %>)</span>
          </a>
        </div>
        <div class="comment-link-content">
        </div>
      </div>'

    initialize: (options = {}) ->
      @CommentLinkContentView = options.CommentLinkContentView || CommentLinkContentView

      throw 'model required in CommentLinkView' unless @model
      @link = @model.getLink()
      throw 'comment must have a link to render a CommentLinkView' unless (@link instanceof Link)
      @contentView = new @CommentLinkContentView(model: @model)

      @contentView.on 'open', @destroyPopover
      @contentView.on 'close', @renderPopover

      super(options)

    render: ->
      @renderTemplate()
      @renderContent()
      @renderPopover()

    renderTemplate: ->
      statusMessage = new StatusMessageView(model: @model)
      @renderChild(statusMessage)
      statusMessageHtml = statusMessage.el.outerHTML
      if @model.getText()
        commentTitle = statusMessageHtml
        commentText = @model.getText()
      else
        commentTitle = null
        commentText = statusMessageHtml
      @$el.html(@template(
        url: @link.getUrl()
        faviconUrl: @link.getFaviconUrl()
        siteName: @link.getSiteName()
        sourceLocale: @link.getSourceLocale()
      ))
      @$('[data-toggle="popover"]').attr('title', commentTitle)
      @$('[data-toggle="popover"]').attr('data-content', commentText)

    renderContent: ->
      @renderChildInto(@contentView, '.comment-link-content')

    renderPopover: =>
      @$('.link-inner').popover(
        trigger: 'hover'
        placement: 'top'
        html: true
        callback: @initTimeago)
      @

    destroyPopover: => @$('.link-inner').popover('destroy')
    initTimeago: -> $('time.timeago').timeago()
