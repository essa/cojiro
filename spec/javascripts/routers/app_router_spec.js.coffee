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

    describe "root route", ->
      beforeEach ->
        I18n.locale = 'en'

      it "fires the root route with a blank hash", ->
        spy = sinon.spy()
        @router.bind "route:root", spy
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()

      it "forwards to the index route with the current locale as argument", ->
        spy = sinon.spy(@router, 'index')
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith("en")

    describe "index route", ->
      beforeEach ->
        @view = render: () => el: 'collection'
        sinon.stub(App, 'HomepageView').returns(@view)

      afterEach ->
        App.HomepageView.restore()

      it "fires the index route with a locale only", ->
        spy = sinon.spy()
        @router.bind "route:index", spy
        @router.navigate "en", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith("en")

      it "instantiates a new HomepageView", ->
        @router.navigate "en", true
        expect(App.HomepageView).toHaveBeenCalledOnce()
        expect(App.HomepageView).toHaveBeenCalledWith(collection: App.threads)

      it "sets the locale", ->
        I18n.locale = 'de'
        @router.navigate 'en', true
        expect(I18n.locale).toEqual('en')

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

    describe "new thread route", ->
      beforeEach ->
        @model = new Backbone.Model()
        @view =
          render: () -> @
        sinon.stub(App, 'Thread').returns(@model)
        sinon.stub(App, 'NewThreadView').returns(@view)

      afterEach ->
        App.Thread.restore()
        App.NewThreadView.restore()

      it "fires the new route with a :locale", ->
        spy = sinon.spy()
        @router.bind "route:new", spy
        @router.navigate "en/threads/new", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith("en")

      it "instantiates a new Thread", ->
        @router.navigate "en/threads/new", true
        expect(App.Thread).toHaveBeenCalledOnce()
        expect(App.Thread).toHaveBeenCalledWith()

      it "instantiates a new NewThreadView", ->
        @router.navigate "en/threads/new", true
        expect(App.NewThreadView).toHaveBeenCalledOnce()
        expect(App.NewThreadView).toHaveBeenCalledWith(model: @model)

      it "renders the view onto the page", ->
        spy = sinon.spy(@view, 'render')
        @router.navigate "en/threads/new", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()
