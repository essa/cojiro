describe "App.HomepageView", ->
  beforeEach ->
    @threads = new App.Threads(@fixtures.Threads.valid)

  it "is defined with alias", ->
    expect(App.HomepageView).toBeDefined()
    expect(App.Views.Homepage).toBeDefined()
    expect(App.HomepageView).toEqual(App.Views.Homepage)

  describe "instantiation", ->
    beforeEach ->
      @renderThreadListSpy = sinon.spy(App.HomepageView.prototype, 'renderThreadList')
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
      beforeEach ->
        sinon.spy(App, 'ThreadFilterView')

      afterEach ->
        App.ThreadFilterView.restore()

      it "does not create a ThreadFilterView", ->
        @view.render()
        expect(App.ThreadFilterView).not.toHaveBeenCalled()

    describe "logged-in user", ->
      beforeEach ->
        App.currentUser = @fixtures.User.valid
        @threadFilterViewStub = new Backbone.View
        sinon.stub(App, 'ThreadFilterView').returns(@threadFilterViewStub)

      afterEach ->
        App.currentUser = null
        App.ThreadFilterView.restore()

      it "creates a new ThreadFilterView", ->
        @view.render()
        expect(App.ThreadFilterView).toHaveBeenCalledOnce()
        expect(App.ThreadFilterView).toHaveBeenCalledWithExactly()

      it "renders new threadFilterView", ->
        spy = sinon.spy(@threadFilterViewStub, 'render')
        @view.render()
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()

    describe "thread list", ->
      beforeEach ->
        @threadListViewStub = new Backbone.View
        sinon.stub(App, 'ThreadListView').returns(@threadListViewStub)

      afterEach ->
        App.ThreadListView.restore()

      it "creates a new ThreadListView", ->
        @view.render()
        expect(App.ThreadListView).toHaveBeenCalledOnce()
        expect(App.ThreadListView).toHaveBeenCalledWithExactly(collection: @view.filteredCollection)

      it "renders new threadListView onto the page", ->
        spy = sinon.spy(@threadListViewStub, 'render')
        @view.render()
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()

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
      App.currentUser = @fixtures.User.valid
      @filterThreadsSpy = sinon.spy(App.HomepageView.prototype, 'filterThreads')
      @view = new App.HomepageView(collection: @threads)
      @view.render()

    afterEach ->
      App.currentUser = null
      @filterThreadsSpy.restore()

    it "calls filterThreads", ->
      @view.threadFilterView.trigger("changed", "mine")
      expect(@filterThreadsSpy).toHaveBeenCalledOnce()
      expect(@filterThreadsSpy).toHaveBeenCalledWith("mine")
