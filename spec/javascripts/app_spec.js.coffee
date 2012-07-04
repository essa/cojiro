describe "App", ->
  it "has a namespace for Models", -> expect(App.Models).toBeTruthy()
  it "has a namespace for Collection", -> expect(App.Collections).toBeTruthy()
  it "has a namespace for Views", -> expect(App.Views).toBeTruthy()
  it "has a namespace for Routers", -> expect(App.Routers).toBeTruthy()

  describe "init()", ->
    beforeEach ->
      @threads = new App.Threads(@fixtures.Threads.valid)
      sinon.stub(App, 'Threads').returns(@threads)
      sinon.stub(@threads, 'fetch').returns($.Deferred().resolve())

    afterEach ->
      App.Threads.restore()

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
