define (require) ->

  ThreadHeaderModal = require('views/threads/header-modal')
  Thread = require('models/thread')

  describe 'ThreadHeaderModal', ->
    beforeEach ->
      @$sandbox = @createSandbox()
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
        @view.render()

      it 'returns the view object', -> expect(@view.render()).toEqual(@view)
      it 'adds #header-modal class', -> expect(@view.$el).toHaveClass('header-modal')
      it 'renders modal title', -> expect(@view.$('.modal-header')).toHaveText(/Edit title and summary/)
      it 'renders form', -> expect(@view.$('.modal-body')).toContain('form')

      describe 'form', ->
        beforeEach -> @$form = @view.$('.modal-body form')

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

      describe 'footer', ->
        beforeEach -> @$footer = @view.$('.modal-footer')

        it 'renders submit button', ->
          expect(@$footer).toContain('button:contains("Save")')

        it 'renders cancel button', ->
          expect(@$footer).toContain('button:contains("Cancel")')

        it 'renders other language edit links', ->
          expect(@$footer).toContainText('Edit for Japanese')

    describe 'events', ->

      describe 'clicking save button', ->
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

        it 'updates the thread', ->
          @$saveButton.click()
          expect(@server.requests.length).toEqual(1)
          expect(@server.requests[0]).toBePUT()
          expect(@server.requests[0]).toHaveUrl('/collection/123')
