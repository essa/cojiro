describe "CojiroApp", ->
  it "has a namespace for Models", -> expect(CojiroApp.Models).toBeTruthy()
  it "has a namespace for Collection", -> expect(CojiroApp.Collections).toBeTruthy()
  it "has a namespace for Views", -> expect(CojiroApp.Views).toBeTruthy()
  it "has a namespace for Routers", -> expect(CojiroApp.Routers).toBeTruthy()

  describe "init()", ->
    it "accepts JSON and instantiates model from it", ->
      dataJSON =
        "thread":
          "title": "Co-working spaces in Tokyo",
          "summary": "I'm collecting blog posts on co-working spaces in Tokyo."
          "user":
            "name": "csasaki"
            "fullname": "Cojiro Sasaki"
      CojiroApp.init(dataJSON)

      expect(CojiroApp.thread).not.toEqual(undefined)
      expect(CojiroApp.thread.getTitle()).toEqual("Co-working spaces in Tokyo")
      expect(CojiroApp.thread.getSummary()).toEqual("I'm collecting blog posts on co-working spaces in Tokyo.")

    it "instantiates a Threads router", ->
      sinon.spy(CojiroApp.Routers, 'Threads')
      CojiroApp.init({})
      expect(CojiroApp.Routers.Threads).toHaveBeenCalled()
      CojiroApp.Routers.Threads.restore()

    it "starts Backbone.history", ->
      Backbone.history.started = null
      Backbone.history.stop()
      sinon.spy(Backbone.history, 'start')
      CojiroApp.init({})

      expect(Backbone.history.start).toHaveBeenCalled()

      Backbone.history.start.restore()
