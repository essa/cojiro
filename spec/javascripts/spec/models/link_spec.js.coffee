define (require) ->

  I18n = require('i18n')
  Link = require('models/link')
  TranslatableAttribute = require('modules/translatable/attribute')
  sharedExamples = require('spec/models/shared')

  describe 'Link', ->

    sharedExamples(Link, 'link')

    describe 'wrapper methods', ->
      beforeEach ->
        @link = new Link
        collection = url: '/collection'
        @link.collection = collection

      describe '#getUrl', ->
        it 'returns the url', ->
          @link.set('url', 'http://www.foo.com')
          expect(@link.getUrl()).toEqual('http://www.foo.com')

      describe '#getSiteName', ->
        it 'returns the site name', ->
          @link.set('site_name', 'www.foo.com')
          expect(@link.getSiteName()).toEqual('www.foo.com')

    describe '#url', ->
      beforeEach -> @link = new Link

      describe 'when no id is set', ->

        it 'is persisted at /en/links/ for an English locale', ->
          I18n.locale = 'en'
          expect(@link.url()).toEqual('/en/links')

        it 'it persisted at /ja/links/ for a Japanese locale', ->
          I18n.locale = 'ja'
          expect(@link.url()).toEqual('/ja/links')

      describe 'when id is set', ->

        it 'is persisted at /links/en/#id for an English locale', ->
          I18n.locale = 'en'
          @link.id = 123
          expect(@link.url()).toEqual('/en/links/123')

        it 'is persisted at /links/ja/#id for a Japanese locale', ->
          I18n.locale = 'ja'
          @link.id = 123
          expect(@link.url()).toEqual('/ja/links/123')

    describe 'interacting with the server', ->
      beforeEach ->
        I18n.locale = 'en'
        @link = new Link
        @server = sinon.fakeServer.create()

      describe 'fetching the record', ->
        it 'makes the correct request', ->
          @link.fetch()
          expect(@server.requests.length).toEqual(1)
          expect(@server.requests[0]).toBeGET()
          expect(@server.requests[0]).toHaveUrl('/en/links')

      describe 'saving the record', ->

        it 'sends valid data to the server', ->
          @link.save
            title: en: 'a cool link'
            summary: en: 'a summary'
            url: 'http://www.example.com'
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)

          expect(params.link).toBeDefined()
          expect(params.link.url).toEqual('http://www.example.com')
          expect(params.link.title).toEqual('en': 'a cool link')
          expect(params.link.summary).toEqual('en': 'a summary')
