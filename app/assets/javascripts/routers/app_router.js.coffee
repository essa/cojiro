App.AppRouter = App.Routers.AppRouter = Backbone.Router.extend
  routes:
    "" : "index"
    ":id": "show"

  index: ->
    view = new App.ThreadListView( collection: App.threads )
    $('.content').html(view.render().el)

  show: (id) ->
    #view = new App.ThreadView( model: App.threads.models[id] )
    #$('content').html(view.render().el)
