define (require) ->

  Backbone = require('backbone')

  globals = require('globals')

  threadListView = new Backbone.View
  ThreadListView = sinon.stub().returns(threadListView)

  threadFilterView = new Backbone.View
  threadFilterView.render = ->
    @el = document.createElement('form')
    @el.setAttribute('id', 'thread-filter')
    @
  ThreadFilterView = sinon.stub().returns(threadFilterView)

  context(
    'views/threads/thread_list': ThreadListView
    'views/homepage/thread_filter': ThreadFilterView
    'globals': globals
  ) ['views/homepage/index'], (HomepageView) ->

    describe "HomepageView", ->
      beforeEach ->
        @thread1 = new Backbone.Model
        @thread2 = new Backbone.Model
        @thread3 = new Backbone.Model
        @threads = new Backbone.Collection([@thread1, @thread2, @thread3])
        @threads.byUser = ->
        globals.currentUser = null

      describe "instantiation", ->
        beforeEach ->
          @renderThreadListSpy = sinon.stub(HomepageView.prototype, 'renderThreadList')
          @view = new HomepageView(collection: @threads)

        afterEach ->
          @renderThreadListSpy.restore()

        it "creates a homepage element", ->
          $el = @view.$el
          expect($el).toBe('div')
          expect($el).toHaveId('homepage')

        it "assigns collection to filteredCollection", ->
          expect(@view.filteredCollection).toBe(@view.collection)

        it "binds change event on collection to 'renderThreadList'", ->
          @view.collection.trigger("change")
          expect(@renderThreadListSpy).toHaveBeenCalledOnce()

      describe "rendering", ->
        beforeEach ->
          @view = new HomepageView(collection: @threads)

        it "returns the view object", ->
          expect(@view.render()).toEqual(@view)

        describe "logged-out user", ->

          it "does not create a ThreadFilterView", ->
            @view.render()
            expect(ThreadFilterView).not.toHaveBeenCalled()

        describe "logged-in user", ->
          beforeEach ->
            globals.currentUser = @fixtures.User.valid

          afterEach ->
            globals.currentUser = null

          it "creates a new ThreadFilterView", ->
            @view.render()
            expect(ThreadFilterView.calledWithNew()).toBeTruthy()
            expect(ThreadFilterView).toHaveBeenCalledWithExactly()

          it "renders new threadFilterView", ->
            spy = sinon.spy(threadFilterView, 'render')
            @view.render()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()
            spy.restore()

        describe "thread list", ->

          it "creates a new ThreadListView", ->
            @view.render()
            expect(ThreadListView.calledWithNew()).toBeTruthy()
            expect(ThreadListView).toHaveBeenCalledWithExactly(collection: @view.filteredCollection)

          it "renders new threadListView onto the page", ->
            spy = sinon.spy(threadListView, 'render')
            @view.render()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()
            spy.restore()

      describe "Template", ->
        beforeEach ->
          @view = new HomepageView(collection: @threads)

        describe "logged-out user", ->
          beforeEach ->
            @$el = @view.render().$el

          it "renders the cojiro blurb", ->
            expect(@$el).toHaveText(/Cojiro is a platform that connects people/)
            expect(@$el).toHaveText(/Learn more/)

          it "renders message", ->
            expect(@$el).toHaveText(/create an account/)

          it "does not render thread filter", ->
            expect(@$el).not.toContain('form#thread-filter')

        describe "logged-in user", ->
          beforeEach ->
            globals.currentUser = @fixtures.User.valid
            @$el = @view.render().$el

          afterEach ->
            globals.currentUser = null

          it "does not render cojiro blurb", ->
            expect(@$el).not.toHaveText(/Cojiro is a platform that connects people/)
            expect(@$el).not.toHaveText(/Learn more/)

          it "does not render message", ->
            expect(@$el).not.toHaveText(/create an account/)

          it "renders thread filter", ->
            expect(@$el).toContain('form#thread-filter')

      describe "when filter is selected", ->
        beforeEach ->
          globals.currentUser = _(@fixtures.User.valid).extend(name: "auser")
          @filterThreadsSpy = sinon.spy(HomepageView.prototype, 'filterThreads')
          @filteredCollection = new Backbone.Collection
          sinon.stub(@threads, 'byUser').returns(@filteredCollection)
          @view = new HomepageView(collection: @threads)
          @view.render()

        afterEach ->
          globals.currentUser = null
          @filterThreadsSpy.restore()
          @threads.byUser.restore()

        it "calls filterThreads", ->
          @view.threadFilterView.trigger("changed", "mine")
          expect(@filterThreadsSpy).toHaveBeenCalledOnce()
          expect(@filterThreadsSpy).toHaveBeenCalledWith("mine")

        it "filters threads by user", ->
          @view.threadFilterView.trigger("changed", "mine")
          expect(@threads.byUser).toHaveBeenCalledOnce()
          expect(@threads.byUser).toHaveBeenCalledWith("auser")

        it "assigns result of filter to filteredCollection", ->
          @view.threadFilterView.trigger("changed", "mine")
          expect(@view.filteredCollection).toEqual(@filteredCollection)
