App.AppRouter = App.Routers.AppRouter = Backbone.Router.extend
  routes:
    "" : "index"

  index: ->
    view = new App.ThreadListView( collection: App.threads )
    $('.content').html(view.render().el)