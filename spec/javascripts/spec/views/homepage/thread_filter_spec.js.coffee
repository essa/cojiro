describe "App.ThreadFilterView", ->
  beforeEach ->
    @selectFilterSpy = sinon.spy(App.ThreadFilterView.prototype, 'selectFilter')
    @view = new App.ThreadFilterView()

  afterEach ->
    @selectFilterSpy.restore()

  it "is defined with alias", ->
    expect(App.ThreadFilterView).toBeDefined()
    expect(App.Views.ThreadFilter).toBeDefined()
    expect(App.ThreadFilterView).toEqual(App.Views.ThreadFilter)

  describe "instantiation", ->

    it "creates a thread filter form", ->
      $el = @view.$el
      expect($el).toBe("form")
      expect($el).toHaveClass("commentheader form-horizontal")
      expect($el).toHaveId("thread-filter")

  describe "rendering", ->

    it "returns the view object", ->
      expect(@view.render()).toEqual(@view)

    it "renders the filter options", ->
      $el = @view.render().$el
      expect($el).toContain('option[value=\"all\"]')
      expect($el).toContain('option[value=\"mine\"]')

  describe "when option is selected", ->
    beforeEach ->
      @view.render()
      @$select = @view.$('select')

    it "calls selectFilter", ->
      @$select.val('mine').change()
      expect(@selectFilterSpy).toHaveBeenCalledOnce()

    it "triggers event", ->
      sinon.spy(@view, 'trigger')
      @$select.val('mine').change()
      expect(@view.trigger).toHaveBeenCalledOnce()
      expect(@view.trigger).toHaveBeenCalledWith("changed", "mine")
