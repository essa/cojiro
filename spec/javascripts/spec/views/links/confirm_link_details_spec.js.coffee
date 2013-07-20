define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  ConfirmLinkDetailsView = require('views/links/confirm_link_details')
  I18n = require('i18n')
  channel = require('modules/channel')

  titleSelector = 'input[name="title"],textarea[name="title"]'
  summarySelector = 'input[name="summary"],textarea[name="summary"]'


  describe 'ConfirmLinkDetailsView', ->
    beforeEach ->
      I18n.locale = 'en'

    describe 'with no Link model', ->
      beforeEach -> @view = new ConfirmLinkDetailsView

      describe 'instantiation', ->
        beforeEach -> @$el = @view.$el

        it 'creates a div element for the form', ->
          expect(@$el).toBe('div')

        it 'has form class', ->
          expect(@$el).toHaveClass('form')

    describe 'with real Link model', ->
      beforeEach ->
        @model = new Link(url: 'http://www.example.com')
        @view = new ConfirmLinkDetailsView(model: @model)

      describe 'rendering', ->
        beforeEach -> @view.render()

        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        it 'renders form with bootstrap form-horizontal class', ->
          expect(@view.$('form')).toHaveClass('form-horizontal')

        describe 'source locale', ->
          it 'renders source_locale label', ->
            expect(@view.$el).toContainText('This link is in')

          it 'renders source_locale drop-down', ->
            expect(@view.$el).toContain('select[name="source_locale"]')

          it 'renders default option', ->
            expect(@view.$el).toContain('option[value=""]')
            expect(@view.$('option[value=""]')).toHaveText('Select a language')

          it 'renders an option for every locale in I18n.availableLocales', ->
            expect(@view.$el).toContain('option[value="en"]')
            expect(@view.$('option[value="en"]')).toHaveText('English')
            expect(@view.$el).toContain('option[value="ja"]')
            expect(@view.$('option[value="ja"]')).toHaveText('Japanese')

        describe 'title', ->
          it 'renders title field', ->
            expect(@view.$el).toContain(titleSelector)

          it 'sets title field to readonly until source locale has been selected', ->
            expect(@view.$(titleSelector)).toHaveAttr('readonly')

          it 'prefills title field with title from embed data', ->
            sinon.stub(@model, 'get').withArgs('embed_data').returns(title: 'a title')
            @view.render()
            expect(@view.$(titleSelector)).toHaveValue('a title')

        describe 'summary', ->
          it 'renders summary field', ->
            expect(@view.$el).toContain(summarySelector)

          it 'sets summary field to readonly until source locale has been selected', ->
            expect(@view.$(summarySelector)).toHaveAttr('readonly')

          it 'prefills summary field with description from embed data', ->
            sinon.stub(@model, 'get').withArgs('embed_data').returns(description: 'a summary')
            @view.render()
            expect(@view.$(summarySelector)).toHaveValue('a summary')

      describe 'events', ->

        describe 'when source locale is selected', ->
          beforeEach ->
            @view.render()

          it 'updates the title label with the language', ->
            expect(@view.$('.title label')).toHaveText('Title')
            @view.$('select').val('ja').trigger('change')
            expect(@view.$('.title label')).toHaveText('Title in Japanese')

          it 'updates the summary label with the language', ->
            expect(@view.$('.summary label')).toHaveText('Summary')
            @view.$('select').val('ja').trigger('change')
            expect(@view.$('.summary label')).toHaveText('Summary in Japanese')

          it 'removes readonly restriction on title field', ->
            expect(@view.$(titleSelector)).toHaveAttr('readonly')
            @view.$('select').val('ja').trigger('change')
            expect(@view.$(titleSelector)).not.toHaveAttr('readonly')

          it 'removes readonly restriction on summary field', ->
            expect(@view.$(summarySelector)).toHaveAttr('readonly')
            @view.$('select').val('ja').trigger('change')
            expect(@view.$(summarySelector)).not.toHaveAttr('readonly')

          it 'removes default source locale option', ->
            expect(@view.$('select[name="source_locale"] option[value=""]').length).toEqual(1)
            @view.$('select').val('ja').trigger('change')
            expect(@view.$('select[name="source_locale"] option[value=""]').length).toEqual(0)
