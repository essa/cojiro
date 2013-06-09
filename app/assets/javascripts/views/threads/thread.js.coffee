define [
  'jquery',
  'underscore',
  'backbone',
  'models/link'
  'modules/base',
  'modules/translatable',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
  'views/threads/add_link_modal'
  'bootstrap-modal'
], ($, _, Backbone, Link, Base, Translatable, globals, showThreadTemplate, flashTemplate, AddLinkModal) ->

  class ThreadView extends Base.View
    id: 'thread'

    buildEvents: () ->
      _(super).extend
        "click .add-link": "showAddLinkModal"

    initialize: ->
      super
      @addLinkModalView = new AddLinkModal(model: new Link)
      @titleField = new Translatable.InPlaceField(model: @model, field: "title", editable: globals.currentUser?)
      @summaryField = new Translatable.InPlaceField(model: @model, field: "summary", editable: globals.currentUser?)

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

    # see: http://lostechies.com/derickbailey/2012/04/17/managing-a-modal-dialog-with-backbone-and-marionette
    renderModals: ->
      @addLinkModalView.render()
      @$('#add-link-modal').html(@addLinkModalView.el)

    renderFlash: ->
      @$el.prepend(flashTemplate(globals.flash))
      globals.flash = null

    showAddLinkModal: ->
      @$('#add-link-modal').modal()
