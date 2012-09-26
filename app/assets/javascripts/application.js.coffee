require [
  'jquery',
  'underscore',
  'backbone',
  'app',
  'i18n',
  'i18n/translations',
  'config'
], ($, _, Backbone, App, I18n) ->

  $ ->
    App.init()

  # ref: https://github.com/tbranyen/backbone-boilerplate/blob/master/app/main.js
  $(document).on('click', 'a:not([data-bypass]),.clickable:not([data-bypass])', (evt) ->
    href = $(@).attr('href') || $(@).attr('data-href')

    # Ensure the protocol is not part of URL, meaning it's relative.
    if href && href.indexOf(location.protocol)
      evt.preventDefault()
      App.appRouter.navigate(href, true)
  )
