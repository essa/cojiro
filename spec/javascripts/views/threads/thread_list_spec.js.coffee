describe "App.ThreadListView", ->
  it "renders a list of threads", ->
    threads = new App.Threads(@fixtures.Threads.valid)
    view = new App.ThreadListView(collection: threads)

    $el = $(view.render().el)

    expect($el).toBe("#threads_list")
    expect($el).toHaveText(/Co-working spaces in Tokyo/)
    expect($el).toHaveText(/Geisha bloggers/)
    expect($el).toHaveText(/csasaki/)
