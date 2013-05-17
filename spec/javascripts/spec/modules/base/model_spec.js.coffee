define (require) -> 

  Backbone = require('backbone')

  describe "BaseModel", ->
    beforeEach ->
      BaseModel = require('modules/base/model')
      @baseModel = new BaseModel

    it 'extends Backbone.Model', ->
      expect(@baseModel instanceof Backbone.Model).toBeTruthy()

    describe "#validate", ->

      it 'returns an empty object', ->
        expect(@baseModel.validate()).toEqual({})

    describe '.use', ->
      class A
        foo: -> "bar"
      class B
        bar: -> "baz"
      beforeEach ->
        @modelClass = require('modules/base/model')

      it 'assigns keys and values of class prototype to prototype', ->
        @modelClass.use(A)
        a = new @modelClass
        expect(a.foo()).toEqual("bar")
        expect(a.bar).toBeUndefined()

      it 'accepts more than one class', ->
        @modelClass.use(A, B)
        a = new @modelClass
        expect(a.foo()).toEqual("bar")
        expect(a.bar()).toEqual("baz")

      it 'returns the object', ->
        expect(@modelClass.use(class Foo)).toEqual(@modelClass)
