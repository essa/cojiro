define (require) ->

  _ = require('underscore')
  Backbone = require('backbone')
  BaseView = require('modules/base/view')
  globals = require('globals')
  I18n = require('i18n')

  class FooterView extends BaseView
    el: '#footer'
    template: _.template '
        <div class="container">
          <ul class="nav navbar-nav navbar-right">
            <li id="locale-switcher" class="dropdown">
              <a class="dropdown-toggle clickable" data-toggle="dropdown">
                <%= t(".language") %> <b class="caret" />
              </a>
              <ul class="dropdown-menu">
                <% _(locales).each(function(locale) { %>
                  <li class="<% if (I18n.locale == locale) { %>disabled<% } %>">
                    <a lang="<%= locale %>" class="locale clickable">
                      <%= I18n.localeInWords(locale) %>
                    </a>
                  </li>
                <% }); %>
              </ul>
            </li>
          </ul>
        </div>
      '

    buildEvents: () ->
      _(super).extend
        'click a.locale': 'switchLocale'

    initialize: (options = {}) ->
      @router = options.router
      super

    render: ->
      @$el.html(@template(t: I18n.scoped('views.other.footer').t, locales: I18n.availableLocales))
      @

    switchLocale: (e) ->
      newLocale = e.currentTarget.lang
      if (newLocale in I18n.availableLocales)
        newFragment = Backbone.history.fragment.replace(new RegExp("^#{I18n.locale}"), newLocale)
        @router.navigate(newFragment, true)
