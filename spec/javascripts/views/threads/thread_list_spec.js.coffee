describe "App.ThreadListView", ->
  it "renders a list of threads", ->
    threads = new App.Threads([ @fixtures.Thread.valid ])
    view = new App.ThreadListView(collection: threads)

    $el = $(view.render().el)

    expect($el).toBe("#threads_list")
    expect($el).toHaveText(/Co-working spaces in Tokyo/)
    expect($el).toHaveText(/csasaki/)
