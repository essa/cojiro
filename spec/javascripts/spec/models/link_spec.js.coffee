define (require) ->

  I18n = require('i18n')
  Link = require('models/link')
  TranslatableAttribute = require('modules/translatable/attribute')
  sharedExamples = require('spec/models/shared')

  describe 'Link', ->

    sharedExamples(Link, 'link')

    describe 'getters', ->
      beforeEach -> @link = new Link

      describe '#getUrl', ->
        it 'returns the url', ->
          @link.set('url', 'http://www.foo.com')
          expect(@link.getUrl()).toEqual('http://www.foo.com')

      describe '#getUrl', ->
        it 'returns the display url', ->
          @link.set('display_url', 'http://www.価格.com/')
          expect(@link.getDisplayUrl()).toEqual('http://www.価格.com/')

      describe '#getSiteName', ->
        it 'returns the site name', ->
          @link.set('site_name', 'www.foo.com')
          expect(@link.getSiteName()).toEqual('www.foo.com')

      describe '#getFaviconUrl', ->
        it 'returns the favicon url', ->
          @link.set('favicon_url', 'http://www.foo.com/favicon.ico')
          expect(@link.getFaviconUrl()).toEqual('http://www.foo.com/favicon.ico')

      describe '#getEmbedData', ->
        it 'returns embedly data', ->
          @link.set('oembed_data', { 'foo': 'bar' })
          expect(@link.getEmbedData()).toEqual('foo': 'bar')

        it 'returns empty object if no embedly data', ->
          expect(@link.getEmbedData()).toEqual({})

      describe '#getThumbnailUrl', ->
        it 'returns thumbnail url from embedly data', ->
          @link.set('oembed_data', { 'thumbnail_url': 'http://www.foo.com/bar' })
          expect(@link.getThumbnailUrl()).toEqual('http://www.foo.com/bar')

      describe '#getUserName', ->
        it 'returns the name of the user who created this link', ->
          @link.set('user_name', 'foo')
          expect(@link.getUserName()).toEqual('foo')

      describe '#toJSON', ->
        it 'does not include link key if all values are null', ->
          expect(@link.toJSON()['link']).not.toBeDefined()

      describe '#getStatus', ->
        it 'returns 1 if source locale is defined', ->
          @link.setSourceLocale('en')
          expect(@link.getStatus()).toEqual(1)

        it 'returns 0 otherwise', ->
          expect(@link.getStatus()).toEqual(0)

    describe 'idAttribute', ->
      it 'uses \'id\' attribute as id', ->
        expect((new Link).idAttribute).toEqual('id')

    describe '#url', ->
      beforeEach -> @link = new Link

      describe 'when no url attribute is set', ->

        it 'throws an error', ->
          link = @link
          expect(-> link.url()).toThrow('url attribute is required to generate link url')

      describe 'when url attribute is set', ->
        beforeEach -> @link.set('url', 'url123')

        it 'is persisted at /links/en/<url> for an English locale', ->
          I18n.locale = 'en'
          expect(@link.url()).toEqual('/en/links/url123')

        it 'is persisted at /links/ja/<url> for a Japanese locale', ->
          I18n.locale = 'ja'
          expect(@link.url()).toEqual('/ja/links/url123')

      describe 'escaping url', ->

        it 'escapes url attribute', ->
          I18n.locale = 'en'
          @link.set('url', 'http://www.google.com')
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

        describe 'on create', ->
          beforeEach ->
            @link.set
              url: 'http://www.example.com'
            @link.id = null
            @link.save({}, validate: false)
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/en/links/http%3A%2F%2Fwww.example.com')

        describe 'on update', ->
          beforeEach ->
            @link.set
              url: 'http://www.example.com'
            @link.id = 66
            @link.save({}, validate: false)
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/en/links/http%3A%2F%2Fwww.example.com')

        describe 'handing duplicate ids', ->
          beforeEach ->
            @server.respondWith(
              'PUT'
              /^\/en\/links\/(.*)www\.example\.com/
              @validResponse(id: 123, url: 'http://www.example.com/'))
            @link.save { url: 'www.example.com' }, validate: false
            @server.respond()

          it 'assigns id returned from server if no model exists yet in store', ->
            expect(@link.getId()).toEqual(123)

          it 'deletes id attribute from response if model with same id exists in store', ->
            newLink = new Link
            newLink.save { url: 'www.example.com' }, validate: false
            @server.respond()
            expect(newLink.getId()).toBeUndefined()
            expect(newLink.getUrl()).toEqual('http://www.example.com/')

        describe 'validations', ->
          beforeEach ->
            @spy = sinon.spy()
            @link.bind('invalid', @spy)
            @data = @fixtures.Link.valid

          afterEach -> @link.unbind('error', @spy)

          it 'is valid with valid attributes', ->
            expect(@link.save(@data)).toBeTruthy()
            expect(@spy).not.toHaveBeenCalled()

          it 'does not save if the source locale is blank', ->
            expect(@link.save(_(@data).extend(source_locale: ''))).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@link, source_locale: 'can\'t be blank')

          it 'does not save if the url is blank', ->
            expect(@link.save(_(@data).extend(url: ''))).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@link, url: 'can\'t be blank')

          it 'does not save if the title is blank in the source locale', ->
            @data =
              source_locale: 'fr'
              title: fr: ''
            expect(@link.save(@data)).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@link, title: fr: 'can\'t be blank')

          it 'does not save if the title in the source locale is missing', ->
            @data =
              source_locale: 'fr'
            expect(@link.save(@data)).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@link, title: fr: 'can\'t be blank')

          it 'does not save if the title in the source locale is null', ->
            @data =
              source_locale: 'fr'
              title: fr: null
            expect(@link.save(@data)).toBeFalsy()
            expect(@spy).toHaveBeenCalledOnce()
            expect(@spy).toHaveBeenCalledWith(@link, title: fr: 'can\'t be blank')
