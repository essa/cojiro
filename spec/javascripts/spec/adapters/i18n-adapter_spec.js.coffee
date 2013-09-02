define (require) ->

  I18n = require('i18n')

  describe 'i18n adapter', ->
    describe 'changeLocale', ->
      it 'changes locale', ->
        I18n.locale = 'en'
        I18n.changeLocale('ja')
        expect(I18n.locale).toEqual('ja')

      it 'rotates availableLocales', ->
        I18n.locale = 'en'
        availableLocales = I18n.availableLocales
        I18n.availableLocales = ['en', 'ja', 'fr']
        I18n.changeLocale('ja')
        expect(I18n.availableLocales).toEqual(['ja', 'fr', 'en'])
