define (require) ->

  TranslatableModel = require('modules/translatable/model')
  TranslatableAttribute = require('modules/translatable/attribute')
  I18n = require('i18n')

  describe "TranslatableModel", ->

    beforeEach ->
      I18n.locale = 'en'

    describe 'initialization', ->

      beforeEach ->
        @model = new TranslatableModel({}, { "translatableAttributes": ["title", "summary"] })

      it 'creates translatable attribute objects for each attribute', ->
        expect(@model.get("title") instanceof TranslatableAttribute).toBeTruthy()
        expect(@model.get("summary") instanceof TranslatableAttribute).toBeTruthy()

    describe 'parsing', ->

      beforeEach ->
        @model = new TranslatableModel({}, { "translatableAttributes": ["title", "summary"] })
        collection = url: '/collection'
        @model.collection = collection
        @server = sinon.fakeServer.create()
        @server.respondWith(
          'GET',
          '/collection',
          @validResponse({
            "title":
              "en": "Title in English"
              "ja": "Title in Japanese"
            "summary":
              "fr": "Summary in French"
              "cn": "Summary in Chinese"
          })
        )
      afterEach -> @server.restore()

      it 'parses localized data', ->
        @model.fetch()
        @server.respond()
        expect(@model.get("title").in("en")).toEqual("Title in English")
        expect(@model.get("title").in("ja")).toEqual("Title in Japanese")
        expect(@model.get("summary").in("fr")).toEqual("Summary in French")
        expect(@model.get("summary").in("cn")).toEqual("Summary in Chinese")

    describe 'getters', ->
      beforeEach ->
        @model = new TranslatableModel
        @model.collection = url: '/collection'

      describe '#getAttrInSourceLocale', ->
        it 'is defined', -> expect(@model.getAttrInSourceLocale).toBeDefined()

        it 'returns value for the attr_in_source_locale helper method', ->
          stub = sinon.stub(@model, 'get').returns('Attribute in source language')

          expect(@model.getAttrInSourceLocale('attribute')).toEqual('Attribute in source language')
          expect(stub).toHaveBeenCalledWith('attribute_in_source_locale')

      describe '#getSourceLocale', ->
        it 'is defined', -> expect(@model.getSourceLocale).toBeDefined()

        it 'returns value for the source_locale attribute', ->
          stub = sinon.stub(@model, 'get').returns('ja')

          expect(@model.getSourceLocale()).toEqual('ja')
          expect(stub).toHaveBeenCalledWith('source_locale')

      describe "validations", ->
        beforeEach ->
          @spy = sinon.spy()
          @model.bind('error', @spy)

        it 'does not save if the source locale is blank', ->
          @model.save('source_locale': "")
          expect(@spy).toHaveBeenCalledOnce()
          expect(@spy).toHaveBeenCalledWith(@model,{'source_locale':"can't be blank"})

        it 'does not save if the source locale is null', ->
          @model.save('source_locale': null)
          expect(@spy).toHaveBeenCalledOnce()
          expect(@spy).toHaveBeenCalledWith(@model,{'source_locale':"can't be blank"})
