window.CojiroApp = 
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new CojiroApp.Routers.Cothreads()
    Backbone.history.start()
