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
              <span class="lang"><%= sourceLocale %></span>
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
        sourceLocale: @link.getSourceLocale()
        siteName: @link.getSiteName()
        commentTitle: commentTitle
        commentText: commentText
      ))

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '.title')
      @renderChildInto(@summaryField, '.summary')

    renderPopover: ->
      @$('.link-inner').popover(
        trigger: 'hover'
        placement: 'top'
        html: true
        callback: @initTimeago)
      @

    initTimeago: ->
      $('time.timeago').timeago()
