class App.Routers.AppRouter extends Backbone.Router
  routes:
    "" : "index"

  index: ->
    view = new App.Views.ThreadList( collection: App.threads )
    $('.content').html(view.render().el)
