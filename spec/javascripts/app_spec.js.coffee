describe "App", ->
  it "has a namespace for Models", -> expect(App.Models).toBeTruthy()
  it "has a namespace for Collection", -> expect(App.Collections).toBeTruthy()
  it "has a namespace for Views", -> expect(App.Views).toBeTruthy()
  it "has a namespace for Routers", -> expect(App.Routers).toBeTruthy()

  describe "init()", ->
    it "accepts JSON and instantiates model from it", ->
      dataJSON =
        "threads":
          [
            "title": "Co-working spaces in Tokyo",
            "summary": "I'm collecting blog posts on co-working spaces in Tokyo."
            "user":
              "name": "csasaki"
              "fullname": "Cojiro Sasaki"
          ,
            "title": "Geisha bloggers",
            "summary": "Any geisha bloggers out there?"
            "user":
              "name": "csasaki"
              "fullname": "Cojiro Sasaki"
          ]
      App.init(dataJSON)

      expect(App.threads).not.toEqual(undefined)
      expect(App.threads.length).toEqual(2)
      expect(App.threads.models[0].getTitle()).toEqual("Co-working spaces in Tokyo")
      expect(App.threads.models[0].getSummary()).toEqual("I'm collecting blog posts on co-working spaces in Tokyo.")
      expect(App.threads.models[1].getTitle()).toEqual("Geisha bloggers")

    it "instantiates an AppRouter", ->
      sinon.spy(App, 'AppRouter')
      App.init({})
      expect(App.AppRouter).toHaveBeenCalled()
      App.AppRouter.restore()

    it "starts Backbone.history", ->
      Backbone.history.started = null
      Backbone.history.stop()
      sinon.spy(Backbone.history, 'start')
      App.init({})

      expect(Backbone.history.start).toHaveBeenCalled()

      Backbone.history.start.restore()
