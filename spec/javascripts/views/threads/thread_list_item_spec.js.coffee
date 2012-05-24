describe "App.ThreadListItemView", ->
  it "renders the list view of a thread", ->
    thread = new App.Thread(@fixtures.Threads.valid)
    view = new App.ThreadListItemView(model: thread)

    $el = $(view.render().el)

    expect($el).toBe("tr")
    expect($el).toHaveText(/Co-working spaces in Tokyo/)
    expect($el).toHaveText(/csasaki/)
