define (require) ->
  createContext = require('support/create_context')

  Backbone = require('backbone')
  # need to do this bc we don't have any routes defined on the router.
  Backbone.history = new Backbone.History

  appRouter = {}
  Router = sinon.stub().returns(appRouter)

  threads = fetch: -> $.Deferred().resolve()
  Threads = () -> threads

  stubs =
    "collections/threads": Threads
    "routers/app_router": Router
    "backbone": Backbone
    "globals" :
      locale: "en"
      default_locale: "en"
      current_user: "a user"

  createContext(stubs) [
    "app"
  ], (App) ->

    describe "App", ->

      describe "init()", ->
        beforeEach ->
          sinon.spy(threads, 'fetch')

        afterEach ->
          threads.fetch.restore()

        it "sets the current user from the global settings", ->
          App.init()
          expect(App.currentUser).toBe("a user")

        it "fetches threads data", ->
          App.init()
          expect(threads.fetch).toHaveBeenCalledOnce()
          expect(threads.fetch).toHaveBeenCalledWithExactly()

        it "instantiates an AppRouter", ->
          App.init()
          expect(Router.calledWithNew()).toBeTruthy()
          expect(Router).toHaveBeenCalledWith(collection: App.threads)

        it "assigns new router to appRouter", ->
          App.init()
          expect(App.appRouter).toBe(appRouter)

        it "starts Backbone.history", ->
          Backbone.history.started = null
          Backbone.history.stop()
          sinon.spy(Backbone.history, 'start')
          App.init()

          expect(Backbone.history.start).toHaveBeenCalled()
          expect(Backbone.history.start).toHaveBeenCalledWith(pushState: true)

          Backbone.history.start.restore()
