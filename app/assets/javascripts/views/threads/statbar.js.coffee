define [
  'underscore'
  'modules/base/view'
  'i18n'
], (_, BaseView, I18n) ->

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
      </ul>'
    className: 'statbar'

    initialize: (options) ->
      super(options)
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
      ))
      @
