define (require) ->

  $ = require('jquery')
  _ = require('underscore')
  Backbone = require('backbone')
  NavbarView = require('views/other/navbar')
  FooterView = require('views/other/footer')
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
      @FooterView = options.FooterView || FooterView
      @HomepageView = options.HomepageView || HomepageView
      @ThreadView = options.ThreadView || ThreadView
      @NewThreadView = options.NewThreadView || NewThreadView
      @Thread = options.Thread || Thread

      # initialize router
      @navbar = new @NavbarView
      @renderNavbar()
      @footer = new @FooterView(router: @)
      @renderFooter()
      @el = $('#content')
      @collection = options.collection

    renderNavbar: -> @navbar.render()
    renderFooter: -> @footer.render()

    setLocale: (locale) ->
      if locale != I18n.locale
        I18n.locale = locale
        @renderNavbar()
        @renderFooter()

    root: -> @navigate(I18n.defaultLocale, true)

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
