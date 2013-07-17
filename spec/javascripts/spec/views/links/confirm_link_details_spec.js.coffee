define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  ConfirmLinkDetailsView = require('views/links/confirm_link_details')
  I18n = require('i18n')
  cannel = require('modules/channel')

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

        it 'renders form with bootstrap and confirm-link-details classes', ->
          expect(@view.$('form')).toHaveClass('form-horizontal confirm-link-details-form')

        describe 'url', ->
          it 'renders url field', ->
            expect(@view.$el).toContain('input[name="url"][value="http://www.example.com"]')

          it 'sets url field to readonly', ->
            expect(@view.$('input[name="url"]')).toHaveAttr('readonly')

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
          it 'renders title input field', ->
            expect(@view.$el).toContain('input[name="title"]')

          it 'sets title field to readonly until source locale has been selected', ->
            expect(@view.$('input[name="title"]')).toHaveAttr('readonly')

          it 'prefills title field with title from embed data', ->
            sinon.stub(@model, 'get').withArgs('embed_data').returns(title: 'a title')
            @view.render()
            expect(@view.$('input[name="title"]')).toHaveValue('a title')

      describe 'events', ->

        describe 'when source locale is selected', ->
          beforeEach ->
            @view.render()
            @view.$('select').val('ja').trigger('change')

          it 'updates the title label with the language', ->
            expect(@view.$('.title label')).toHaveText('Title in Japanese')

          it 'removes readonly restriction on title field', ->
            expect(@view.$('input[name="title"]')).not.toHaveAttr('readonly')

          it 'removes default source locale option', ->
            expect(@view.$('select[name="source_locale"] option[value=""]').length).toEqual(0)
