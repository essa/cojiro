describe "App.ThreadListItemView", ->
  beforeEach ->
    @thread = new App.Thread(@fixtures.Thread.valid)
    @thread.collection = new App.Threads()
    @view = new App.ThreadListItemView(model: @thread)

  describe "instantiation", ->

    it "creates a table row for a thread", ->
      @$el = $(@view.render().el)
      expect(@$el).toBe("tr#thread-list-item")

  describe "rendering", ->

    it "returns the view object", ->
      expect(@view.render()).toEqual(@view)

    it "renders the list item view into the table row", ->
      @$el = $(@view.render().el)
      expect(@$el.find('td')).toHaveText(/Co-working spaces in Tokyo/)
      expect(@$el.find('td')).toHaveText(/csasaki/)
      expect(@$el.find('td a')).toHaveAttr('href', 'en/threads/5')
