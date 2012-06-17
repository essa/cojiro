window.App = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    if data.threads?
      @threads = new App.Threads(data.threads)

    App.appRouter = new App.AppRouter(collection: @threads)
    if (!Backbone.history.started)
      Backbone.history.start(pushState: true)
      Backbone.history.started = true
