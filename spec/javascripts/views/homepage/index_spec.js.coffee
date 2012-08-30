describe "App.HomepageView", ->
  beforeEach ->
    @thread1 = new Backbone.Model
    @thread2 = new Backbone.Model
    @thread3 = new Backbone.Model
    @threads = new Backbone.Collection([@thread1, @thread2, @thread3])
    @threads.byUser = ->
    @threadListView = new Backbone.View
    @threadFilterView = new Backbone.View
    @threadFilterView.render = ->
      @el = document.createElement('form')
      @el.setAttribute('id', 'thread-filter')
      @
    sinon.stub(App, 'ThreadListView').returns(@threadListView)
    sinon.stub(App, 'ThreadFilterView').returns(@threadFilterView)

  afterEach ->
    App.ThreadListView.restore()
    App.ThreadFilterView.restore()

  it "is defined with alias", ->
    expect(App.HomepageView).toBeDefined()
    expect(App.Views.Homepage).toBeDefined()
    expect(App.HomepageView).toEqual(App.Views.Homepage)

  describe "instantiation", ->
    beforeEach ->
      @renderThreadListSpy = sinon.stub(App.HomepageView.prototype, 'renderThreadList')
      @view = new App.HomepageView(collection: @threads)

    afterEach ->
      @renderThreadListSpy.restore()

    it "assigns collection to filteredCollection", ->
      expect(@view.filteredCollection).toBe(@view.collection)

    it "binds change event on collection to 'renderThreadList'", ->
      @view.collection.trigger("change")
      expect(@renderThreadListSpy).toHaveBeenCalledOnce()

  describe "rendering", ->
    beforeEach ->
      @view = new App.HomepageView(collection: @threads)

    it "returns the view object", ->
      expect(@view.render()).toEqual(@view)

    describe "logged-out user", ->

      it "does not create a ThreadFilterView", ->
        @view.render()
        expect(App.ThreadFilterView).not.toHaveBeenCalled()

    describe "logged-in user", ->
      beforeEach ->
        App.currentUser = @fixtures.User.valid

      afterEach ->
        App.currentUser = null

      it "creates a new ThreadFilterView", ->
        @view.render()
        expect(App.ThreadFilterView).toHaveBeenCalledOnce()
        expect(App.ThreadFilterView).toHaveBeenCalledWithExactly()

      it "renders new threadFilterView", ->
        spy = sinon.spy(@threadFilterView, 'render')
        @view.render()
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()
        spy.restore()

    describe "thread list", ->

      it "creates a new ThreadListView", ->
        @view.render()
        expect(App.ThreadListView).toHaveBeenCalledOnce()
        expect(App.ThreadListView).toHaveBeenCalledWithExactly(collection: @view.filteredCollection)

      it "renders new threadListView onto the page", ->
        spy = sinon.spy(@threadListView, 'render')
        @view.render()
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()
        spy.restore()

  describe "Template", ->
    beforeEach ->
      @view = new App.HomepageView(collection: @threads)

    it "renders the default homepage", ->
      $el = @view.render().$el
      expect($el).toBe("#homepage")
      expect($el).toHaveText(/Cojiro/)

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
        App.currentUser = @fixtures.User.valid
        @$el = @view.render().$el

      afterEach ->
        App.currentUser = null

      it "does not render cojiro blurb", ->
        expect(@$el).not.toHaveText(/Cojiro is a platform that connects people/)
        expect(@$el).not.toHaveText(/Learn more/)

      it "does not render message", ->
        expect(@$el).not.toHaveText(/create an account/)

      it "renders thread filter", ->
        expect(@$el).toContain('form#thread-filter')

  describe "when filter is selected", ->
    beforeEach ->
      App.currentUser = _(@fixtures.User.valid).extend(name: "auser")
      @filterThreadsSpy = sinon.spy(App.HomepageView.prototype, 'filterThreads')
      @filteredCollection = new App.Threads
      sinon.stub(@threads, 'byUser').returns(@filteredCollection)
      @view = new App.HomepageView(collection: @threads)
      @view.render()

    afterEach ->
      App.currentUser = null
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
