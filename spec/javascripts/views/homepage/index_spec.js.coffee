describe "App.HomepageView", ->
  beforeEach ->
    threads = new App.Threads(@fixtures.Threads.valid)
    @homepage_view = new App.HomepageView(collection: threads)

  it "is defined with alias", ->
    expect(App.HomepageView).toBeDefined()
    expect(App.Views.Homepage).toBeDefined()
    expect(App.HomepageView).toEqual(App.Views.Homepage)

  describe "instantiation", ->

    it "instantiates a new ThreadListView", ->
      sinon.spy(App, 'ThreadListView')
      $el = $(@homepage_view.render().el)
      expect(App.ThreadListView).toHaveBeenCalledOnce()
      App.ThreadListView.restore()

  describe "rendering", ->

    it "returns the view object", ->
      expect(@homepage_view.render()).toEqual(@homepage_view)

    it "renders the default homepage", ->
      $el = $(@homepage_view.render().el)
      expect($el).toBe("#homepage")
      expect($el).toHaveText(/Cojiro/)
      expect($el).toHaveText(/Learn more/)

    it "renders the thread list view onto the page", ->
      view = render: () -> el: $()
      spy = sinon.spy(view, 'render')
      sinon.stub(App, 'ThreadListView').returns(view)
      $el = $(@homepage_view.render().el)
      expect(spy).toHaveBeenCalledOnce()
      App.ThreadListView.restore()
