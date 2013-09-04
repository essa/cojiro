define (require) ->

  # static dependencies
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  Link = require 'models/link'
  BaseView = require 'modules/base/view'
  FlashView = require 'views/other/flash'
  globals = require 'globals'
  AddLinkModal = require 'views/threads/add-link-modal'
  CommentLinkView = require 'views/comments/comment-link'

  class ThreadView extends BaseView
    template: _.template '
      <div id="thread-header">
      </div>
      <div class="row">
        <div id="statbar">
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

      # dynamic dependencies
      @StatbarView = options.StatbarView || require('views/threads/statbar')
      @ThreadHeaderView = options.ThreadHeaderView || require('views/threads/header')

      # create instances
      @addLinkModal = new AddLinkModal(model: @model)

      # event listeners
      @model.on('add:comments', @renderLinks, @)

    render: ->
      @$el.html(@template(
        t: I18n.scoped('views.threads.thread').t
        currentUser: globals.currentUser
      ))
      @renderHeader()
      @renderStatbar()
      @renderLinks()
      if globals.flash?
        @renderFlash()
      @

    renderHeader: ->
      @header = new @ThreadHeaderView(model: @model)
      @renderChildInto(@header, '#thread-header')

    renderStatbar: ->
      @statbar = new @StatbarView(model: @model)
      @renderChildInto(@statbar, '#statbar')

    renderLinks: ->
      (linksContainer = @.$('.link-list')).empty()
      self = @
      @model.getComments().each (comment) ->
        if link = comment.get('link')
          linkView = new CommentLinkView(model: comment)
          self.renderChild(linkView)
          linksContainer.prepend(linkView.el)

    renderFlash: ->
      @flash.leave() if @flash
      @flash = new FlashView(globals.flash)
      @renderChild(@flash)
      @$el.prepend(@flash.el)
      globals.flash = null

    showAddLinkModal: ->
      @renderChild(@addLinkModal)
      @addLinkModal.trigger('show')
