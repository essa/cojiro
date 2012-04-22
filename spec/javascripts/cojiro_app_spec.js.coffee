describe "CojiroApp", ->
  it "has a namespace for Models", -> expect(CojiroApp.Models).toBeTruthy()
  it "has a namespace for Collection", -> expect(CojiroApp.Collections).toBeTruthy()
  it "has a namespace for Views", -> expect(CojiroApp.Views).toBeTruthy()
  it "has a namespace for Routers", -> expect(CojiroApp.Routers).toBeTruthy()

  describe "init()", ->
    it "accepts JSON and instantiates collections from it", ->
      threadsJSON =
        "thread":
          "title": "Co-working spaces in Tokyo",
          "summary": "I'm collecting blog posts on co-working spaces in Tokyo."
          "user":
            "name": "csasaki"
            "fullname": "Cojiro Sasaki"

      CojiroApp.init(threadsJSON)

      expect(CojiroApp.thread).not.toEqual(undefined)
      expect(CojiroApp.thread.getTitle()).toEqual("Co-working spaces in Tokyo")
      expect(CojiroApp.thread.getSummary()).toEqual("I'm collecting blog posts on co-working spaces in Tokyo.")

    it "instantiates a Threads router", ->
      # TODO: get this test to work without
      # conflicting with other tests
      #
      # CojiroApp.Routers.Threads = sinon.spy()
      # CojiroApp.init({})
      # expect(CojiroApp.Routers.Threads).toHaveBeenCalled()

    it "starts Backbone.history", ->
      # TODO: get this test to work without
      # conflicting with other tests
      #
      # Backbone.history = { start: sinon.spy() }
      # CojiroApp.init({})
      # expect(Backbone.history.start).toHaveBeenCalled()
