describe "App.HomepageView", ->
  beforeEach ->
    threads = new App.Threads(@fixtures.Threads.valid)
    @homepageView = new App.HomepageView(collection: threads)

  it "is defined with alias", ->
    expect(App.HomepageView).toBeDefined()
    expect(App.Views.Homepage).toBeDefined()
    expect(App.HomepageView).toEqual(App.Views.Homepage)

  describe "instantiation", ->

    it "instantiates a new ThreadListView", ->
      sinon.spy(App, 'ThreadListView')
      $el = $(@homepageView.render().el)
      expect(App.ThreadListView).toHaveBeenCalledOnce()
      App.ThreadListView.restore()

  describe "rendering", ->

    it "returns the view object", ->
      expect(@homepageView.render()).toEqual(@homepageView)

    it "renders the default homepage", ->
      $el = $(@homepageView.render().el)
      expect($el).toBe("#homepage")
      expect($el).toHaveText(/Cojiro/)
      expect($el).toHaveText(/Learn more/)

    it "renders the thread list view onto the page", ->
      view = render: () -> el: $()
      spy = sinon.spy(view, 'render')
      sinon.stub(App, 'ThreadListView').returns(view)
      $el = $(@homepageView.render().el)
      expect(spy).toHaveBeenCalledOnce()
      App.ThreadListView.restore()
