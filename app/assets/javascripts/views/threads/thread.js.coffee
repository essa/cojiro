define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'modules/base/view'
  'views/other/flash'
  'modules/translatable'
  'globals'
  'views/threads/statbar'
  'views/threads/add_link_modal'
  'views/comments/comment_link'
  'bootstrap'
], ($, _, Backbone, Link, BaseView, FlashView, Translatable, globals, StatbarView, AddLinkModal, CommentLinkView) ->

  class ThreadView extends BaseView
    template: _.template '
      <div class="row">
        <div class="span12" id="statbar">
        </div>
      </div>
      <div class="row">
        <div class="span12">
          <h1 id="title" />
        </div>
      </div>
      <div class="row">
        <div class="span12">
          <h2 id="summary" />
        </div>
      </div>
      <div class="links">
        <% if (!!currentUser) { %>
          <div class="link">
            <div class="link-inner">
              <a class="add-link" role="button">
                <%= t(".add_a_link") %>
                <div class="add-link-button"></div>
              </a>
            </div>
          </div>
        <% } %>
        <div class="link-list"></div>
      </div>
    '
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
      @$el.html(@template(
        t: I18n.scoped('views.threads.thread').t
        currentUser: globals.currentUser
      ))
      @renderTranslatableFields()
      @renderStatbar()
      @renderLinks()
      @renderModals()
      if globals.flash?
        @renderFlash()
      @

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '#title')
      @renderChildInto(@summaryField, '#summary')

    renderStatbar: ->
      @statbar = new StatbarView(model: @model)
      @renderChild(@statbar)
      @$('#statbar').html(@statbar.el)

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
      @flash.leave() if @flash
      @flash = new FlashView(globals.flash)
      @renderChild(@flash)
      @$el.prepend(@flash.el)
      globals.flash = null

    showAddLinkModal: ->
      @addLinkModal.trigger('view:show')
