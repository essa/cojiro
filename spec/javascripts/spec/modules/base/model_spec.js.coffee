define (require) -> 

  Backbone = require('backbone')
  BaseModel = require('modules/base/model')

  describe "BaseModel", ->
    beforeEach ->
      @baseModel = new BaseModel

    it 'extends Backbone.Model', ->
      expect(@baseModel instanceof Backbone.Model).toBeTruthy()

    describe "#validate", ->

      it 'returns an empty object', ->
        expect(@baseModel.validate()).toEqual({})
