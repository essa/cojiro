define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  AddUrlView = require('views/threads/add_url')
  channel = require('modules/channel')

  describe 'AddUrlView', ->
    beforeEach ->
      I18n.locale = 'en'

    describe 'with no Link model', ->
      beforeEach -> @view = new AddUrlView

      describe 'initialization', ->
        beforeEach -> @$el = @view.$el

        it 'creates a div element for the form', ->
          expect(@$el).toBe('div')

      describe 'rendering', ->
        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        it 'renders modal title', ->
          @view.render()
          expect(@view.$('.modal-header')).toHaveText(/Add a link/)

        it 'renders form with bootstrap form-inline class', ->
          @view.render()
          expect(@view.$('form')).toHaveClass('form-inline')

        it 'renders URL input form', ->
          @view.render()
          expect(@view.$('label')).toHaveText('URL:')

        it 'renders placeholder "Enter a URL"', ->
          @view.render().$el
          expect(@view.$('input')).toHaveAttr('placeholder', 'Enter a URL...')

        it 'renders Go! string', ->
          @view.render()
          expect(@view.$('button[type="submit"]')).toHaveText('Go!')

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

    describe 'with real Link model', ->
      beforeEach ->
        @model = new Link
        @addUrlSpy = sinon.spy(AddUrlView::, 'addUrl')

      afterEach ->
        @addUrlSpy.restore()

      describe 'saving the link', ->
        beforeEach ->
          @view = new AddUrlView(model: @model)
          @view.render()
          @$form = @view.$('form')

        describe 'submitting url form', ->
          beforeEach ->
            sinon.stub(@model, 'save')

          afterEach ->
            @model.save.restore()

          it 'calls addUrl', ->
            @$form.submit()
            expect(@addUrlSpy).toHaveBeenCalledOnce()

          it 'prevents default form submission', ->
            spyEvent = spyOnEvent(@$form, 'submit')
            @$form.submit()
            expect('submit').toHaveBeenPreventedOn(@$form)
            expect(spyEvent).toHaveBeenPrevented()

          it 'sets the url', ->
            @view.$('form input').val('http://www.example.com')
            @$form.submit()
            expect(@model.get('url')).toEqual('http://www.example.com')

          describe 'valid data', ->

            it 'saves the link if data is valid', ->
              sinon.stub(@model, 'set')
              @view.$('form input').val('http://www.example.com')
              @$form.submit()
              expect(@model.save).toHaveBeenCalledOnce()
              @model.set.restore()

          describe 'invalid data', ->

            it 'does not save link if data is not valid', ->
              sinon.stub(@model, 'set')
              @view.$('form input').val('')
              @$form.submit()
              expect(@model.save).not.toHaveBeenCalled()

            it 'renders error', ->
              sinon.stub(@model, 'set')
              @view.$('form input').val('')
              @$form.submit()
              expect(@$form.find('input[name="url"]')).toHaveClass('error')

        describe 'interacting with the server', ->
          beforeEach ->
            @view.$('form input').val('http://www.example.com')
            @server = sinon.fakeServer.create()
          afterEach -> @server.restore()

          describe 'request', ->
            beforeEach -> @$form.submit()

            it 'makes a PUT request', ->
              expect(@server.requests[0]).toBePUT()

            it 'makes a request to the correct URL', ->
              expect(@server.requests[0]).toHaveUrl('/en/links/http%3A%2F%2Fwww.example.com')

          describe 'after a successful save', ->
            beforeEach ->
              @server.respondWith(
                'PUT'
                '/en/links/http%3A%2F%2Fwww.example.com'
                @validResponse
                  id: 123
                  url: 'http://www.example.com/'
                  source_locale: {}
              )

            it 'calls leave to unbind events and remove from document', ->
              sinon.spy(@view, 'leave')
              @$form.submit()
              @server.respond()
              expect(@view.leave).toHaveBeenCalled()
              expect(@view.leave).toHaveBeenCalledWithExactly()
              @view.leave.restore()

            it 'triggers modal:next event on channel', ->
              eventSpy = sinon.spy()
              channel.on('modal:next', eventSpy)
              @$form.submit()
              @server.respond()
              expect(eventSpy).toHaveBeenCalledOnce()

          describe 'after an unsuccessful save', ->
            xit 'renders errors'
