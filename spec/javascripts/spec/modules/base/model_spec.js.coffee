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

    describe ".extendObject", ->
      xit 'assigns keys and values of extended object to object'
      xit 'calls extended method'
      xit 'returns the object'

    describe '.include', ->
      xit 'assigns keys and values of included object to prototype'
      xit 'calls extended method'
      xit 'returns the object'
