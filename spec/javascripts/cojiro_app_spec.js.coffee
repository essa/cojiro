describe "CojiroApp", ->
  it "has a namespace for Models", -> expect(CojiroApp.Models).toBeTruthy()
  it "has a namespace for Collection", -> expect(CojiroApp.Collections).toBeTruthy()
  it "has a namespace for Views", -> expect(CojiroApp.Views).toBeTruthy()
  it "has a namespace for Routers", -> expect(CojiroApp.Routers).toBeTruthy()

  describe "init()", ->
    it "accepts JSON and instantiates collections from it", ->
      cothreadsJSON =
        "cothread":
          "title": "Co-working spaces in Tokyo","summary": "I'm collecting blog posts on co-working spaces in Tokyo."

      CojiroApp.init(cothreadsJSON)

      expect(CojiroApp.cothread).not.toEqual(undefined)
      expect(CojiroApp.cothread.getTitle()).toEqual("Co-working spaces in Tokyo")
      expect(CojiroApp.cothread.getSummary()).toEqual("I'm collecting blog posts on co-working spaces in Tokyo.")

    it "instantiates a Cothreads router", ->
      CojiroApp.Routers.Cothreads = sinon.spy()
      CojiroApp.init({})
      expect(CojiroApp.Routers.Cothreads).toHaveBeenCalled()
