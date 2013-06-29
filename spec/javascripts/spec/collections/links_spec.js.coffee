define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')
  Link = require('models/link')
  Links = require('collections/links')

  describe 'Links', ->

    it 'can be instantiated', ->
      collection = new Links()
      expect(Links).not.toBeNull()

    it 'contains instances of Link', ->
      collection = new Links()
      expect(collection.model).toEqual(Link)

    describe '#url', ->
      beforeEach -> @links = new Links()

      it 'is persisted at /en/links for an English locale', ->
        I18n.locale = 'en'
        expect(@links.url()).toEqual('/en/links')

      it 'is persisted at /ja/links for a Japanese locale', ->
        I18n.locale = 'ja'
        expect(@links.url()).toEqual('/ja/links')
