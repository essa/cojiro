describe "App.ThreadListView", ->
  beforeEach ->
    @threads = new App.Threads(@fixtures.Threads.valid)
    @view = new App.ThreadListView(collection: @threads)
    @$el = $(@view.render().el)

  it "renders a list of threads", ->
    expect(@$el).toBe("#threads_list")
    expect(@$el).toHaveText(/Co-working spaces in Tokyo/)
    expect(@$el).toHaveText(/Geisha bloggers/)
    expect(@$el).toHaveText(/csasaki/)

  it "has a leave function", ->
    expect(@view.leave).toBeDefined()

  it "has list item views as children", ->
    expect(@view.children).toBeDefined()
    expect(@view.children.size()).toEqual(2)
