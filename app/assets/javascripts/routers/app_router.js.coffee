class App.AppRouter extends Support.SwappingRouter
  routes:
    "" : "root"
    ":locale" : "index"
    ":locale/threads/new": "new"
    ":locale/threads/:id": "show"

  initialize: (options) ->
    @navbar = new App.NavbarView()
    $('#navbar').html(@navbar.render().$el)
    @el = $('#content')
    @collection = options.collection

  root: ->
    @index(I18n.locale)

  index: (locale) ->
    view = new App.HomepageView(collection: @collection)
    @swap(view)

  show: (locale, id) ->
    view = new App.ThreadView(model: @collection.get(id))
    @swap(view)

  new: (locale) ->
    thread = new App.Thread({}, collection: @collection)
    view = new App.NewThreadView(model: thread, collection: @collection)
    @swap(view)

App.Routers.AppRouter = App.AppRouter
