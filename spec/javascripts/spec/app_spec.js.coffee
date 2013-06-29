define (require) ->
  Backbone = require('backbone')
  App = require('app')

  appRouter = {}
  AppRouter = sinon.stub().returns(appRouter)

  threads = fetch: -> $.Deferred().resolve()
  Threads = sinon.stub().returns(threads)

  globals =
    locale: 'en'
    currentUser: 'a user'

  options =
    Threads: Threads
    AppRouter: AppRouter
    globals: globals

  app = new App(options)

  describe "App", ->
    describe "init()", ->
      beforeEach ->
        sinon.spy(threads, 'fetch')

      afterEach ->
        threads.fetch.restore()

      it "sets the current user from the global settings", ->
        app.init()
        expect(app.currentUser).toBe("a user")

      it "fetches threads data", ->
        app.init()
        expect(threads.fetch).toHaveBeenCalledOnce()
        expect(threads.fetch).toHaveBeenCalledWithExactly()

      it "instantiates an AppRouter", ->
        app.init()
        expect(AppRouter.calledWithNew()).toBeTruthy()
        expect(AppRouter).toHaveBeenCalledWith(collection: app.threads)

      it "assigns new router to appRouter", ->
        app.init()
        expect(app.appRouter).toBe(appRouter)

      it "starts Backbone.history", ->
        Backbone.history.started = null
        Backbone.history.stop()
        sinon.spy(Backbone.history, 'start')
        app.init()

        expect(Backbone.history.start).toHaveBeenCalled()
        expect(Backbone.history.start).toHaveBeenCalledWith(pushState: true)

        Backbone.history.start.restore()
