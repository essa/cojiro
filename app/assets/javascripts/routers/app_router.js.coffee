define [
  'jquery'
  'underscore'
  'backbone'
  'views/other/navbar'
  'views/homepage/index'
  'views/threads/thread'
  'views/threads/new-thread'
  'models/thread'
  'backbone-support'
  'i18n'
], ($, _, Backbone, NavbarView, HomepageView, ThreadView, NewThreadView, Thread, Support, I18n) ->

  class AppRouter extends Support.SwappingRouter
    routes:
      '' : 'root'
      ':locale' : 'index'
      ':locale/threads/new': 'new'
      ':locale/threads/:id': 'show'

    initialize: (options = {}) ->
      # isolate dependencies
      @NavbarView = options.NavbarView || NavbarView
      @HomepageView = options.HomepageView || HomepageView
      @ThreadView = options.ThreadView || ThreadView
      @NewThreadView = options.NewThreadView || NewThreadView
      @Thread = options.Thread || Thread

      # initialize router
      @navbar = new @NavbarView
      $('#navbar').html(@navbar.render().$el)
      @el = $('#content')
      @collection = options.collection

    root: ->
      @index(I18n.locale)

    index: (locale) ->
      view = new @HomepageView(collection: @collection)
      @swap(view)

    show: (locale, id) ->
      self = @
      @collection.deferred.done ->
        view = new self.ThreadView(model: self.collection.get(id))
        self.swap(view)

    new: (locale) ->
      thread = new @Thread({}, collection: @collection)
      view = new @NewThreadView(model: thread, collection: @collection, router: @)
      @swap(view)
