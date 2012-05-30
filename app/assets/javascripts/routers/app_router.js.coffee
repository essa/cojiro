App.AppRouter = App.Routers.AppRouter = Backbone.Router.extend
  routes:
    "" : "index"
    ":locale/threads/:id": "show"

  index: ->
    view = new App.HomepageView( collection: App.threads )
    $('.content').html(view.render().el)

  show: (locale, id) ->
    view = new App.ThreadView( model: App.threads.models[id] )
