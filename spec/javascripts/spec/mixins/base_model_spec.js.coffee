require [
  "backbone",
  "mixins/base_model"
], (Backbone, BaseModel) ->

  describe "BaseModel", ->
    beforeEach ->
      @baseModel = new BaseModel

    it 'extends Backbone.Model', ->
      expect(@baseModel instanceof Backbone.Model).toBeTruthy()

    describe "#validate", ->

      it 'returns an empty object', ->
        expect(@baseModel.validate()).toEqual({})
