describe "App.ThreadListView", ->
  beforeEach ->
    @view = new App.ThreadListView()

  it "is defined with alias", ->
    expect(App.ThreadListView).toBeDefined()
    expect(App.Views.ThreadList).toBeDefined()
    expect(App.ThreadListView).toEqual(App.Views.ThreadList)

  describe "instantiation", ->
    beforeEach ->
      @view.collection = new Backbone.Collection()
      @$el = $(@view.render().el)

    it "creates a table element for a threads list", ->
      expect(@$el).toBe("table#threads_list")

    it "has bootstrap classes", ->
      expect(@$el).toHaveClass("table")
      expect(@$el).toHaveClass("table-striped")

  describe "rendering", ->
    beforeEach ->
      @listItemView = new Backbone.View()
      @listItemView.render = () ->
        @el = document.createElement('tr')
        @
      sinon.spy(@listItemView,"render")
      @listItemViewStub = sinon.stub(App, "ThreadListItemView").returns(@listItemView)
      @thread1 = new Backbone.Model()
      @thread2 = new Backbone.Model()
      @thread3 = new Backbone.Model()
      @view.collection = new Backbone.Collection([ @thread1, @thread2, @thread3 ])
      @returnVal = @view.render()

    afterEach ->
      App.ThreadListItemView.restore()

    it "returns the view object", ->
      expect(@returnVal).toEqual(@view)

    it "creates a ThreadListItemView for each model", ->
      expect(@listItemViewStub).toHaveBeenCalledThrice()
      expect(@listItemViewStub).toHaveBeenCalledWith(model: @thread1)
      expect(@listItemViewStub).toHaveBeenCalledWith(model: @thread2)
      expect(@listItemViewStub).toHaveBeenCalledWith(model: @thread3)

    it "renders each ThreadListItemView", ->
      expect(@listItemView.render).toHaveBeenCalledThrice()

    it "appends list items to the list", ->
      expect(@view.$('tbody').children().length).toEqual(3)

    it "has list item views as children (for cleanup)", ->
      expect(@view.children).toBeDefined()
      expect(@view.children.size()).toEqual(3)

  describe "dynamic jquery timeago tag", ->
    beforeEach ->
      @clock = sinon.useFakeTimers()
      @thread = new App.Thread(_(@fixtures.Thread.valid).extend(updated_at: new Date().toJSON()))
      @threads = new App.Threads([@thread])
      @view.collection = @threads
      @view.render()

    afterEach ->
      @clock.restore()

    it "fills in time tag field on new models", ->
      expect(@view.$('time.timeago')[0]).toHaveText('less than a minute ago')

    it "updates time tag as time passes", ->
      @clock.tick(60000)
      expect(@view.$('time.timeago')[0]).toHaveText('about a minute ago')
      @clock.tick(3600000)
      expect(@view.$('time.timeago')[0]).toHaveText('about an hour ago')
