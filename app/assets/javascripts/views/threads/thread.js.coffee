define [
  'jquery',
  'underscore',
  'backbone',
  'modules/translatable',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
  'views/threads/add_neta_modal'
  'bootstrap-modal'
], ($, _, Backbone, Translatable, globals, showThreadTemplate, flashTemplate, AddNetaModal) ->

  class ThreadView extends Translatable.View
    id: 'thread'

    buildEvents: () ->
      _(super).extend
        "click .add-neta": "showAddNetaModal"

    initialize: ->
      super
      @addNetaModalView = new AddNetaModal

    render: ->
      @$el.html(showThreadTemplate(model: @model))
      @renderModals()
      if globals.flash?
        @renderFlash()
      @

    renderModals: ->
      @addNetaModalView.render()
      @$('#add-neta-modal').html(@addNetaModalView.el)

    renderFlash: ->
      @$el.prepend(flashTemplate(globals.flash))
      globals.flash = null

    showAddNetaModal: ->
      @$('#add-neta-modal').modal()
