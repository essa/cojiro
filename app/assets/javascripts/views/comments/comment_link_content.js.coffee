define [
  'jquery'
  'underscore'
  'modules/base/view'
  'modules/translatable/in-place-field'
  'globals'
], ($, _, BaseView, InPlaceField, globals) ->

  class CommentLinkContentView extends BaseView
    template: _.template '
      <h3 class="title"></h3>
      <p class="summary"></p>'
    className: 'description'
    tagName: 'a'

    initialize: (options) ->
      super(options)

      @link = @model.getLink()
      editable = globals.currentUser?
      @titleField = new InPlaceField(
        model: @link
        field: 'title'
        editable: editable)
      @summaryField = new InPlaceField(
        model: @link
        field: 'summary'
        editable: editable)

      @titleField.on 'open', @triggerOpen
      @titleField.on 'close', @triggerClose
      @summaryField.on 'open', @triggerOpen
      @summaryField.on 'close', @triggerClose

    render: ->
      @renderTemplate()
      @renderTranslatableFields()
      @

    renderTemplate: -> @$el.html(@template())

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '.title')
      @renderChildInto(@summaryField, '.summary')

    isClosed: => (@$('.editable-input').length is 0)
    isOpened: -> (@$('.editable-input').length is 1)
    triggerOpen: => @isOpened() && @trigger('open', @)
    triggerClose: => @isClosed() && @trigger('close', @)
