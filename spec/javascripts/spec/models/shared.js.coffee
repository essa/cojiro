define [
  'backbone'
  'i18n'
], (Backbone, I18n) ->

  # model assumed to have a source_locale and a translated attribute
  # called 'title' (string) and a user
  #
  (model, model_name) ->

    describe 'shared examples for models', ->

      it 'can be instantiated', ->
        instance = new model
        expect(instance).not.toBeNull()

      describe 'new instance', ->
        beforeEach ->
          I18n.locale = 'ja'

        afterEach ->
          I18n.locale = I18n.defaultLocale

        it 'has default value for source_locale attribute', ->
          expect((new model).get('source_locale')).toEqual('ja')
          I18n.locale = 'fr'
          expect((new model).get('source_locale')).toEqual('fr')

        it 'sets translatable attributes passed in to constructor', ->
          @instance = new model(title: en: 'Title in English')
          expect(@instance.get('title').in('en')).toEqual('Title in English')

      describe 'getters', ->
        beforeEach ->
          @instance = new model
          collection = url: '/collection'
          @instance.collection = collection

        describe '#getUser', ->

          it 'returns user for this thread', ->
            user = new Backbone.Model
            stub = sinon.stub(@instance, 'get').returns(user)

            expect(@instance.getUser()).toEqual(user)
            expect(stub).toHaveBeenCalledWith('user')

        describe '#toJSON', ->
          beforeEach ->
            @instance.set(
              title:
                en: 'title in English'
                ja: 'title in Japanese'
              source_locale: 'en'
              created_at: '2010-07-20T12:20:00Z'
              updated_at: '2010-07-20T12:20:00Z'
              user:
                name: 'csasaki'
            )

          it 'wraps JSON in object', ->
            expect(@instance.toJSON()[model_name]).toBeDefined()
            expect(@instance.toJSON()[model_name].title).toEqual(
              en: 'title in English'
              ja: 'title in Japanese'
            )
            expect(@instance.toJSON()[model_name].source_locale).toEqual('en')

          it 'does not include protected attributes', ->
            expect(@instance.toJSON()[model_name].user).not.toBeDefined()
            expect(@instance.toJSON()[model_name].created_at).not.toBeDefined()
            expect(@instance.toJSON()[model_name].updated_at).not.toBeDefined()

          it 'includes untranslated attributes as empty object', ->
            @instance = new model
            collection = url: '/collection'
            @instance.collection = collection
            @instance.set
              source_locale: 'en'
            expect(@instance.toJSON()[model_name].title).toEqual(new Object)

        describe '#url', ->
          it 'returns collection URL when id is not set', ->
            expect(@instance.url()).toEqual('/collection')

          it 'returns collection URL and id when id is set', ->
            @instance.id = 66
            expect(@instance.url()).toEqual('/collection/66')

