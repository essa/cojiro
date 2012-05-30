describe "App.ThreadListView", ->
  beforeEach ->
    @view = new App.ThreadListView(collection: new Backbone.Collection([]))

  describe "instantiation", ->
    beforeEach ->
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
      @view.render()

    afterEach ->
      App.ThreadListItemView.restore()

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
