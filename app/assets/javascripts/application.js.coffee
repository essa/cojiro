require [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'i18n'
  'bootstrap-dropdown'
  'bootstrap-button'
  'bootstrap-alert'
], ($, _, Backbone, App) ->

  $ ->
    # check for locale stops init from being called in tests
    App.init() unless I18n.locale is undefined

  # ref: https://github.com/tbranyen/backbone-boilerplate/blob/master/app/main.js
  $(document).on('click', 'a:not([data-bypass]),.clickable:not([data-bypass])', (evt) ->
    href = $(@).attr('href') || $(@).attr('data-href')

    # Ensure the protocol is not part of URL, meaning it's relative.
    if href && href.indexOf(location.protocol)
      evt.preventDefault()
      App.appRouter.navigate(href, true)
  )
