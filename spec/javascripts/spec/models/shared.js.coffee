define [
  'i18n'
], (I18n) ->

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

        describe '#getId', ->
          it 'is defined', -> expect(@instance.getId).toBeDefined()

          it 'returns undefined if id is not defined', ->
            expect(@instance.getId()).toBeUndefined()

          it "otherwise returns model's id", ->
            @instance.id = 66
            expect(@instance.getId()).toEqual(66)

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

        describe '#getUserName', ->
          it 'is defined', -> expect(@instance.getUserName).toBeDefined()

          it 'returns name attribute of user associated with instance', ->
            stub = sinon.stub(@instance, 'get').returns({ 'name': 'csasaki' })

            expect(@instance.getUserName()).toEqual('csasaki')
            expect(stub).toHaveBeenCalledWith('user')

        describe '#getUserFullname', ->
          it 'is defined', -> expect(@instance.getUserFullname).toBeDefined()

          it 'returns fullname attribute of user associated with instance', ->
            stub = sinon.stub(@instance, 'get').returns({ 'fullname': 'Cojiro Sasaki' })

            expect(@instance.getUserFullname()).toEqual('Cojiro Sasaki')
            expect(stub).toHaveBeenCalledWith('user')

        describe '#getUserAvatarUrl', ->
          it 'is defined', -> expect(@instance.getUserAvatarUrl).toBeDefined()

          it 'returns URL of original version of user avatar associated with instance', ->
            stub = sinon.stub(@instance, 'get').returns({ 'avatar_url': 'http://www.example.com/csasaki.png' })

            expect(@instance.getUserAvatarUrl()).toEqual('http://www.example.com/csasaki.png')
            expect(stub).toHaveBeenCalledWith('user')

        describe '#getUserAvatarMiniUrl', ->
          it 'is defined', -> expect(@instance.getUserAvatarMiniUrl).toBeDefined()

          it 'returns URL of mini version of user avatar associated with instance', ->
            stub = sinon.stub(@instance, 'get').returns({ 'avatar_mini_url': 'http://www.example.com/mini_csasaki.png' })

            expect(@instance.getUserAvatarMiniUrl()).toEqual('http://www.example.com/mini_csasaki.png')
            expect(stub).toHaveBeenCalledWith('user')

        describe '#url', ->
          it 'returns collection URL when id is not set', ->
            expect(@instance.url()).toEqual('/collection')

          it 'returns collection URL and id when id is set', ->
            @instance.id = 66
            expect(@instance.url()).toEqual('/collection/66')

