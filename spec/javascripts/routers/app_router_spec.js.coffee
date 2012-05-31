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
          pushState: true
      catch e
      @router.navigate "elsewhere"

    afterEach ->
      @router.navigate "jasmine"

    describe "index route", ->
      beforeEach ->
        @view = render: () => el: 'collection'
        sinon.stub(App, 'HomepageView').returns(@view)

      afterEach ->
        App.HomepageView.restore()

      it "fires the index route with a blank hash", ->
        spy = sinon.spy()
        @router.bind "route:index", spy
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()

      it "instantiates a new HomepageView", ->
        @router.navigate "", true
        expect(App.HomepageView).toHaveBeenCalledOnce()
        expect(App.HomepageView).toHaveBeenCalledWith(collection: App.threads)

      it "renders the view onto the page", ->
        spy = sinon.spy(@view, 'render')
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()

    describe "thread show route", ->
      beforeEach ->
        @view = render: () -> el: 'model'
        sinon.stub(App, 'ThreadView').returns(@view)
        sinon.stub(App.threads, 'get').returns('thread')

      afterEach ->
        App.ThreadView.restore()
        App.threads.get.restore()

      it "fires the show route with a :locale and :id hash", ->
        spy = sinon.spy()
        @router.bind "route:show", spy
        @router.navigate "en/threads/1", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith("en", "1")

      it "instantiates a new ThreadView", ->
        @router.navigate "en/threads/1", true
        expect(App.ThreadView).toHaveBeenCalledOnce()
        expect(App.ThreadView).toHaveBeenCalledWith(model: 'thread')

      it "renders the view onto the page", ->
        spy = sinon.spy(@view, "render")
        @router.navigate 'en/threads/1', true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()
