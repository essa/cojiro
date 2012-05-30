window.App = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    if data.threads?
      @threads = new App.Threads(data.threads)

    window.app_router = new App.AppRouter(collection: @threads)
    if (!Backbone.history.started)
      Backbone.history.start(pushstate: true)
      Backbone.history.started = true
