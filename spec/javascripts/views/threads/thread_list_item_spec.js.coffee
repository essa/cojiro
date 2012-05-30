describe "App.ThreadListItemView", ->
  beforeEach ->
    @thread = new App.Thread(@fixtures.Thread.valid)
    @view = new App.ThreadListItemView(model: @thread)
    @$el = $(@view.render().el)

  it "renders the list view of a thread", ->
    expect(@$el).toBe("tr")
    expect(@$el).toHaveText(/Co-working spaces in Tokyo/)
    expect(@$el).toHaveText(/csasaki/)

  it "has a leave function", ->
    expect(@view.leave).toBeDefined()

