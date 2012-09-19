define [
  'jquery',
  'underscore',
  'backbone',
  'views/other/navbar',
  'views/homepage/index',
  'views/threads/thread',
  'views/threads/new_thread',
  'models/thread',
  'backbone-support'
], ($, _, Backbone, NavbarView, HomepageView, ThreadView, NewThreadView, Thread) ->

  class AppRouter extends Support.SwappingRouter
    routes:
      "" : "root"
      ":locale" : "index"
      ":locale/threads/new": "new"
      ":locale/threads/:id": "show"

    initialize: (options) ->
      @navbar = new NavbarView()
      $('#navbar').html(@navbar.render().$el)
      @el = $('#content')
      @collection = options.collection

    root: ->
      @index(I18n.locale)

    index: (locale) ->
      view = new HomepageView(collection: @collection)
      @swap(view)

    show: (locale, id) ->
      view = new ThreadView(model: @collection.get(id))
      @swap(view)

    new: (locale) ->
      thread = new Thread({}, collection: @collection)
      view = new NewThreadView(model: thread, collection: @collection)
      @swap(view)
