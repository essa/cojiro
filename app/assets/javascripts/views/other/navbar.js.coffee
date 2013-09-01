define (require) ->

  _ = require('underscore')
  BaseView = require('modules/base/view')
  globals = require('globals')
  require('bootstrap')

  class NavbarView extends BaseView
    template: _.template '
      <div class="navbar-inner">
        <div class="container">
          <a class="brand" href="/<%= I18n.locale %>"><img src="/images/logo.png" /></a>
          <ul class="nav">
            <% if (!!currentUser) { %>
              <li>
                <a href="<%= locale + \"/threads/new\" %>">
                  <%= t(".start_a_thread") %>
                </a>
              </li>
            <% } %>
          </ul>
          <ul class="nav secondary-nav pull-right">
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
        </div>
      </div>'
    className: 'navbar navbar-fixed-top'

    render: ->
      @$el.html(@template(
        t: I18n.scoped('views.other.navbar').t
        currentUser: globals.currentUser
        locale: I18n.locale))
      @
