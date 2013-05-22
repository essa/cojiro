define (require) ->

  I18n = require('i18n')
  BaseModel = require('modules/base/model')
  Timestamps = require('modules/extended/timestamps')

  class Model extends BaseModel
    @use(Timestamps)

  describe 'Timestamps module', ->
    beforeEach ->
      @instance = new Model

    describe '#getCreatedAt', ->
      it 'is defined', -> expect(@instance.getCreatedAt).toBeDefined()

      it 'returns value for the created_at attribute in correct format', ->
        stub = sinon.stub(@instance, 'get').returns('2012-07-08T12:20:00Z')
        I18n.locale = 'en'

        expect(@instance.getCreatedAt()).toEqual('July 8, 2012')
        expect(stub).toHaveBeenCalledWith('created_at')
        I18n.locale = I18n.defaultLocale

      it 'is undefined if created_at attribute is undefined', ->
        stub = sinon.stub(@instance, 'get').returns(undefined)
        expect(@instance.getCreatedAt()).toEqual(undefined)
