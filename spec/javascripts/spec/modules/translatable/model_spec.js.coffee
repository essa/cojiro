define (require) ->

  Model = require('modules/translatable/model')
  Attribute = require('modules/translatable/attribute')
  I18n = require('i18n')
  MyModel = Model.extend( translatableAttributes: ["title", "summary"] )

  describe "Translatable.Model", ->

    beforeEach ->
      I18n.locale = 'en'
      @model = new MyModel(source_locale: "ja")
      @model.collection = url: '/collection'

    describe 'defaults', ->
      it 'sets translatedAttributes to empty array', ->
        @model = new Model
        expect(@model.translatableAttributes).toEqual([])

    describe 'initialization', ->
      it 'creates translatable attribute objects for each attribute', ->
        expect(@model.get("title") instanceof Attribute).toBeTruthy()
        expect(@model.get("summary") instanceof Attribute).toBeTruthy()

      it 'sets initial value of translatable attributes if passed in', ->
        @newModel = new MyModel(source_locale: "ja", title: { en: "title in English" })
        expect(@newModel.get('title').in('en')).toEqual('title in English')

      it 'handles undefined value for attributes', ->
        expect(-> new MyModel).not.toThrow()

    describe 'interacting with the server', ->
      beforeEach ->
        @server = sinon.fakeServer.create()
      afterEach -> @server.restore()

      it 'parses localized data from the server', ->
        @server.respondWith(
          'GET',
          '/collection',
          @validResponse(
            "source_locale": "en"
            "title":
              "en": "Title in English"
              "ja": "Title in Japanese"
            "summary":
              "fr": "Summary in French"
              "cn": "Summary in Chinese"
          )
        )
        @model.fetch()
        @server.respond()
        expect(@model.get("title").in("en")).toEqual("Title in English")
        expect(@model.get("title").in("ja")).toEqual("Title in Japanese")
        expect(@model.get("summary").in("fr")).toEqual("Summary in French")
        expect(@model.get("summary").in("cn")).toEqual("Summary in Chinese")
        expect(@model.get("source_locale")).toEqual("en")

      it 'saves localized data to the server', ->
        @model.setAttr("title", "Title in English")
        @model.setAttr("summary", "Summary in English")
        @model.setAttrInLocale("title", "fr", "Title in French")
        @model.setAttrInLocale("summary", "fr", "Summary in French")
        @model.save()
        request = @server.requests[0]
        expect(request).toBePOST()
        params = JSON.parse(request.requestBody)

        expect(params.title.en).toEqual("Title in English")
        expect(params.title.fr).toEqual("Title in French")
        expect(params.summary.en).toEqual("Summary in English")
        expect(params.summary.fr).toEqual("Summary in French")

    describe 'getters', ->
      beforeEach ->
        @title_attr = new Backbone.Model("en": "Title in English", "ja": "Title in Japanese")

      describe '#getAttr', ->
        it 'is defined', -> expect(@model.getAttr).toBeDefined()

        it 'returns value for attribute in current locale', ->
          stub = sinon.stub(@model, 'get').returns(@title_attr)
          expect(@model.getAttr("title")).toEqual("Title in English")
          expect(stub).toHaveBeenCalledWith('title')

      describe '#getAttrInLocale', ->
        it 'is defined', -> expect(@model.getAttrInLocale).toBeDefined()

        it 'returns value for attribute in given locale', ->
          stub = sinon.stub(@model, 'get').returns(@title_attr)
          expect(@model.getAttrInLocale("title", "ja")).toEqual("Title in Japanese")
          expect(stub).toHaveBeenCalledWith('title')

      describe '#getAttrInSourceLocale', ->
        it 'is defined', -> expect(@model.getAttrInSourceLocale).toBeDefined()

        it 'returns value for attribute in source locale', ->
          getStub = sinon.stub(@model, 'get')
          getStub.withArgs("title").returns(@title_attr)
          getStub.withArgs("source_locale").returns("ja")
          expect(@model.getAttrInSourceLocale('title')).toEqual('Title in Japanese')
          expect(getStub).toHaveBeenCalledWith("title")
          expect(getStub).toHaveBeenCalledWith("source_locale")

      describe '#getSourceLocale', ->
        it 'is defined', -> expect(@model.getSourceLocale).toBeDefined()

        it 'returns value for the source_locale attribute', ->
          stub = sinon.stub(@model, 'get').returns('ja')

          expect(@model.getSourceLocale()).toEqual('ja')
          expect(stub).toHaveBeenCalledWith('source_locale')

    describe "setters", ->
      describe "#set", ->
        it 'duplicates attributes object before parsing', ->
          attributes = { 'title': { 'en': 'title passed in' } }
          @model.set(attributes)
          expect(attributes).toEqual( { 'title' : { 'en': 'title passed in' } } )

        it 'overrides default to create translatable attributes', ->
          @model.set('title': { 'en': 'title passed in as nested attribute' } )
          expect(@model.get('title').in('en')).toEqual('title passed in as nested attribute')

        it 'does not overwrite existing attribute translations', ->
          @model.set('title': { 'en': 'a title in English' })
          @model.set('title': { 'ja': 'a title in Japanese' })
          expect(@model.get('title').in('en')).toEqual('a title in English')
          expect(@model.get('title').in('ja')).toEqual('a title in Japanese')

        it 'passes in other attributes unchanged', ->
          @model.set('nested_attribute': { 'nested': 'value' })
          expect(@model.get('nested_attribute')).toEqual({ 'nested': 'value' })

        it 'does not delete initialized blank translated attributes', ->
          @model.set('title': { 'en': 'a title in English' })
          self = @
          expect(-> self.model.get('summary')).not.toThrow()
          expect(@model.get('summary') instanceof Attribute).toBeTruthy()

      describe "#setAttr", ->
        it 'is defined', -> expect(@model.setAttr).toBeDefined()

        it 'sets translated attribute in current locale', ->
          sinon.spy(@model, 'set')
          @model.setAttr('title', 'A new title in English')
          expect(@model.get('title').in('en')).toEqual('A new title in English')
          expect(@model.set).toHaveBeenCalledOnce

      describe "#setAttrInLocale", ->
        it 'is defined', -> expect(@model.setAttrInLocale).toBeDefined()

        it 'sets translated attribute in given locale', ->
          sinon.spy(@model, 'set')
          @model.setAttrInLocale('title', 'ja', 'A new title in Japanese')
          expect(@model.get('title').in('ja')).toEqual('A new title in Japanese')
          expect(@model.set).toHaveBeenCalledOnce

        it 'leaves values of attribute in other locales', ->
          @model.setAttrInLocale('title', 'ja', 'A new title in Japanese')
          @model.setAttrInLocale('title', 'en', 'A new title in English')
          expect(@model.get('title').in('ja')).toEqual('A new title in Japanese')
          expect(@model.get('title').in('en')).toEqual('A new title in English')

    describe '#parse', ->
      it 'returns null for null response', ->
        expect(@model.parse(null)).toEqual(null)

      it 'replaces nested values for translated attributes with translated attributes', ->
        parsed = @model.parse({ title: ja: 'title in Japanese'})
        expect(parsed['title'] instanceof Attribute).toBeTruthy()
        expect(parsed['title'].attributes).toEqual(ja: 'title in Japanese')

      it 'only overwrites translated attributes if they are in the response', ->
        expect(@model.parse({ "foo" : "bar"})).toEqual({ "foo": "bar" })

      it 'leaves translatable attribute objects unchanged', ->
        parsed = @model.parse(title: new Attribute(en: "title in English"))
        expect(parsed['title'].in('en')).toEqual("title in English")

      describe 'with merge option', ->
        beforeEach ->
          @model.setAttr('title', 'title in English')

        it 'merges existing translations with response', ->
          parsed = @model.parse({ title: ja: 'title in Japanese' }, merge: true)
          expect(parsed['title'].attributes).toEqual(en: 'title in English', ja: 'title in Japanese')

        it 'only includes translated attributes if they are already set, or are in the response', ->
          parsed = @model.parse({ "foo": "bar" }, merge: true)
          expect(parsed['foo']).toEqual("bar")
          expect(parsed['summary']).toBeUndefined()

    describe "validations", ->
      beforeEach ->
        @spy = sinon.spy()
        @model.bind('invalid', @spy)

      it 'does not save if the source locale is blank', ->
        expect(@model.save('source_locale': "")).toBeFalsy()
        expect(@spy).toHaveBeenCalledOnce()
        expect(@spy).toHaveBeenCalledWith(@model,{'source_locale':"can't be blank"})

      it 'does not save if the source locale is null', ->
        expect(@model.save('source_locale': null)).toBeFalsy()
        expect(@spy).toHaveBeenCalledOnce()
        expect(@spy).toHaveBeenCalledWith(@model,{'source_locale':"can't be blank"})
