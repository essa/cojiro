window.App = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    @threads = new App.Threads()
    @threads.fetch()

    App.appRouter = new App.AppRouter(collection: @threads)

    if (!Backbone.history.started)
      Backbone.history.start(pushState: true)
      Backbone.history.started = true
