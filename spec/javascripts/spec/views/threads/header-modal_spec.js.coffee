define (require) ->

  ThreadHeaderModal = require('views/threads/header-modal')
  Thread = require('models/thread')

  describe 'ThreadHeaderModal', ->
    beforeEach ->
      @$sandbox = @createSandbox()
      @$sandbox.append(@createModal('thread-header-modal'))
      @thread = new Thread(
        title: en: 'a title'
        summary: en: 'a summary'
      )
      @thread.collection = url: '/collection'

    afterEach -> @destroySandbox()

    describe 'initiation', ->

    describe 'rendering', ->
      beforeEach ->
        @view = new ThreadHeaderModal(model: @thread)

      it 'returns the view object', -> expect(@view.render()).toEqual(@view)

      it 'adds #header-modal class', ->
        @view.render()
        expect(@view.$el).toHaveClass('header-modal')

      it 'renders modal title', ->
        @view.render()
        expect(@view.$('.modal-header')).toHaveText(/Edit title and summary/)

      it 'renders form', ->
        @view.render()
        expect(@view.$('.modal-body')).toContain('form')

      describe 'form', ->

        describe 'in source locale', ->
          beforeEach ->
            @view.render()
            @$form = @view.$('.modal-body form')

          it 'renders title field', ->
            expect(@$form).toHaveField('Title')
            expect(@$form.findField('Title')).toBe('input')

          it 'renders value of title in current locale', ->
            expect(@$form.findField('Title')).toHaveValue('a title')

          it 'renders summary field', ->
            expect(@$form).toHaveField('Summary')
            expect(@$form.findField('Summary')).toBe('textarea')

          it 'renders value of summary in current locale', ->
            expect(@$form.findField('Summary')).toHaveValue('a summary')

        describe 'in other locale', ->
          beforeEach ->
            I18n.locale = 'ja'
            @view.render()
            @$form = @view.$('.modal-body form')

          it 'renders title field', ->
            expect(@$form).toHaveField('タイトル')
            expect(@$form.findField('タイトル')).toBe('input')

          it 'renders blank title', ->
            expect(@$form.findField('タイトル')).toHaveValue('')

          it 'renders summary field', ->
            expect(@$form).toHaveField('サマリ')
            expect(@$form.findField('サマリ')).toBe('textarea')

          it 'renders blank summary', ->
            expect(@$form.findField('サマリ')).toHaveValue('')

      describe 'footer', ->
        beforeEach ->
          @view.render()
          @$footer = @view.$('.modal-footer')

        it 'renders submit button', ->
          expect(@$footer).toContain('button:contains("Save")')

        it 'renders cancel button', ->
          expect(@$footer).toContain('button:contains("Cancel")')

        it 'renders other language edit links', ->
          expect(@$footer).toContainText('Edit for Japanese')

    describe 'events', ->

      describe 'clicking save button', ->

        describe 'with valid data', ->
          beforeEach ->
            @view = new ThreadHeaderModal(model: @thread)
            @view.render()
            @server = sinon.fakeServer.create()
            @$saveButton = @view.$('button[type="submit"]')

            @thread.id = 123
            @view.$el.findField('Title').val('another title')
            @view.$el.findField('Summary').val('another summary')
            @server.respondWith(
              'PUT'
              '/collection/123'
              @validResponse(id: '123')
            )

          afterEach -> @server.restore()

          it 'makes correct request', ->
            @$saveButton.click()
            expect(@server.requests.length).toEqual(1)
            expect(@server.requests[0]).toBePUT()
            expect(@server.requests[0]).toHaveUrl('/collection/123')

          it 'sends valid data', ->
            @$saveButton.click()
            request = @server.requests[0]
            params = JSON.parse(request.requestBody)
            expect(params.thread).toBeDefined()
            expect(params.thread.title).toEqual(en: 'another title')
            expect(params.thread.summary).toEqual(en: 'another summary')

          it 'does not trigger any errors', ->
            @$saveButton.click()
            @server.respond()
            expect(@view.$el).not.toContain('.error')
            expect(@thread.validationError).toBeNull()

          it 'closes the modal', ->
            @$saveButton.click()
            @server.respond()
            expect(@$sandbox).not.toContain('form')

        xdescribe 'with invalid data'

      describe 'clicking cancel button', ->
        beforeEach ->
          @view = new ThreadHeaderModal(model: @thread)
          @view.render()
          @view.trigger('show')
          @$cancelButton = @view.$('button[type="cancel"]')

        it 'hides the modal', ->
          expect(@view.$el).toBeVisible()
          @$cancelButton.click()
          expect(@view.$el).not.toBeVisible()

      describe 'clicking language switcher', ->
        beforeEach ->
          @thread.set(title: ja: '日本語のタイトル')
          @view = new ThreadHeaderModal(model: @thread)
          @view.render()
          @view.trigger('show')
          @$button = @view.$('a[lang="ja"]')

        it 'changes title', ->
          @$button.click()
          expect(@view.$el.find('.modal-header')).toContainText('Edit title and summary in Japanese')

        it 're-renders form in new locale', ->
          expect(@view.$el.findField('Title')).toHaveValue('a title')
          expect(@view.$el.findField('Summary')).toHaveValue('a summary')
          @$button.click()
          expect(@view.$el).toHaveField('Title')
          expect(@view.$el.findField('Title')).toHaveValue('日本語のタイトル')
          expect(@view.$el).toHaveField('Summary')
          expect(@view.$el.findField('Summary')).toHaveValue('')
