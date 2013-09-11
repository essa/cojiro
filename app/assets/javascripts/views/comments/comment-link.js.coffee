define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'views/comments/status_message'
  'views/comments/comment-link-content'
  'modules/base/view'
  'globals'
], ($, _, Backbone, Link, StatusMessageView, CommentLinkContentView, BaseView, globals) ->

  class CommentLinkView extends BaseView
    className: 'link'
    template: _.template '
      <div class="link-inner"
           data-toggle="popover">
        <div class="url">
          <a href="<%= url %>" target="_blank">
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
      @$el.html(@template(
        url: @link.getUrl()
        faviconUrl: @link.getFaviconUrl()
        siteName: @link.getSiteName()
        sourceLocale: @link.getSourceLocale()
      ))

    renderContent: ->
      @renderChildInto(@contentView, '.comment-link-content')

    renderPopover: =>
      @statusMessage = new StatusMessageView(model: @model)
      @renderChild(@statusMessage)
      [title, content] = @getStatusMessageText(
        @statusMessage.el.outerHTML
        @model.getText())
      @$('.link-inner').popover(
        title: title
        content: content
        trigger: 'hover'
        placement: 'top'
        html: true
        callback: @initTimeago)
      @

    getStatusMessageText: (statusMessageHtml, commentText) ->
      if commentText
        [statusMessageHtml, commentText]
      else
        [null, statusMessageHtml]

    destroyPopover: => @$('.link-inner').popover('destroy')
    initTimeago: -> $('time.timeago').timeago()
