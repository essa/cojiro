define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')

  model = new Backbone.Model(id: 5, title: 'Geisha bloggers')
  Thread = sinon.stub().returns(model)

  context(
    "jquery": jQuery
    "models/thread": Thread
    "backbone": Backbone
  ) ['collections/threads'], (Threads) ->

    describe 'Threads (with stubbed Thread model)', ->

      it 'can be instantiated', ->
        collection = new Threads()
        expect(Threads).not.toBeNull()

      it 'contains instances of Thread', ->
        collection = new Threads()
        expect(collection.model).toEqual(Thread)

      describe 'when instantiated with model literal', ->
        beforeEach ->
          @threads = new Threads()
          @threads.add(id: 5, title: 'Geisha bloggers')

        it 'adds a new model', ->
          expect(@threads.length).toEqual(1)

        it 'finds a model by id', ->
          expect(@threads.get(5).get('id')).toEqual(5)

      describe '#url', ->
        beforeEach -> @threads = new Threads()

        it 'is persisted at /en/threads for an English locale', ->
          I18n.locale = 'en'
          expect(@threads.url()).toEqual('/en/threads')

        it 'is persisted at /ja/threads for a Japanese locale', ->
          I18n.locale = 'ja'
          expect(@threads.url()).toEqual('/ja/threads')

      describe "byUser()", ->
        beforeEach ->
          Backbone.Model.prototype.getUserName = ->
          @thread1 = new Backbone.Model()
          @thread2 = new Backbone.Model()
          @thread3 = new Backbone.Model()
          sinon.stub(@thread1, 'getUserName').returns("csasaki")
          sinon.stub(@thread2, 'getUserName').returns("csasaki")
          sinon.stub(@thread3, 'getUserName').returns("otheruser")
          @threads = new Threads([@thread1, @thread2, @thread3])

        afterEach ->
          Backbone.Model.prototype.getUserName = undefined

        it 'returns a threads collection', ->
          expect(@threads.byUser("csasaki") instanceof Threads).toBeTruthy()

        it 'selects all users with name "username"', ->
          expect(@threads.byUser("csasaki").length).toEqual(2)
          expect(@threads.byUser("otheruser").length).toEqual(1)

  context("jquery": jQuery, "i18n": I18n) ['collections/threads'], (Threads) ->

    describe 'Threads (with real Thread model)', ->

      describe 'interacting with the server', ->
        beforeEach ->
          @threads = new Threads()
          I18n.locale = 'en'
          @server = sinon.fakeServer.create()
        afterEach -> @server.restore()

        describe 'fetching and updating the collection', ->

          it 'makes the correct request', ->
            @threads.fetch()
            expect(@server.requests.length).toEqual(1)
            expect(@server.requests[0]).toBeGET()
            expect(@server.requests[0]).toHaveUrl('/en/threads')

        describe 'parsing response data', ->
          beforeEach ->
            @fixture = @fixtures.Threads.valid
            @server.respondWith(
              'GET',
              '/en/threads',
              @validResponse(@fixture))

          it 'parses threads from the server', ->
            @threads.fetch()
            @server.respond()
            expect(@threads.models.length).toEqual(@fixture.length)
            expect(@threads.get(1).getTitle()).toEqual(@fixture[0].title)
