describe "App.BaseView", ->
  beforeEach ->
    @baseView = new App.BaseView

  it 'extends Support.CompositeView', ->
    expect(@baseView instanceof Support.CompositeView).toBeTruthy()

  describe "#buildEvents", ->

    it 'returns an empty object', ->
      expect(@baseView.buildEvents()).toEqual({})

  describe "initialize", ->

    it "delegates events", ->
      spy = sinon.stub(@baseView, 'delegateEvents')
      @baseView.buildEvents = () ->
        "click button": "eventHandler"
      @baseView.initialize()
      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWith({ "click button": "eventHandler" })
