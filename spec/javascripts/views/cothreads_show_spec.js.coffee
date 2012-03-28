describe "CojiroApp.Views.CothreadsShow", ->
  it "renders the cothread", ->
    view = new CojiroApp.Views.CothreadsShow()
    view.render()

    expect(view.$el).toBe("#thread")
