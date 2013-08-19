define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'modules/base/view'
  'modules/translatable'
  'globals'
  'bootstrap'
], ($, _, Backbone, Link, BaseView, Translatable, globals) ->

  class CommentLinkView extends BaseView
    className: 'link'
    template: _.template '
        <div class="link-inner"
             data-toggle="popover"
             title="<%= commentTitle %>"
             data-content="<%= commentText %>">
          <div class="url">
            <a href="<%= url %>">
              <span class="favicon"><img src="<%= faviconUrl %>" /></span>
              <span class="site"><%= siteName %></span>
            </a>
            <a href="#" style="float: right" class="icon-edit" />
          </div>
          <a class="description">
            <h3 class="title"></h3>
            <p class="summary"></p>
          </a>
        </div>'

    initialize: (options) ->
      throw 'model required in CommentLinkView' unless @model
      @link = @model.get('link')
      throw 'comment must have a link to render a CommentLinkView' unless (@link instanceof Link)
      @titleField = new Translatable.InPlaceField(model: @link, field: 'title', editable: globals.currentUser?)
      @summaryField = new Translatable.InPlaceField(model: @link, field: 'summary', editable: globals.currentUser?)

      @titleField.on 'open', @destroyPopover
      @titleField.on 'close', @renderPopover
      @summaryField.on 'open', @destroyPopover
      @summaryField.on 'close', @renderPopover

      super

    render: ->
      @renderTemplate()
      @renderTranslatableFields()
      @renderPopover()

    renderTemplate: ->
      if @model.getText()
        commentTitle = @model.getStatusMessage()
        commentText = @model.getText()
      else
        commentTitle = null
        commentText = @model.getStatusMessage()
      @$el.html(@template(
        url: @link.getUrl()
        faviconUrl: @link.getFaviconUrl()
        siteName: @link.getSiteName()
        commentTitle: commentTitle
        commentText: commentText
      ))

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '.title')
      @renderChildInto(@summaryField, '.summary')

    renderPopover: =>
      if (@$('.editable-input').length == 0)
        @$('.link-inner').popover(
          trigger: 'hover'
          placement: 'top'
          html: true
          callback: @initTimeago)
      @

    destroyPopover: =>
      @$('.link-inner').popover('destroy')

    initTimeago: -> $('time.timeago').timeago()
