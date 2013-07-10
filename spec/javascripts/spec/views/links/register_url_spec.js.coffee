define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  RegisterUrlView = require('views/links/register_url')

  describe 'RegisterUrlView', ->
    beforeEach ->
      I18n.locale = 'en'

    describe 'with no Link model', ->
      beforeEach ->
        @view = new RegisterUrlView

      describe 'instantiation', ->
        beforeEach -> @$el = @view.$el

        it 'creates a form element for view', ->
          expect(@$el).toBe('form')

        it 'has bootstrap and register-url-form classes', ->
          expect(@$el).toHaveClass('form-inline')
          expect(@$el).toHaveClass('register-url-form')

      describe 'rendering', ->
        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

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

      afterEach ->
        RegisterUrlView.prototype.registerUrl.restore()

      describe 'saving the link', ->
