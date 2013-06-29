require [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'i18n'
  'bootstrap-dropdown'
  'bootstrap-button'
  'bootstrap-alert'
  'bootstrap-modal'
], ($, _, Backbone, App) ->

  $ ->
    # we don't want to actually hit the server if we're running jasmine tests
    window.app = new App
    app.init() unless jasmine?

  # ref: https://github.com/tbranyen/backbone-boilerplate/blob/master/app/main.js
  $(document).on('click', 'a:not([data-bypass]),.clickable:not([data-bypass])', (evt) ->
    href = $(@).attr('href') || $(@).attr('data-href')

    # Ensure the protocol is not part of URL, meaning it's relative.
    if href && href.indexOf(location.protocol)
      evt.preventDefault()
      app.appRouter.navigate(href, true)
  )
