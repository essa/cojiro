describe "App.HomepageView", ->
  beforeEach ->
    threads = new App.Threads(@fixtures.Threads.valid)
    @homepage_view = new App.HomepageView(collection: threads)

  it "renders the default homepage", ->
    $el = $(@homepage_view.render().el)
    expect($el).toBe("#homepage")
    expect($el).toHaveText(/Cojiro/)
    expect($el).toHaveText(/Learn more/)

  it "instantiates a new ThreadListView", ->
    sinon.spy(App, 'ThreadListView')
    $el = $(@homepage_view.render().el)
    expect(App.ThreadListView).toHaveBeenCalledOnce()
    App.ThreadListView.restore()

  it "renders the thread list view onto the page", ->
    view = render: () -> el: $()
    spy = sinon.spy(view, 'render')
    sinon.stub(App, 'ThreadListView').returns(view)
    $el = $(@homepage_view.render().el)
    expect(spy).toHaveBeenCalledOnce()
    App.ThreadListView.restore()
