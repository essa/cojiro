describe "App.FlashView", ->
  beforeEach ->
    @view = new App.FlashView()
    @$el = $(@view.el)

  it "is defined with alias", ->
    expect(App.FlashView).toBeDefined()
    expect(App.Views.Flash).toBeDefined()
    expect(App.FlashView).toEqual(App.Views.Flash)

  describe "instantiation", ->

    it "creates a new flash element", ->
      expect(@$el).toBe("#flash_error")
      expect(@$el).toHaveClass("alert alert-error error")
      expect(@$el).toHaveAttr("data-dismiss", "alert")

    it "adds a close link", ->
      expect(@$el).toContain('.close')
