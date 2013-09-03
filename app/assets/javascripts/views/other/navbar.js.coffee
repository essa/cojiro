define (require) ->

  _ = require('underscore')
  BaseView = require('modules/base/view')
  globals = require('globals')
  require('bootstrap')

  class NavbarView extends BaseView
    el: '#navbar'
    template: _.template '
      <div class="container">
        <div class="navbar-header">
          <a class="navbar-brand" href="/<%= I18n.locale %>"><img src="/images/logo.png" /></a>
        </div>
        <ul class="nav navbar-nav">
          <% if (!!currentUser) { %>
            <li>
              <a href="<%= locale + \"/threads/new\" %>">
                <%= t(".start_a_thread") %>
              </a>
            </li>
          <% } %>
        </ul>
        <ul class="nav navbar-nav navbar-right">
          <% if (!!currentUser) { %>
            <li id="profile-menu" class="dropdown">
              <a class="dropdown-toggle" data-toggle="dropdown">
                @<%= currentUser.name %> <b class="caret" />
              </a>
              <ul class="dropdown-menu">
                <li>
                  <a href="/logout?locale=<%= locale %>" data-bypass="true">
                    <%= t(".logout") %>
                  </a>
                </li>
              </ul>
            </li>
          <% } else { %>
            <li>
              <a href="/auth/twitter?locale=<%= locale %>" data-bypass="true">
                <%= t(".twitter_sign_in") %>
              </a>
            </li>
          <% } %>
        </ul>
      </div>'

    render: ->
      @$el.html(@template(
        t: I18n.scoped('views.other.navbar').t
        currentUser: globals.currentUser
        locale: I18n.locale))
      @
