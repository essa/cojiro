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
  'views/comments/comment_link'
  'bootstrap-modal'
], ($, _, Backbone, Link, BaseView, Translatable, globals, showThreadTemplate, flashTemplate, AddLinkModal, CommentLinkView) ->

  class ThreadView extends BaseView
    className: 'thread'

    buildEvents: () ->
      _(super).extend
        "click .add-link": "showAddLinkModal"

    initialize: (options = {}) ->
      super(options)

      @addLinkModal = new AddLinkModal(model: @model)
      @titleField = new Translatable.InPlaceField(model: @model, field: "title", editable: globals.currentUser?)
      @summaryField = new Translatable.InPlaceField(model: @model, field: "summary", editable: globals.currentUser?)

      @model.on('add:comments', @renderLinks, @)

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
      (linksContainer = @.$('.link-list')).empty()
      self = @
      @model.getComments().each (comment) ->
        if link = comment.get('link')
          linkView = new CommentLinkView(model: comment)
          self.renderChild(linkView)
          linksContainer.append(linkView.el)

    # see: http://lostechies.com/derickbailey/2012/04/17/managing-a-modal-dialog-with-backbone-and-marionette
    renderModals: ->
      @renderChild(@addLinkModal)

    renderFlash: ->
      @$el.prepend(flashTemplate(globals.flash))
      globals.flash = null

    showAddLinkModal: ->
      @addLinkModal.trigger('view:show')
