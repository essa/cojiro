define (require) ->

  _ = require('underscore')
  Backbone = require('backbone')
  I18n = require('i18n')
  AppRouter = require('routers/app-router')

  describe 'AppRouter', ->

    beforeEach ->
      I18n.locale = 'en'

      @homepageView = render: () -> {}
      @HomepageView = sinon.stub().returns(@homepageView)

      @threadView = render: () -> {}
      @ThreadView = sinon.stub().returns(@threadView)

      @newThreadView = render: () -> {}
      @NewThreadView = sinon.stub().returns(@newThreadView)

      @navbarView = render: () ->
        @el = document.createElement('div')
        @el.setAttribute('class', 'navbar-fixed-top')
        @$el = $(@el)
        @
      @NavbarView = sinon.stub().returns(@navbarView)

      @footerView = render: () ->
      @FooterView = sinon.stub().returns(@footerView)

      @model = {}
      @Thread = sinon.stub().returns(@model)

      @options =
        NavbarView: @NavbarView
        FooterView: @FooterView
        HomepageView: @HomepageView
        ThreadView: @ThreadView
        NewThreadView: @NewThreadView
        Thread: @Thread

      @$sandbox = @createSandbox()
      @$sandbox.append($('<div id="navbar"></div>'))
      @$sandbox.append($('<div id="footer"></div>'))

    afterEach ->
      I18n.locale = I18n.defaultLocale
      @destroySandbox()

    describe 'initialization', ->

      it 'can be created', ->
        router = new AppRouter(@options)
        expect(router).not.toBeNull()

      it "assigns the router's element to $('#content')", ->
        router = new AppRouter(@options)
        expect(router.el).toEqual($('#content'))

      it "assigns the router's collection from the options", ->
        collection = new Object
        router = new AppRouter(_(@options).extend(collection: collection))
        expect(router.collection).toEqual(collection)

      it 'creates a navbar', ->
        router = new AppRouter(NavbarView: @NavbarView)
        expect(@NavbarView).toHaveBeenCalledOnce()
        expect(@NavbarView).toHaveBeenCalledWithExactly()

      it 'renders the navbar', ->
        sinon.spy(@navbarView, 'render')
        router = new AppRouter(NavbarView: @NavbarView)
        expect(@navbarView.render).toHaveBeenCalledOnce()
        expect(@navbarView.render).toHaveBeenCalledWithExactly()

      it 'creates a footer', ->
        router = new AppRouter(FooterView: @FooterView)
        expect(@FooterView).toHaveBeenCalledOnce()
        expect(@FooterView).toHaveBeenCalledWithExactly(router: router)

      it 'renders the footer', ->
        sinon.spy(@footerView, 'render')
        router = new AppRouter(FooterView: @FooterView)
        expect(@footerView.render).toHaveBeenCalledOnce()
        expect(@footerView.render).toHaveBeenCalledWithExactly()

    describe 'routing', ->
      beforeEach ->
        @collection = new Backbone.Collection
        @router = new AppRouter(_(@options).extend(collection: @collection))
        try
          Backbone.history.start
            silent: true,
            pushState: true
          Backbone.history.started = true
        catch e
        @router.navigate 'elsewhere'

      afterEach -> @router.navigate 'jasmine'

      sharedExamples = (route) ->
        it 'changes the locale', ->
          I18n.locale = 'ja'
          @router.navigate route, true
          expect(I18n.locale).toEqual('en')

        it 'renders the navbar', ->
          sinon.spy(@navbarView, 'render')
          I18n.locale = 'ja'
          @router.navigate route, true
          expect(@navbarView.render).toHaveBeenCalledOnce()
          expect(@navbarView.render).toHaveBeenCalledWithExactly()

        it 'inserts the navbar into the page', ->
          $('#navbar').empty()
          I18n.locale = 'ja'
          @router.navigate route, true
          expect($('#navbar')).toContain('.navbar-fixed-top')

        it 'renders the footer', ->
          sinon.spy(@footerView, 'render')
          I18n.locale = 'ja'
          @router.navigate route, true
          expect(@footerView.render).toHaveBeenCalledOnce()
          expect(@footerView.render).toHaveBeenCalledWithExactly()

      describe 'root route', ->

        it 'fires the root route with a blank hash', ->
          spy = sinon.spy()
          @router.bind 'route:root', spy
          @router.navigate '', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()

        it 'forwards to the index route with the default locale as argument', ->
          I18n.locale = 'ja'
          I18n.defaultLocale = 'en'
          spy = sinon.spy(@router, 'index')
          @router.navigate '', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly('en')

      describe 'index route', ->

        sharedExamples('en')

        it 'fires the index route with a locale only', ->
          spy = sinon.spy()
          @router.bind 'route:index', spy
          @router.navigate 'en', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly('en')

        it 'creates a new HomepageView', ->
          @router.navigate 'en', true
          expect(@HomepageView.calledWithNew()).toBeTruthy()
          expect(@HomepageView).toHaveBeenCalledWithExactly(collection: @collection)

        it 'renders the view onto the page', ->
          spy = sinon.spy(@homepageView, 'render')
          @router.navigate '', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()

      describe 'thread show route', ->
        beforeEach ->
          sinon.stub(@collection, 'get').returns('thread')
          @collection.deferred = @deferred = $.Deferred()
        afterEach -> @collection.get.restore()

        sharedExamples('en/threads/1')

        it 'fires the show route with a :locale and :id hash', ->
          spy = sinon.spy()
          @router.bind 'route:show', spy
          @router.navigate 'en/threads/1', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly('en', '1')

        describe 'once deferred fetch is done', ->
          beforeEach -> @deferred.resolve()

          it 'creates a new ThreadView', ->
            @router.navigate 'en/threads/1', true
            expect(@ThreadView.calledWithNew()).toBeTruthy()
            expect(@ThreadView).toHaveBeenCalledWithExactly(model: 'thread')

          it 'renders the view onto the page', ->
            spy = sinon.spy(@threadView, 'render')
            @router.navigate 'en/threads/1', true
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()
            @threadView.render.restore()

        describe 'if deferred fetch fails', ->
          beforeEach -> @deferred.reject()

          it 'does not creates a new ThreadView', ->
            @router.navigate 'en/threads/1', true
            expect(@ThreadView).not.toHaveBeenCalled()

          it 'does not render the view onto the page', ->
            spy = sinon.spy(@threadView, 'render')
            @router.navigate 'en/threads/1', true
            expect(spy).not.toHaveBeenCalled()

      describe 'new thread route', ->

        sharedExamples('en/threads/new')

        it 'fires the new route with a :locale', ->
          spy = sinon.spy()
          @router.bind 'route:new', spy
          @router.navigate 'en/threads/new', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly('en')

        it 'creates a new Thread', ->
          @router.navigate 'en/threads/new', true
          expect(@Thread.calledWithNew()).toBeTruthy()
          expect(@Thread).toHaveBeenCalledWithExactly({}, collection: @collection)

        it 'creates a new NewThreadView', ->
          @router.navigate 'en/threads/new', true
          expect(@NewThreadView.calledWithNew()).toBeTruthy()
          expect(@NewThreadView).toHaveBeenCalledWithExactly(model: @model, collection: @collection, router: @router)

        it 'renders the view onto the page', ->
          spy = sinon.spy(@newThreadView, 'render')
          @router.navigate 'en/threads/new', true
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()
