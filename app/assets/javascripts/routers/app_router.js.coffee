define (require) ->

  $ = require('jquery')
  _ = require('underscore')
  Backbone = require('backbone')
  NavbarView = require('views/other/navbar')
  HomepageView = require('views/homepage/index')
  ThreadView = require('views/threads/thread')
  NewThreadView = require('views/threads/new-thread')
  Thread = require('models/thread')
  Support = require('backbone-support')
  I18n = require('i18n')

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
      @renderNavbar()
      @el = $('#content')
      @collection = options.collection

    renderNavbar: -> $('#navbar').html(@navbar.render().$el)

    setLocale: (locale) ->
      if locale != I18n.locale
        I18n.locale = locale
        @renderNavbar()

    root: -> @index(I18n.defaultLocale)

    index: (locale) ->
      @setLocale(locale)
      view = new @HomepageView(collection: @collection)
      @swap(view)

    show: (locale, id) ->
      @setLocale(locale)
      self = @
      @collection.deferred.done ->
        view = new self.ThreadView(model: self.collection.get(id))
        self.swap(view)

    new: (locale) ->
      @setLocale(locale)
      thread = new @Thread({}, collection: @collection)
      view = new @NewThreadView(model: thread, collection: @collection, router: @)
      @swap(view)
