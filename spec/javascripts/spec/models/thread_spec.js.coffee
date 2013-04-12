# ref1: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
# ref2: http://tinnedfruit.com/2011/03/25/testing-backbone-apps-with-jasmine-sinon-2.html

define (require) ->

  I18n = require('i18n')
  Thread = require('models/thread')
  TranslatableAttribute = require('modules/translatable/attribute')

  describe 'Thread', ->

    it 'can be instantiated', ->
      thread = new Thread
      expect(thread).not.toBeNull()

    describe 'new instance', ->
      beforeEach ->
        I18n.locale = 'ja'

      afterEach ->
        I18n.locale = I18n.defaultLocale

      it 'has default value for the .source_locale attribute', ->
        @thread = new Thread
        expect(@thread.get('source_locale')).toEqual('ja')

      it 'sets attributes passed in to constructor', ->
        @thread = new Thread(title: { en: "Title in English" })
        expect(@thread.get('title').in('en')).toEqual("Title in English")

    describe 'getters', ->
      beforeEach ->
        @thread = new Thread
        collection = url: '/collection'
        @thread.collection = collection

      describe '#toJSON', ->
        beforeEach ->
          @thread.set(
            'title':
              'en': 'title in English'
            'summary':
              'en': 'summary in English'
              'ja': 'summary in Japanese'
            'source_locale': 'source_locale'
            'created_at': "2010-07-20T12:20:00Z"
            'updated_at': "2010-07-20T12:20:00Z"
            'user':
              'name': 'csasaki'
          )

        it 'wraps JSON in thread object', ->
          expect(@thread.toJSON().thread).toBeDefined()
          expect(@thread.toJSON().thread.title).toEqual(
            'en': 'title in English'
          )
          expect(@thread.toJSON().thread.summary).toEqual(
            'en': 'summary in English'
            'ja': 'summary in Japanese'
          )
          expect(@thread.toJSON().thread.source_locale).toEqual('source_locale')

        it 'does not include protected attributes', ->
          expect(@thread.toJSON().thread.user).not.toBeDefined()
          expect(@thread.toJSON().thread.created_at).not.toBeDefined()
          expect(@thread.toJSON().thread.updated_at).not.toBeDefined()

      describe '#getId', ->
        it 'is defined', -> expect(@thread.getId).toBeDefined()

        it 'returns undefined if id is not defined', ->
          expect(@thread.getId()).toBeUndefined()

        it "otherwise returns model's id", ->
          @thread.id = 66
          expect(@thread.getId()).toEqual(66)

      describe '#getTitle', ->
        it 'is defined', -> expect(@thread.getTitle).toBeDefined()

        it 'returns value for the title attribute in current locale', ->
          stub = sinon.stub(@thread, 'get').returns(
            new TranslatableAttribute(
              en: 'Thread title in English'
              ja: 'Thread title in Japanese'
            )
          )
          I18n.locale = 'ja'
          expect(@thread.getTitle()).toEqual('Thread title in Japanese')
          expect(stub).toHaveBeenCalledWith('title')
          I18n.locale = 'en'
          expect(@thread.getTitle()).toEqual('Thread title in English')

      describe '#getSummary', ->
        it 'is defined', -> expect(@thread.getSummary).toBeDefined()

        it 'returns value for the summary attribute', ->
          stub = sinon.stub(@thread, 'get').returns(
            new TranslatableAttribute(
              en: 'Thread summary in English'
              ja: 'Thread summary in Japanese'
            )
          )

          I18n.locale = 'ja'
          expect(@thread.getTitle()).toEqual('Thread summary in Japanese')
          expect(stub).toHaveBeenCalledWith('title')
          I18n.locale = 'en'
          expect(@thread.getTitle()).toEqual('Thread summary in English')

      describe '#getCreatedAt', ->
        it 'is defined', -> expect(@thread.getCreatedAt).toBeDefined()

        it 'returns value for the created_at attribute in correct format', ->
          stub = sinon.stub(@thread, 'get').returns('2012-07-08T12:20:00Z')
          I18n.locale = 'en'

          expect(@thread.getCreatedAt()).toEqual('July 8, 2012')
          expect(stub).toHaveBeenCalledWith('created_at')
          I18n.locale = I18n.defaultLocale

        it 'is undefined if created_at attribute is undefined', ->
          stub = sinon.stub(@thread, 'get').returns(undefined)
          expect(@thread.getCreatedAt()).toEqual(undefined)

      describe '#getUserName', ->
        it 'is defined', -> expect(@thread.getUserName).toBeDefined()

        it 'returns name attribute of user associated with thread', ->
          stub = sinon.stub(@thread, 'get').returns({ 'name': 'csasaki' })

          expect(@thread.getUserName()).toEqual('csasaki')
          expect(stub).toHaveBeenCalledWith('user')

      describe '#getUserFullname', ->
        it 'is defined', -> expect(@thread.getUserFullname).toBeDefined()

        it 'returns fullname attribute of user associated with thread', ->
          stub = sinon.stub(@thread, 'get').returns({ 'fullname': 'Cojiro Sasaki' })

          expect(@thread.getUserFullname()).toEqual('Cojiro Sasaki')
          expect(stub).toHaveBeenCalledWith('user')

      describe '#getUserAvatarUrl', ->
        it 'is defined', -> expect(@thread.getUserAvatarUrl).toBeDefined()

        it 'returns URL of original version of user avatar associated with thread', ->
          stub = sinon.stub(@thread, 'get').returns({ 'avatar_url': 'http://www.example.com/csasaki.png' })

          expect(@thread.getUserAvatarUrl()).toEqual('http://www.example.com/csasaki.png')
          expect(stub).toHaveBeenCalledWith('user')

      describe '#getUserAvatarMiniUrl', ->
        it 'is defined', -> expect(@thread.getUserAvatarMiniUrl).toBeDefined()

        it 'returns URL of mini version of user avatar associated with thread', ->
          stub = sinon.stub(@thread, 'get').returns({ 'avatar_mini_url': 'http://www.example.com/mini_csasaki.png' })

          expect(@thread.getUserAvatarMiniUrl()).toEqual('http://www.example.com/mini_csasaki.png')
          expect(stub).toHaveBeenCalledWith('user')

      describe '#url', ->
        it 'returns collection URL when id is not set', ->
          expect(@thread.url()).toEqual('/collection')

        it 'returns collection URL and id when id is set', ->
          @thread.id = 66
          expect(@thread.url()).toEqual('/collection/66')

    describe 'interacting with the server', ->
      beforeEach ->
        @thread = new Thread()
        collection = url: '/collection'
        @thread.collection = collection
        @server = sinon.fakeServer.create()
      afterEach -> @server.restore()

      describe 'fetching the record', ->

        it 'makes the correct request', ->
          @thread.fetch()
          expect(@server.requests.length).toEqual(1)
          expect(@server.requests[0]).toBeGET()
          expect(@server.requests[0]).toHaveUrl('/collection')

      describe 'saving the record', ->

        it 'sends valid data to the server', ->
          @thread.save
            title: 'Co-working spaces in Tokyo',
            summary: 'I\'m collecting blog posts on co-working spaces in Tokyo.'
            source_locale: 'en'
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)

          expect(params.thread).toBeDefined()
          expect(params.thread.title).toEqual('Co-working spaces in Tokyo')
          expect(params.thread.summary).toEqual('I\'m collecting blog posts on co-working spaces in Tokyo.')
          expect(params.thread.source_locale).toEqual('en')

        describe 'on create', ->
          beforeEach ->
            @thread.id = null
            @thread.save()
            @request = @server.requests[0]

          it 'is a POST', -> expect(@request).toBePOST()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/collection')

        describe 'on update', ->
          beforeEach ->
            @thread.id = 66
            @thread.save()
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/collection/66')

        describe 'validations', ->
          beforeEach ->
            @spy = sinon.spy()
            @thread.bind('error', @spy)
            @data = @fixtures.Thread.valid

          afterEach ->
            @thread.unbind('error', @spy)

          it 'does not save if title is blank and we are in the source locale', ->
            I18n.locale = 'en'
            @thread.save(_(@data).extend('title':'', 'source_locale':'en'))
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@thread,{'title':"can't be blank"})
            I18n.locale = I18n.defaultLocale

          it 'does not save if title is blank and the source locale is missing', ->
            @thread.save(_(@data).extend('title':'', 'source_locale': null))
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@thread,
              {'title':"can't be blank", 'source_locale':"can't be blank"})

          it 'does save if title is blank and we are not in the source locale', ->
            I18n.locale = 'ja'
            @thread.save(_(@data).extend('title':'', 'source_locale':'en'))
            expect(@spy).not.toHaveBeenCalled()
            I18n.locale = I18n.defaultLocale

          it 'does save if title is null (not included)', ->
            @thread.save(_(@data).extend('title': null))
            expect(@spy).not.toHaveBeenCalled()

      describe 'parsing response data', ->
        beforeEach ->
          @fixture = @fixtures.Thread.valid
          @server.respondWith(
            'GET',
            '/collection',
            @validResponse(@fixture))

        it 'should parse the thread from the server', ->
          @thread.fetch()
          @server.respond()
          expect(@thread.getTitle())
            .toEqual(@fixture.title['en'])
          expect(@thread.getSummary())
            .toEqual(@fixture.summary['en'])
          expect(@thread.getCreatedAt())
            .toEqual(@thread.toDateStr(@fixture.created_at))
          expect(@thread.getUpdatedAt())
            .toEqual(@thread.toDateStr(@fixture.updated_at))
          expect(@thread.getSourceLocale())
            .toEqual(@fixture.source_locale)
