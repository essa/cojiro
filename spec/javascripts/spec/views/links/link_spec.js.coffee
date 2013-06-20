define (require) ->

  Link = require('models/link')
  LinkView = require('views/links/link')
  globals = require('globals')
  I18n = require('i18n')

  describe 'LinkView', ->
    beforeEach ->
      I18n.locale = 'en'
      @link = new Link()
      @link.set
        title: en: "What is CrossFit?"
        summary: en: "CrossFit is an effective way to get fit. Anyone can do it."
        user: 'csasaki'
        site_name: 'www.youtube.com'
        source_locale: 'en'

    afterEach ->
      I18n.locale = I18n.defaultLocale

    describe 'rendering', ->
      beforeEach ->
        @view = new LinkView(model: @link)
        @$el = @view.render().$el

      it 'renders link element', ->
        expect(@$el).toBe(".link")

      it 'renders title', ->
        expect(@$el.find('.title')).toContainText(/What is CrossFit/)

      it 'renders summary', ->
        expect(@$el.find('.summary')).toContainText(/CrossFit is an effective way to get fit. Anyone can do it./)

      it 'renders source locale', ->
        expect(@$el.find('.lang')).toHaveText('en')
