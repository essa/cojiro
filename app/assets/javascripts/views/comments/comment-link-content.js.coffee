define [
  'jquery'
  'underscore'
  'views/links/link-thumbnail'
  'modules/base/view'
  'modules/translatable/in-place-field'
  'globals'
], ($, _, LinkThumbnailView, BaseView, InPlaceField, globals) ->

  class CommentLinkContentView extends BaseView
    template: _.template '
      <h3 class="title"></h3>
      <div class="preview"></div>'
    className: 'description'
    tagName: 'a'

    initialize: (options) ->
      super(options)

      @InPlaceField = options.InPlaceField || InPlaceField
      @LinkThumbnailView = options.LinkThumbnailView || LinkThumbnailView

      @link = @model.getLink()
      @type = @link.getMediaType()
      @editable = globals.currentUser?
      @initializeTitleField()
      @initializeMediaField()

    initializeTitleField: ->
      @titleField = new @InPlaceField(
        model: @link
        field: 'title'
        editable: @editable)
      @titleField.on 'open', @triggerOpen
      @titleField.on 'close', @triggerClose

    initializeMediaField: ->
      switch @type
        when 'video'
          @previewField = new @LinkThumbnailView(model: @link)
        else
          @previewField = new @InPlaceField(
            model: @link
            field: 'summary'
            editable: @editable)
          @previewField.on 'open', @triggerOpen
          @previewField.on 'close', @triggerClose

    render: ->
      @renderTemplate()
      @renderTranslatableFields()
      @

    renderTemplate: -> @$el.html(@template())

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '.title')
      if @type == 'video'
        @renderChildInto(@previewField, '.preview')
      else
        @$('.preview').append($('<p class="summary"></p>'))
        @renderChildInto(@previewField, '.summary')

    isClosed: => (@$('.editable-input').length is 0)
    isOpened: -> (@$('.editable-input').length is 1)
    triggerOpen: => @isOpened() && @trigger('open', @)
    triggerClose: => @isClosed() && @trigger('close', @)
