describe "App.BaseModel", ->
  beforeEach ->
    @baseModel = new App.BaseModel

  it 'extends Backbone.Model', ->
    expect(@baseModel instanceof Backbone.Model).toBeTruthy()

  describe "#validate", ->

    it 'returns an empty object', ->
      expect(@baseModel.validate()).toEqual({})
