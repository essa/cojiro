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

      it 'renders site name', ->
        expect(@view.$('.site')).toHaveText('www.youtube.com')

      it 'renders source locale', ->
        expect(@$el.find('.lang')).toHaveText('en')

    describe 'translatable fields'
      beforeEach ->
        @view = new LinkView

      it 'renders title field', ->
        sinon.spy(@view.titleField, 'render')
        @view.render()
        expect(@view.titleField.render).toHaveBeenCalledOnce()
        expect(@view.titleField.render).toHaveBeenCalledWithExactly()
        @view.titleField.render.restore()

      it 'renders summary field', ->
        sinon.spy(@view.summaryField, 'render')
        @view.render()
        expect(@view.summaryField.render).toHaveBeenCalledOnce()
        expect(@view.summaryField.render).toHaveBeenCalledWithExactly()
        @view.summaryField.render.restore()

      it 'calls leave on titleField when closing', ->
        sinon.spy(@view.titleField, 'leave')
        @view.render()
        @view.leave()
        expect(@view.titleField.leave).toHaveBeenCalledOnce()
        expect(@view.titleField.leave).toHaveBeenCalledWithExactly()
        @view.titleField.leave.restore()

      it 'calls leave on summaryField when closing', ->
        sinon.spy(@view.summaryField, 'leave')
        @view.render()
        @view.leave()
        expect(@view.summaryField.leave).toHaveBeenCalledOnce()
        expect(@view.summaryField.leave).toHaveBeenCalledWithExactly()
        @view.summaryField.leave.restore()
