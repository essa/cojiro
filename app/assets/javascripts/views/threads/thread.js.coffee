define [
  'jquery',
  'underscore',
  'backbone',
  'modules/translatable',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
  'views/threads/add_link_modal'
  'bootstrap-modal'
], ($, _, Backbone, Translatable, globals, showThreadTemplate, flashTemplate, AddLinkModal) ->

  class ThreadView extends Translatable.View
    id: 'thread'

    buildEvents: () ->
      _(super).extend
        "click .add-link": "showAddLinkModal"

    initialize: ->
      super
      @addLinkModalView = new AddLinkModal

    render: ->
      @$el.html(showThreadTemplate(model: @model))
      @renderModals()
      if globals.flash?
        @renderFlash()
      @

    renderModals: ->
      @addLinkModalView.render()
      @$('#add-link-modal').html(@addLinkModalView.el)

    renderFlash: ->
      @$el.prepend(flashTemplate(globals.flash))
      globals.flash = null

    showAddLinkModal: ->
      @$('#add-link-modal').modal()
