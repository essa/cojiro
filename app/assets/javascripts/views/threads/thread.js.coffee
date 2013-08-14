define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'modules/base/view'
  'views/other/flash'
  'modules/translatable'
  'globals'
  'views/threads/add_link_modal'
  'views/comments/comment_link'
  'bootstrap'
], ($, _, Backbone, Link, BaseView, FlashView, Translatable, globals, AddLinkModal, CommentLinkView) ->

  class ThreadView extends BaseView
    template: _.template '
      <div class="row">
        <div class="span12">
          <div class="statbar">
            <ul class="nav nav-pills">
              <li>
                <a href="#">
                  <span class="stat">
                    <%= numLinks %>
                  </span>
                  <br />
                  <span class="stattext">
                    <%= t(".links") %>
                  </span>
                </a>
              </li>
              <li class="sep"></li>
              <li>
                <span class="date"><%= createdAt %></span>
                <br />
                <span class="status"><%= t(".started") %></span>
              </li>
              <li class="avatar">
                <img src="<%= avatarUrl %>" />
              </li>
              <li class="byline">
                <span class="name"><%= fullname %></span>
                <br />
                <a class="unstyled" href="#">
                  <span class="handle">@<%= name %></span>
                </a>
              </li>
              <li class="sep"></li>
              <li>
                <span class="date"><%= updatedAt %></span>
                <br />
                <span class="status"><%= t(".updated") %></span>
              </li>
            </ul>
          </div>
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
        numLinks: @model.getLinks().length
        createdAt: @model.getCreatedAt()
        updatedAt: @model.getUpdatedAt()
        avatarUrl: @model.getUser().getAvatarMiniUrl()
        fullname: @model.getUser().getFullname()
        name: @model.getUserName()
      ))
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
      @flash.leave() if @flash
      @flash = new FlashView(globals.flash)
      @renderChild(@flash)
      @$el.prepend(@flash.el)
      globals.flash = null

    showAddLinkModal: ->
      @addLinkModal.trigger('view:show')
