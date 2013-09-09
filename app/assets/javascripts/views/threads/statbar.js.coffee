define (require) ->

  _ = require('underscore')
  BaseView = require('modules/base/view')
  globals = require('globals')
  I18n = require('i18n')

  class StatbarView extends BaseView
    template: _.template '
      <ul class="nav nav-pills">
        <li class="avatar">
          <img src="<%= avatarUrl %>" />
        </li>
        <li class="credit">
          <%= t(".started", { date: createdAt, name: fullname }) %>
        </li>
        <li class="sep"/>
        <li>
          <span class="stat">
            <%= numLinks %>
          </span>
          <br />
          <span class="status">
            <%= t(".links") %>
          </span>
        </li>
        <li class="sep" />
        <li>
          <span class="date"><%= updatedAt %></span>
          <br />
          <span class="status"><%= t(".updated") %></span>
        </li>
        <li class="sep" />
        <li class="participants" />
        <% if (!!currentUser) { %>
          <li class="controls pull-right">
            <a id="thread-edit" class="clickable"><icon class="icon-glyphicons-edit"></a>
          </li>
        <% } %>
      </ul>'
    className: 'statbar'

    buildEvents: () ->
      _(super).extend
        'click #thread-edit': 'showModal'

    initialize: (options) ->
      super(options)

      # dynamic dependencies
      @ThreadModal = options.ThreadModal || require('views/threads/modal')

      # create instances
      @modal = new @ThreadModal(model: @model)

      # event handlers
      @model.on('add:comments', @render, @)

    render: () ->
      @$el.html(@template(
        t: I18n.scoped('views.threads.statbar').t
        numLinks: @model.getLinks().length
        createdAt: @model.getCreatedAt()
        updatedAt: @model.getUpdatedAt()
        avatarUrl: @model.getUser().getAvatarMiniUrl()
        fullname: @model.getUser().getFullname()
        name: @model.getUserName()
        currentUser: globals.currentUser
      ))
      @renderParticipants()
      @

    renderParticipants: () ->
      self = @
      @model.getParticipants().each (p) ->
        self.$('.participants').append "<img src='#{p.getAvatarMiniUrl()}' />"

    renderModal: -> @renderChild(@modal)

    showModal: ->
      if globals.currentUser?
        @renderModal()
        @modal.trigger('show')
