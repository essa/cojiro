define (require) ->

  Attribute = require('modules/translatable/attribute')
  I18n = require('i18n')

  describe 'Translatable.Attribute', ->
    beforeEach ->
      @attribute = new Attribute

    it 'aliases "get" to "in"', ->
      stub = sinon.stub(@attribute, 'get').returns('Attribute in English')
      expect(@attribute.in('en')).toEqual('Attribute in English')
      expect(stub).toHaveBeenCalledOnce
      expect(stub).toHaveBeenCalledWith('en')

    it 'trims whitespace', ->
      stub = sinon.stub(@attribute, 'get').returns('  Attribute in English  ')
      expect(@attribute.in('en')).toEqual('Attribute in English')

    it 'returns undefined if value is blank', ->
      stub = sinon.stub(@attribute, 'get').returns('  ')
      expect(@attribute.in('en')).toBeUndefined()
