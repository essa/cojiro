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
      $el = @view.$el
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

    it "attaches a 'new' label if thread was created in the last 24 hours", ->
      @thread.set('created_at', new Date(Date.now() - 10000000).toJSON())
      $el = @view.render().$el
      expect($el).toContain('span.label.label-info')
      expect($el.find('span.label.label-info')).toHaveText("New")

    it "does not attach 'new' label if thread was created more than 24 hours ago", ->
      @thread.set('created_at', new Date(Date.now() - 100000000).toJSON())
      $el = @view.render().$el
      expect($el).not.toContain('span.label.label-info')
