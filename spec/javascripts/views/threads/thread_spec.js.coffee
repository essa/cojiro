describe "App.ThreadView", ->
  beforeEach ->
    thread = new App.Thread()
    thread.set
      title: "Geisha bloggers",
      summary: "Looking for info on geisha bloggers."
      user:
        name: "csasaki"
        fullname: "Cojiro Sasaki"
        avatar_mini_url: "http://www.example.com/mini_csasaki.png"

    view = new App.ThreadView(model: thread)
    @el = view.render().el
    @$el = $(@el)

  it "renders the thread", ->
    expect(@$el).toBe("#thread")
    expect(@$el).toHaveText(/Geisha bloggers/)
    expect(@$el).toHaveText(/Looking for info on geisha bloggers./)

  it "renders user info", ->
    expect(@$el).toHaveText(/@csasaki/)
    expect(@$el).toHaveText(/Cojiro Sasaki/)
    expect(@$el).toContain('img[src="http://www.example.com/mini_csasaki.png"]')
