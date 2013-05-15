# ref1: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
# ref2: http://tinnedfruit.com/2011/03/25/testing-backbone-apps-with-jasmine-sinon-2.html

define (require) ->

  I18n = require('i18n')
  Thread = require('models/thread')
  TranslatableAttribute = require('modules/translatable/attribute')
  sharedExamples = require('spec/models/shared')

  describe 'Thread', ->

    sharedExamples(Thread, 'thread')

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
            title:
              en: 'Co-working spaces in Tokyo',
            summary:
              en: 'I\'m collecting blog posts on co-working spaces in Tokyo.'
            source_locale: 'en'
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)

          expect(params.thread).toBeDefined()
          expect(params.thread.title).toEqual('en': 'Co-working spaces in Tokyo')
          expect(params.thread.summary).toEqual('en': 'I\'m collecting blog posts on co-working spaces in Tokyo.')
          expect(params.thread.source_locale).toEqual('en')

        describe 'on create', ->
          beforeEach ->
            @thread.set(@fixtures.Thread.valid)
            @thread.id = null
            @thread.save()
            @request = @server.requests[0]

          it 'is a POST', -> expect(@request).toBePOST()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/collection')

        describe 'on update', ->
          beforeEach ->
            @thread.set(@fixtures.Thread.valid)
            @thread.id = 66
            @thread.save()
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/collection/66')

        describe 'validations', ->
          beforeEach ->
            @spy = sinon.spy()
            @thread.bind('invalid', @spy)
            @data = @fixtures.Thread.valid

          afterEach ->
            @thread.unbind('error', @spy)

          it 'does not save if title is blank in the source locale', ->
            expect(@thread.save(_(@data).extend(title: en: '', source_locale: 'en'))).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@thread, title: en: "can't be blank")

          it 'does not save if title is missing in the source locale', ->
            expect(@thread.save(_(@data).extend(title: {}, source_locale: 'en'))).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@thread, title: en: "can't be blank")

          it 'does not save if title in source locale is null', ->
            expect(@thread.save(_(@data).extend(title: { en: null }, source_locale: 'en'))).toBeFalsy()
            expect(@spy).toHaveBeenCalled()

          it 'does not save if source locale is missing', ->
            expect(@thread.save(_(@data).extend(source_locale: null))).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@thread,
              {'source_locale':"can't be blank"})

          it 'does save if title is blank in another locale', ->
            expect(@thread.save(_(@data).extend({ title: en: 'some title', ja: '' }, source_locale: 'en'))).toBeTruthy()
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
          expect(@thread.getAttr('title'))
            .toEqual(@fixture.title['en'])
          expect(@thread.getAttr('summary'))
            .toEqual(@fixture.summary['en'])
          expect(@thread.getCreatedAt())
            .toEqual(@thread.toDateStr(@fixture.created_at))
          expect(@thread.getUpdatedAt())
            .toEqual(@thread.toDateStr(@fixture.updated_at))
          expect(@thread.getSourceLocale())
            .toEqual(@fixture.source_locale)
