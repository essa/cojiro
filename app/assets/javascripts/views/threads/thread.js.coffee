define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'modules/base/view'
  'modules/translatable'
  'globals'
  'templates/threads/show'
  'templates/other/flash'
  'views/threads/add_link_modal'
  'views/links/link'
  'bootstrap-modal'
], ($, _, Backbone, Link, BaseView, Translatable, globals, showThreadTemplate, flashTemplate, AddLinkModal, LinkView) ->

  class ThreadView extends BaseView
    className: 'thread'

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
      @renderLinks()
      @renderModals()
      if globals.flash?
        @renderFlash()
      @

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '#title')
      @renderChildInto(@summaryField, '#summary')

    renderLinks: ->
      linksContainer = @.$('.link-list')
      self = @
      _.each @model.getLinks(), (link) ->
        linkView = new LinkView(model: link)
        self.renderChild(linkView)
        linksContainer.append(linkView.el)

    # see: http://lostechies.com/derickbailey/2012/04/17/managing-a-modal-dialog-with-backbone-and-marionette
    renderModals: ->
      @addLinkModalView.render()
      @$('#add-link-modal').html(@addLinkModalView.el)

    renderFlash: ->
      @$el.prepend(flashTemplate(globals.flash))
      globals.flash = null

    showAddLinkModal: ->
      @$('#add-link-modal').modal()
