describe 'App.Routers.AppRouter', ->
  it "is defined with alias", ->
    expect(App.AppRouter).toBeDefined()
    expect(App.Routers.AppRouter).toBeDefined()
    expect(App.AppRouter).toEqual(App.Routers.AppRouter)

  it "can be instantiated", ->
    router = new App.AppRouter
    expect(router).not.toBeNull()

  describe "routing", ->
    beforeEach ->
      @router = new App.Routers.AppRouter()
      try
        Backbone.history.start
          silent: true,
          pushState: false
      catch e
      @router.navigate "elsewhere"

    describe "index route", ->

      it "fires the index route with a blank hash", ->
        spy = sinon.spy()
        @router.bind "route:index", spy
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()

      it "instantiates a new ThreadListView", ->
        sinon.spy(App, 'ThreadListView')
        @router.navigate "", true
        expect(App.ThreadListView).toHaveBeenCalledOnce()
        expect(App.ThreadListView).toHaveBeenCalledWith(collection: App.threads)
        App.ThreadListView.restore()

      it "renders the view onto the page", ->
        view = render: () -> el: $()
        spy = sinon.spy(view, "render")
        sinon.stub(App, 'ThreadListView').returns(view)
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        App.ThreadListView.restore()

    describe "thread show route", ->

      it "fires the show route with an :id hash", ->
        spy = sinon.spy()
        @router.bind "route:show", spy
        @router.navigate "threads/1", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith("1")

      it "instantiates a new ThreadView", ->
        sinon.spy(App, 'ThreadView')
        @router.navigate "threads/1", true
        expect(App.ThreadView).toHaveBeenCalledOnce()
        App.ThreadView.restore()
