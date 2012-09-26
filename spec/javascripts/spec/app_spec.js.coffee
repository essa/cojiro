require [
  "app",
  "collections/threads"
], (App, Threads) ->

  describe "App", ->

    describe "init()", ->
      beforeEach ->
        @threads = new Threads(@fixtures.Threads.valid)
        sinon.stub(App, 'Threads').returns(@threads)
        sinon.stub(@threads, 'fetch').returns($.Deferred().resolve())

      afterEach ->
        Threads.restore()

      it "sets the current user", ->
        @currentUser = @fixtures.User.valid
        App.init(@currentUser)
        expect(App.currentUser).toBe(@currentUser)

      it "fetches threads data", ->
        App.init()
        expect(@threads.fetch).toHaveBeenCalledOnce()
        expect(@threads.fetch).toHaveBeenCalledWithExactly()

      it "instantiates an AppRouter", ->
        sinon.spy(App, 'AppRouter')
        App.init()
        expect(App.AppRouter).toHaveBeenCalledOnce()
        expect(App.AppRouter).toHaveBeenCalledWith(collection: App.threads)
        App.AppRouter.restore()

      it "assigns new router to App.appRouter", ->
        appRouter = new Backbone.Router()
        sinon.stub(App, 'AppRouter').returns(appRouter)
        App.init()
        expect(App.appRouter).toEqual(appRouter)
        App.AppRouter.restore()

      it "starts Backbone.history", ->
        Backbone.history.started = null
        Backbone.history.stop()
        sinon.spy(Backbone.history, 'start')
        App.init()

        expect(Backbone.history.start).toHaveBeenCalled()
        expect(Backbone.history.start).toHaveBeenCalledWith(pushState: true)

        Backbone.history.start.restore()
