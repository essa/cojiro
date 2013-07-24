define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  ConfirmLinkDetailsView = require('views/links/confirm_link_details')
  I18n = require('i18n')
  channel = require('modules/channel')

  titleSelector = 'input[name="title-xx"],textarea[name="title-xx"]'
  summarySelector = 'input[name="summary-xx"],textarea[name="summary-xx"]'

  describe 'ConfirmLinkDetailsView', ->
    beforeEach ->
      I18n.locale = 'en'
      @nextSpy = sinon.spy(ConfirmLinkDetailsView.prototype, 'next')
      @model = new Link(url: 'http://www.example.com')
      @view = new ConfirmLinkDetailsView(model: @model)

    afterEach ->
      @nextSpy.restore()

    describe 'instantiation', ->
      beforeEach -> @$el = @view.$el

      it 'creates a div element for the form', ->
        expect(@$el).toBe('div')

    describe 'rendering', ->
      beforeEach -> @view.render()

      it 'returns the view object', ->
        expect(@view.render()).toEqual(@view)

      it 'renders modal title', ->
        $el = @view.render().$el
        expect($el.find('.modal-header')).toHaveText(/Confirm link details/)

      it 'renders url in title', ->
        @view.render()
        expect(@view.$('.modal-header')).toContain('small:contains("http://www.example.com")')

      it 'renders form with bootstrap form-horizontal class', ->
        expect(@view.$('form')).toHaveClass('form-horizontal')

      it 'renders modal confirm button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn-primary:contains("Confirm")')

      it 'renders modal back button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn:contains("Back")')

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
          @model.getEmbedData = -> title: 'a title'
          @view.render()
          expect(@view.$(titleSelector)).toHaveValue('a title')

        it 'sets rows attribute', ->
          @view.render()
          expect(@view.$(titleSelector)).toHaveAttr('rows', 2)

      describe 'summary', ->
        it 'renders summary field', ->
          expect(@view.$el).toContain(summarySelector)

        it 'sets summary field to readonly until source locale has been selected', ->
          expect(@view.$(summarySelector)).toHaveAttr('readonly')

        it 'prefills summary field with description from embed data', ->
          @model.getEmbedData = -> description: 'a summary'
          @view.render()
          expect(@view.$(summarySelector)).toHaveValue('a summary')

        it 'sets rows attribute', ->
          @view.render()
          expect(@view.$(summarySelector)).toHaveAttr('rows', 5)

      describe 'cleaning up', ->

        it 'calls leave on any existing header', ->
          header =
            leave: ->
            render: ->
          sinon.spy(header, 'leave')
          @view.header = header
          @view.render()
          @view.leave()
          expect(header.leave).toHaveBeenCalledOnce()

        it 'calls leave on any existing footer', ->
          footer =
            leave: ->
            render: ->
          sinon.spy(footer, 'leave')
          @view.footer = footer
          @view.render()
          @view.leave()
          expect(footer.leave).toHaveBeenCalledOnce()

        xit 'calls leave on any existing form'

    describe 'events', ->

      describe 'when source locale is selected', ->
        beforeEach ->
          @view.render()

        it 'updates the title label with the language', ->
          expect(@view.$('.title-xx label')).toHaveText('Title')
          @view.$('select').val('ja').trigger('change')
          expect(@view.$('.title-xx label')).toHaveText('Title in Japanese')

        it 'updates the summary label with the language', ->
          expect(@view.$('.summary-xx label')).toHaveText('Summary')
          @view.$('select').val('ja').trigger('change')
          expect(@view.$('.summary-xx label')).toHaveText('Summary in Japanese')

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

      describe 'submitting link form data', ->
        beforeEach ->
          @view.render()
          sinon.stub(@model, 'save')

        it 'calls next', ->
          @view.$('button.next').click()
          expect(@nextSpy).toHaveBeenCalledOnce()
