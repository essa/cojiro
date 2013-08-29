define (require) ->

  _ = require('underscore')
  BaseView = require('modules/base/view')
  globals = require('globals')
  I18n = require('i18n')

  class StatbarView extends BaseView
    template: _.template '
      <ul class="nav nav-pills">
        <li>
          <span class="stat">
            <%= numLinks %>
          </span>
          <br />
          <span class="stattext">
            <%= t(".links") %>
          </span>
        </li>
        <li class="sep" />
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
        <li class="sep"/>
        <li>
          <span class="date"><%= updatedAt %></span>
          <br />
          <span class="status"><%= t(".updated") %></span>
        </li>
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
      @

    renderModal: -> @renderChild(@modal)

    showModal: ->
      if globals.currentUser?
        @renderModal()
        @modal.trigger('show')
