describe "App.ThreadListItemView", ->
  beforeEach ->
    @thread = new App.Thread(@fixtures.Thread.valid)
    @thread.collection = new App.Threads()
    @view = new App.ThreadListItemView(model: @thread)

  it "is defined with alias", ->
    expect(App.ThreadListItemView).toBeDefined()
    expect(App.Views.ThreadListItem).toBeDefined()
    expect(App.ThreadListItemView).toEqual(App.Views.ThreadListItem)

  describe "instantiation", ->

    it "creates a table row for a thread", ->
      $el = $(@view.render().el)
      expect($el).toBe("tr#thread-list-item")
      expect($el).toHaveAttr('data-href', '/en/threads/5')

  describe "rendering", ->

    it "returns the view object", ->
      expect(@view.render()).toEqual(@view)

    it "renders the list item view into the table row", ->
      $el = $(@view.render().el)
      expect($el.find('td')).toHaveText(/Co-working spaces in Tokyo/)
      expect($el.find('td')).toHaveText(/csasaki/)

    it "renders the update timestamp", ->
      @thread.set('updated_at', "2012-08-22T00:06:21Z")
      $el = $(@view.render().el)
      expect($el.find('time.timeago')).toHaveAttr('datetime', '2012-08-22T00:06:21Z')
