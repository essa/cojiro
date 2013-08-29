define (require) ->

  # static dependencies
  _ = require('underscore')
  BaseView = require('modules/base/view')
  globals = require('globals')

  class ThreadHeaderView extends BaseView
    template: _.template '
      <div class="row">
        <div class="span12">
          <h1 id="title"></h1>
        </div>
      </div>
      <div class="row">
        <div class="span12">
          <h2 id="summary"></h2>
        </div>
      </div>'
    className: 'thread-header'

    buildEvents: () ->
      _(super).extend
        'click': 'showModal'

    initialize: (options = {}) ->
      super(options)

      # dynamic dependencies
      @ThreadHeaderModal = options.ThreadHeaderModal || require('views/threads/header-modal')
      @InPlaceField = options.InPlaceField || require('modules/translatable/in-place-field')

      # create instances
      @titleField = new @InPlaceField(model: @model, field: "title", editable: false)
      @summaryField = new @InPlaceField(model: @model, field: "summary", editable: false)
      @modal = new @ThreadHeaderModal(model: @model)

      # event listeners
      view = @
      @listenTo(@model, 'change:title', view.render)
      @listenTo(@model, 'change:summary', view.render)

    render: ->
      @renderTemplate()
      @renderTranslatableFields()
      @

    renderTemplate: -> @$el.html(@template())

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '#title')
      @renderChildInto(@summaryField, '#summary')

    renderModal: -> @renderChild(@modal)

    showModal: ->
      if globals.currentUser?
        @renderModal()
        @modal.trigger('show')
