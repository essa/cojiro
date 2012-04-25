window.App = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    if data.threads?
      @threads = new App.Threads(data.threads)

    new App.AppRouter(collection: @threads)
    if (!Backbone.history.started)
      Backbone.history.start()
      Backbone.history.started = true
