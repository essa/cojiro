App.AppRouter = App.Routers.AppRouter = Support.SwappingRouter.extend
  routes:
    "" : "root"
    ":locale" : "index"
    ":locale/threads/:id": "show"

  initialize: ->
    @el = $('.content')

  root: ->
    @index(I18n.locale)

  index: (locale) ->
    I18n.locale = locale
    view = new App.HomepageView( collection: App.threads )
    @swap(view)

  show: (locale, id) ->
    view = new App.ThreadView( model: App.threads.get(id) )
    @swap(view)
