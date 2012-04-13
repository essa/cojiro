describe "CojiroApp.Views.CothreadsShow", ->
  it "renders the cothread", ->
    cothread = new CojiroApp.Models.Cothread()
    cothread.set
      title: "Geisha bloggers",
      summary: "Looking for info on geisha bloggers."

    view = new CojiroApp.Views.CothreadsShow(model: cothread)
    $el = $(view.render().el)

    expect($el).toBe("#thread")
    expect($el).toHaveText(/Geisha bloggers/)
    expect($el).toHaveText(/Looking for info on geisha bloggers./)
