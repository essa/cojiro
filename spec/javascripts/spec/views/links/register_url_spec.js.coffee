define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  RegisterUrlView = require('views/links/register_url')
  channel = require('modules/channel')

  describe 'RegisterUrlView', ->
    beforeEach ->
      I18n.locale = 'en'

    describe 'with no Link model', ->
      beforeEach ->
        @view = new RegisterUrlView

      describe 'instantiation', ->
        beforeEach -> @$el = @view.$el

        it 'creates a div element for the form', ->
          expect(@$el).toBe('div')

        it 'has form class', ->
          expect(@$el).toHaveClass('form')

      describe 'rendering', ->
        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        it 'renders form with bootstrap and register-url-form classes', ->
          @view.render()
          expect(@view.$('form')).toHaveClass('form-inline register-url-form')

        it 'renders URL input form', ->
          @view.render()
          expect(@view.$('label')).toHaveText('URL')

        it 'renders placeholder "Enter a URL"', ->
          @view.render().$el
          expect(@view.$('input')).toHaveAttr('placeholder', 'Enter a URL...')

        it 'renders Go! string', ->
          @view.render()
          expect(@view.$('button')).toHaveText('Go!')

    describe 'with real Link model', ->
      beforeEach ->
        @model = new Link
        @registerUrlSpy = sinon.spy(RegisterUrlView.prototype, 'registerUrl')
        @goToNextSpy = sinon.spy(RegisterUrlView.prototype, 'goToNext')

      afterEach ->
        RegisterUrlView.prototype.registerUrl.restore()
        RegisterUrlView.prototype.goToNext.restore()

      describe 'saving the link', ->
        beforeEach ->
          @view = new RegisterUrlView(model: @model)
          @view.render()
          @$form = @view.$('form')

        describe 'submitting url form', ->
          beforeEach ->
            sinon.stub(@model, 'save')

          afterEach ->
            @model.save.restore()

          it 'calls registerUrl', ->
            @$form.submit()
            expect(@registerUrlSpy).toHaveBeenCalledOnce()

          it 'prevents default form submission', ->
            spyEvent = spyOnEvent(@$form, 'submit')
            @$form.submit()
            expect('submit').toHaveBeenPreventedOn(@$form)
            expect(spyEvent).toHaveBeenPrevented()

          it 'sets the url', ->
            @view.$('form input').val('http://www.example.com')
            @$form.submit()
            expect(@model.get('url')).toEqual('http://www.example.com')

          it 'saves the link', ->
            sinon.stub(@model, 'set')
            @$form.submit()
            expect(@model.save).toHaveBeenCalledOnce()
            @model.set.restore()

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
                @validResponse(id: '123')
              )

            it 'calls leave to unbind events and remove from document', ->
              sinon.spy(@view, 'leave')
              @$form.submit()
              @server.respond()
              expect(@view.leave).toHaveBeenCalled()
              expect(@view.leave).toHaveBeenCalledWithExactly()
              @view.leave.restore()

            it 'triggers registerUrlView:success event on channel', ->
              eventSpy = sinon.spy()
              channel.on('registerUrlView:success', eventSpy)
              @$form.submit()
              @server.respond()
              expect(eventSpy).toHaveBeenCalledOnce()

          describe 'after an unsuccessful save', ->
            xit 'renders errors'
