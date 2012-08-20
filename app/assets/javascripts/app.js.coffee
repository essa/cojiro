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
