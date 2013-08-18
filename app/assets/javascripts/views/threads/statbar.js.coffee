define [
  'underscore'
  'modules/base/view'
  'globals'
  'i18n'
], (_, BaseView, globals, I18n) ->

  class StatbarView extends BaseView
    template: _.template '
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
      </div>'

    render: () ->
      @$el.html(@template(
        t: I18n.scoped('views.threads.statbar').t
        currentUser: globals.currentUser
        numLinks: @model.getLinks().length
        createdAt: @model.getCreatedAt()
        updatedAt: @model.getUpdatedAt()
        avatarUrl: @model.getUser().getAvatarMiniUrl()
        fullname: @model.getUser().getFullname()
        name: @model.getUserName()
      ))
      @
