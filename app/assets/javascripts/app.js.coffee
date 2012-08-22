window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (currentUser) ->
    @currentUser = currentUser
    @threads = new App.Threads()
    @threads.deferred = @threads.fetch()
    self = @

    @threads.deferred.done ->
      App.appRouter = new App.AppRouter(collection: self.threads)

      if (!Backbone.history.started)
        Backbone.history.start(pushState: true)
        Backbone.history.started = true

# ref: https://github.com/tbranyen/backbone-boilerplate/blob/master/app/main.js
$(document).on('click', '[a,.clickable]:not([data-bypass])', (evt) ->
  href = $(@).attr('href') || $(@).closest('.clickable').attr('data-href')
  protocol = @protocol + '//'

  if href && (href.slice(protocol.length) != protocol)
    evt.preventDefault()
    App.appRouter.navigate(href, true)
)
