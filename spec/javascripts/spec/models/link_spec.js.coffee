define (require) ->

  I18n = require('i18n')
  Link = require('models/link')
  TranslatableAttribute = require('modules/translatable/attribute')
  sharedExamples = require('spec/models/shared')

  describe 'Link', ->

    sharedExamples(Link, 'link')

    describe 'getters', ->
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

      describe '#getEmbedData', ->
        it 'returns embedly data', ->
          @link.set('embed_data', { 'foo': 'bar' })
          expect(@link.getEmbedData()).toEqual('foo': 'bar')

        it 'returns empty object if no embedly data', ->
          expect(@link.getEmbedData()).toEqual({})

      describe '#getThumbnailUrl', ->
        it 'returns thumbnail url from embedly data', ->
          @link.set('embed_data', { 'thumbnail_url': 'http://www.foo.com/bar' })
          expect(@link.getThumbnailUrl()).toEqual('http://www.foo.com/bar')

      describe '#toJSON', ->
        it 'does not include link key if all values are null', ->
          expect(@link.toJSON()['link']).not.toBeDefined()

    describe 'idAttribute', ->
      it 'uses url attribute as id', ->
        expect((new Link).idAttribute).toEqual('url')

    describe '#url', ->
      beforeEach -> @link = new Link

      describe 'when no id is set', ->

        it 'throws an error', ->
          link = @link
          expect(-> link.url()).toThrow('id is required to generate url')

      describe 'when id is set', ->

        it 'is persisted at /links/en/#id for an English locale', ->
          I18n.locale = 'en'
          @link.id = 'url123'
          expect(@link.url()).toEqual('/en/links/url123')

        it 'is persisted at /links/ja/#id for a Japanese locale', ->
          I18n.locale = 'ja'
          @link.id = 'url123'
          expect(@link.url()).toEqual('/ja/links/url123')

      describe 'escaping id', ->

        it 'escapes id in url', ->
          I18n.locale = 'en'
          @link.id = 'http://www.google.com'
          expect(@link.url()).toEqual('/en/links/http%3A%2F%2Fwww.google.com')

    describe 'interacting with the server', ->
      beforeEach ->
        I18n.locale = 'en'
        @link = new Link(url: 'http://www.example.com')
        @server = sinon.fakeServer.create()

      describe 'fetching the record', ->
        it 'makes the correct request', ->
          @link.fetch()
          expect(@server.requests.length).toEqual(1)
          expect(@server.requests[0]).toBeGET()
          expect(@server.requests[0]).toHaveUrl('/en/links/http%3A%2F%2Fwww.example.com')

      describe 'saving the record', ->

        it 'sends valid data to the server', ->
          @link.save
            title: en: 'a cool link'
            summary: en: 'a summary'
            url: 'http://www.example.com'
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)

          expect(params.link).toBeDefined()
          expect(params.link.title).toEqual('en': 'a cool link')
          expect(params.link.summary).toEqual('en': 'a summary')
