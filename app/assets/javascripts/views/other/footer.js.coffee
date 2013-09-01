define (require) ->

  _ = require('underscore')
  Backbone = require('backbone')
  BaseView = require('modules/base/view')
  globals = require('globals')
  I18n = require('i18n')
  require('bootstrap')

  class FooterView extends BaseView
    template: _.template '
        <div class="navbar-inner">
          <div class="container">
            <ul class="nav secondary-nav pull-right">
              <li id="locale-switcher" class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown">
                  Language <b class="caret" />
                </a>
                <ul class="dropdown-menu">
                  <% _(locales).each(function(locale) { %>
                    <li>
                      <a lang="<%= locale %>" class="locale clickable">
                        <%= I18n.localeInWords(locale) %>
                      </a>
                    </li>
                  <% }); %>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      '
    className: 'navbar navbar-fixed-bottom'

    buildEvents: () ->
      _(super).extend
        'click a.locale': 'switchLocale'

    initialize: (options = {}) ->
      @router = options.router
      super

    render: ->
      @$el.html(@template(locales: I18n.availableLocales))
      @

    switchLocale: (e) ->
      newLocale = e.currentTarget.lang
      console.log(newLocale)
      if (newLocale in I18n.availableLocales)
        newFragment = Backbone.history.fragment.replace(new RegExp("^#{I18n.locale}"), newLocale)
        @router.navigate(newFragment, true)
