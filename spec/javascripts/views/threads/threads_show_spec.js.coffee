describe "CojiroApp.Views.ThreadsShow", ->
  it "renders the thread", ->
    thread = new CojiroApp.Models.Thread()
    thread.set
      title: "Geisha bloggers",
      summary: "Looking for info on geisha bloggers."
      user:
        name: "csasaki"
        fullname: "Cojiro Sasaki"

    view = new CojiroApp.Views.ThreadsShow(model: thread)
    $el = $(view.render().el)

    expect($el).toBe("#thread")
    expect($el).toHaveText(/Geisha bloggers/)
    expect($el).toHaveText(/Looking for info on geisha bloggers./)
    expect($el).toHaveText(/csasaki/)
    expect($el).toHaveText(/Cojiro Sasaki/)
