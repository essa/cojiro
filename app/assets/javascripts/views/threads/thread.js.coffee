define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base',
  'modules/translatable',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
  'views/threads/add_link_modal'
  'bootstrap-modal'
], ($, _, Backbone, Base, Translatable, globals, showThreadTemplate, flashTemplate, AddLinkModal) ->

  class ThreadView extends Base.View
    id: 'thread'

    buildEvents: () ->
      _(super).extend
        "click .add-link": "showAddLinkModal"

    initialize: ->
      super
      @addLinkModalView = new AddLinkModal
      @titleField = new Translatable.Field(model: @model, field: "title", editable: globals.currentUser?)
      @summaryField = new Translatable.Field(model: @model, field: "summary", editable: globals.currentUser?)

    render: ->
      @$el.html(showThreadTemplate(model: @model))
      @renderTranslatableFields()
      @renderModals()
      if globals.flash?
        @renderFlash()
      @

    renderTranslatableFields: ->
      @titleField.render()
      @$('#title').html(@titleField.el)
      @summaryField.render()
      @$('#summary').html(@summaryField.el)

    renderModals: ->
      @addLinkModalView.render()
      @$('#add-link-modal').html(@addLinkModalView.el)

    renderFlash: ->
      @$el.prepend(flashTemplate(globals.flash))
      globals.flash = null

    showAddLinkModal: ->
      @$('#add-link-modal').modal()
