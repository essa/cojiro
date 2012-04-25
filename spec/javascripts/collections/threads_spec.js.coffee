describe "App.Threads", ->

  it "is defined with alias", ->
    expect(App.Threads).toBeDefined()
    expect(App.Collections.Threads).toBeDefined()
    expect(App.Threads).toEqual(App.Collections.Threads)

  it "can be instantiated", ->
    collection = new App.Threads()
    expect(App.Threads).not.toBeNull()

  it "contains instances of App.Thread", ->
    collection = new App.Threads()
    expect(collection.model).toEqual(App.Thread)

  describe "when instantiated with model literal", ->
    beforeEach ->
      @threadStub = sinon.stub(window.App, 'Thread')
      @model = new Backbone.Model(id: 5, title: "Geisha bloggers")

      @threadStub.returns(@model)
      @threads = new App.Threads()
      @threads.model = @threadStub
      @threads.add(id: 5, title: "Geisha bloggers")

    afterEach ->
      @threadStub.restore()

    it "adds a new model", ->
      expect(@threads.length).toEqual(1)

    it "finds a model by id", ->
      expect(@threads.get(5).get('id')).toEqual(5)

  describe "#url", ->
    beforeEach -> @threads = new App.Threads()

    it "is persisted at /en/threads for an English locale", ->
      I18n.locale = 'en'
      expect(@threads.url()).toEqual("/en/threads")

    it "is persisted at /ja/threads for a Japanese locale", ->
      I18n.locale = 'ja'
      expect(@threads.url()).toEqual("/ja/threads")
