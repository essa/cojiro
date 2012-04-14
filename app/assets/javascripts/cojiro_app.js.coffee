window.CojiroApp = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @cothread = new CojiroApp.Models.Cothread(data.cothread)

    new CojiroApp.Routers.Cothreads(model: @cothread)
    if (!Backbone.history.started)
      Backbone.history.start()
      Backbone.history.started = true
