describe "App.ThreadListItemView", ->
  beforeEach ->
    @thread = new App.Thread(@fixtures.Thread.valid)
    @view = new App.ThreadListItemView(model: @thread)
    @$el = $(@view.render().el)

  describe "instantiation", ->

    it "creates a table row for a thread", ->
      expect(@$el).toBe("tr#thread-list-item")

  describe "rendering", ->

    it "renders the list item view into the table row", ->
      expect(@$el).toHaveText(/Co-working spaces in Tokyo/)
      expect(@$el).toHaveText(/csasaki/)
