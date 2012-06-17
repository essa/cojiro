describe 'App.AppRouter', ->

  it "is defined with alias", ->
    expect(App.AppRouter).toBeDefined()
    expect(App.Routers.AppRouter).toBeDefined()
    expect(App.AppRouter).toEqual(App.Routers.AppRouter)

  describe "instantiation", ->

    it "can be instantiated", ->
      router = new App.AppRouter
      expect(router).not.toBeNull()

    it "assigns the router's element to $('.content')", ->
      router = new App.AppRouter
      expect(router.el).toEqual($('.content'))

    it "assigns the router's collection from the options", ->
      collection = new Object
      router = new App.AppRouter(collection: collection)
      expect(router.collection).toEqual(collection)

  describe "routing", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @router = new App.Routers.AppRouter(collection: @collection)
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
        expect(spy).toHaveBeenCalledWithExactly()

      it "forwards to the index route with the current locale as argument", ->
        spy = sinon.spy(@router, 'index')
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly("en")

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
        expect(spy).toHaveBeenCalledWithExactly("en")

      it "instantiates a new HomepageView", ->
        @router.navigate "en", true
        expect(App.HomepageView).toHaveBeenCalledOnce()
        expect(App.HomepageView).toHaveBeenCalledWithExactly(collection: @collection)

      it "sets the locale", ->
        I18n.locale = 'de'
        @router.navigate 'en', true
        expect(I18n.locale).toEqual('en')

      it "renders the view onto the page", ->
        spy = sinon.spy(@view, 'render')
        @router.navigate "", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()

    describe "thread show route", ->
      beforeEach ->
        @view = render: () -> el: 'model'
        sinon.stub(App, 'ThreadView').returns(@view)
        sinon.stub(@collection, 'get').returns('thread')

      afterEach ->
        App.ThreadView.restore()
        @collection.get.restore()

      it "fires the show route with a :locale and :id hash", ->
        spy = sinon.spy()
        @router.bind "route:show", spy
        @router.navigate "en/threads/1", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly("en", "1")

      it "instantiates a new ThreadView", ->
        @router.navigate "en/threads/1", true
        expect(App.ThreadView).toHaveBeenCalledOnce()
        expect(App.ThreadView).toHaveBeenCalledWithExactly(model: 'thread')

      it "renders the view onto the page", ->
        spy = sinon.spy(@view, "render")
        @router.navigate 'en/threads/1', true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()

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
        expect(spy).toHaveBeenCalledWithExactly("en")

      it "instantiates a new Thread", ->
        @router.navigate "en/threads/new", true
        expect(App.Thread).toHaveBeenCalledOnce()
        expect(App.Thread).toHaveBeenCalledWithExactly({}, collection: @collection)

      it "instantiates a new NewThreadView", ->
        @router.navigate "en/threads/new", true
        expect(App.NewThreadView).toHaveBeenCalledOnce()
        expect(App.NewThreadView).toHaveBeenCalledWithExactly(model: @model, collection: @collection)

      it "renders the view onto the page", ->
        spy = sinon.spy(@view, 'render')
        @router.navigate "en/threads/new", true
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()
