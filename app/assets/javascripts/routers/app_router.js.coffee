App.AppRouter = App.Routers.AppRouter = Support.SwappingRouter.extend
  routes:
    "" : "index"
    ":locale/threads/:id": "show"

  initialize: ->
    @el = $('.content')

  index: ->
    view = new App.HomepageView( collection: App.threads )
    @swap(view)

  show: (locale, id) ->
    view = new App.ThreadView( model: App.threads.get(id) )
    @swap(view)
