define (require) ->

  _ = require('underscore')
  Backbone = require('backbone')
  I18n = require('i18n')
  AppRouter = require('routers/app_router')

  homepageView = render: () -> {}
  HomepageView = sinon.stub().returns(homepageView)

  threadView = render: () -> {}
  ThreadView = sinon.stub().returns(threadView)

  newThreadView = render: () -> {}
  NewThreadView = sinon.stub().returns(newThreadView)

  navbarView = render: () -> {}
  NavbarView = sinon.stub().returns(navbarView)

  model = {}
  Thread = sinon.stub().returns(model)

  options =
    NavbarView: NavbarView
    HomepageView: HomepageView
    ThreadView: ThreadView
    NewThreadView: NewThreadView
    Thread: Thread

  describe 'AppRouter', ->
    beforeEach ->
      I18n.locale = 'en'

    afterEach ->
      I18n.locale = I18n.defaultLocale

    describe "initialization", ->

      it "can be instantiated", ->
        router = new AppRouter(options)
        expect(router).not.toBeNull()

      it "assigns the router's element to $('#content')", ->
        router = new AppRouter(options)
        expect(router.el).toEqual($('#content'))

      it "assigns the router's collection from the options", ->
        collection = new Object
        router = new AppRouter(_(options).extend(collection: collection))
        expect(router.collection).toEqual(collection)

    describe "routing", ->
      beforeEach ->
        @collection = new Backbone.Collection
        @router = new AppRouter(_(options).extend(collection: @collection))
        try
          Backbone.history.start
            silent: true,
            pushState: true
          Backbone.history.started = true
        catch e
        @router.navigate "elsewhere"

      afterEach ->
        @router.navigate "jasmine"

      describe "root route", ->

        it "fires the root route with a blank hash", ->
          spy = sinon.spy()
          @router.bind "route:root", spy
          @router.navigate "", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()

        it "forwards to the index route with the current locale as argument", ->
          I18n.locale = 'en'
          spy = sinon.spy(@router, 'index')
          @router.navigate "", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly("en")

      describe "index route", ->

        it "fires the index route with a locale only", ->
          spy = sinon.spy()
          @router.bind "route:index", spy
          @router.navigate "en", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly("en")

        it "instantiates a new HomepageView", ->
          @router.navigate "en", true
          expect(HomepageView.calledWithNew()).toBeTruthy()
          expect(HomepageView).toHaveBeenCalledWithExactly(collection: @collection)

        it "renders the view onto the page", ->
          spy = sinon.spy(homepageView, 'render')
          @router.navigate "", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()

      describe "thread show route", ->
        beforeEach ->
          sinon.stub(@collection, 'get').returns('thread')

        afterEach ->
          @collection.get.restore()

        it "fires the show route with a :locale and :id hash", ->
          spy = sinon.spy()
          @router.bind "route:show", spy
          @router.navigate "en/threads/1", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly("en", "1")

        it "instantiates a new ThreadView", ->
          @router.navigate "en/threads/1", true
          expect(ThreadView.calledWithNew()).toBeTruthy()
          expect(ThreadView).toHaveBeenCalledWithExactly(model: 'thread')

        it "renders the view onto the page", ->
          spy = sinon.spy(threadView, "render")
          @router.navigate 'en/threads/1', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()

      describe "new thread route", ->

        it "fires the new route with a :locale", ->
          spy = sinon.spy()
          @router.bind "route:new", spy
          @router.navigate "en/threads/new", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly("en")

        it "instantiates a new Thread", ->
          @router.navigate "en/threads/new", true
          expect(Thread.calledWithNew()).toBeTruthy()
          expect(Thread).toHaveBeenCalledWithExactly({}, collection: @collection)

        it "instantiates a new NewThreadView", ->
          @router.navigate "en/threads/new", true
          expect(NewThreadView.calledWithNew()).toBeTruthy()
          expect(NewThreadView).toHaveBeenCalledWithExactly(model: model, collection: @collection, router: @router)

        it "renders the view onto the page", ->
          spy = sinon.spy(newThreadView, 'render')
          @router.navigate "en/threads/new", true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()
