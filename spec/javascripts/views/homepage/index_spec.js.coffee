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

    describe "logged-out user", ->
      beforeEach ->
        App.currentUser = null

      it "renders the cojiro blurb", ->
        $el = $(@homepageView.render().el)
        expect($el).toHaveText(/Cojiro is a platform that connects people/)
        expect($el).toHaveText(/Learn more/)

      it "renders message", ->
        $el = $(@homepageView.render().el)
        expect($el).toHaveText(/create an account/)


    describe "logged-out user", ->
      beforeEach ->
        App.currentUser = @fixtures.User.valid

      it "does not render cojiro blurb", ->
        $el = $(@homepageView.render().el)
        expect($el).not.toHaveText(/Cojiro is a platform that connects people/)
        expect($el).not.toHaveText(/Learn more/)

      it "does not render message", ->
        $el = $(@homepageView.render().el)
        expect($el).not.toHaveText(/create an account/)

    it "renders the thread list view onto the page", ->
      view = render: () -> el: $()
      spy = sinon.spy(view, 'render')
      sinon.stub(App, 'ThreadListView').returns(view)
      $el = $(@homepageView.render().el)
      expect(spy).toHaveBeenCalledOnce()
      App.ThreadListView.restore()
