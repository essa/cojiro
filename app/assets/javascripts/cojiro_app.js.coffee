window.CojiroApp = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (data) ->
    @thread = new CojiroApp.Models.Thread(data.thread)

    new CojiroApp.Routers.Threads(model: @thread)
    if (!Backbone.history.started)
      Backbone.history.start()
      Backbone.history.started = true
