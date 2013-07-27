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


      describe 'summary', ->
        it 'renders summary field', ->
          expect(@view.$el).toContain(summarySelector)

        it 'sets summary field to readonly until source locale has been selected', ->
          expect(@view.$(summarySelector)).toHaveAttr('readonly')

        it 'prefills summary field with description from embed data', ->
          @model.getEmbedData = -> description: 'a summary'
          @view.render()
          expect(@view.$(summarySelector)).toHaveValue('a summary')

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

        it 'removes any existing errors on source locale', ->
          @view.$('.control-group.source_locale').addClass('error')
          @view.$('.control-group .help-block').html('an error message')
          @view.$('select').val('en').trigger('change')
          expect(@view.$('.control-group.source_locale')).not.toHaveClass('error')
          expect(@view.$('.control-group .help-block')).toBeEmpty()

      describe 'submitting link form data', ->
        beforeEach ->
          @view.render()
          @server = sinon.fakeServer.create()
          @server.respondWith(
            'PUT'
            '/en/links/http%3A%2F%2Fwww.example.com'
            @validResponse(url: '123')
          )
          @$nextButton = @view.$('button.next')

        afterEach -> @server.restore()

        it 'calls next', ->
          @$nextButton.click()
          expect(@nextSpy).toHaveBeenCalledOnce()

        describe 'with valid data', ->
          beforeEach ->
            @view.$('select').val('en')
            @view.$('.title textarea').val('a title')
            @view.$('.summary textarea').val('a summary')

          it 'makes correct request', ->
            @$nextButton.click()
            expect(@server.requests.length).toEqual(1)
            expect(@server.requests[0]).toBePUT()
            expect(@server.requests[0]).toHaveUrl('/en/links/http%3A%2F%2Fwww.example.com')

          it 'sends valid data', ->
            @$nextButton.click()
            request = @server.requests[0]
            params = JSON.parse(request.requestBody)
            expect(params.link).toBeDefined()
            expect(params.link.source_locale).toEqual('en')
            expect(params.link.title).toEqual(en: 'a title')
            expect(params.link.summary).toEqual(en: 'a summary')

          it 'sets model values from form', ->
            @$nextButton.click()
            @server.respond()
            expect(@model.getSourceLocale()).toEqual('en')
            expect(@model.getAttr('title')).toEqual('a title')
            expect(@model.getAttr('summary')).toEqual('a summary')

          it 'does not trigger any errors', ->
            @$nextButton.click()
            @server.respond()
            expect(@view.$el).not.toContain('.error')
            expect(@model.validationError).toBeNull()

          it 'calls leave on view', ->
            sinon.spy(@view, 'leave')
            @$nextButton.click()
            @server.respond()
            expect(@view.leave).toHaveBeenCalledOnce()
            expect(@view.leave).toHaveBeenCalledWithExactly()
            @view.leave.restore()

          it 'triggers modal:next event on channel', ->
            eventSpy = sinon.spy()
            channel.on('modal:next', eventSpy)
            @$nextButton.click()
            @server.respond()
            expect(eventSpy).toHaveBeenCalledOnce()

        describe 'with invalid data', ->

          it 'makes no request', ->
            @$nextButton.click()
            expect(@server.requests.length).toEqual(0)

          it 'renders error if source locale is not set', ->
            @$nextButton.click()
            expect(@view.$('.control-group.source_locale')).toHaveClass('error')

          it 'renders error if title is blank', ->
            @view.$('select').val('en')
            @view.$('.title textarea').val('')
            @$nextButton.click()
            expect(@view.$('.control-group.title')).toHaveClass('error')
