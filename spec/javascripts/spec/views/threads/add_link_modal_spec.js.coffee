define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  AddLinkModalView = require('views/threads/add_link_modal')
  RegisterUrlView = require('views/links/register_url')

  describe "AddLinkModalView", ->
    beforeEach ->
      I18n.locale = 'en'

    describe 'instantiation', ->
      beforeEach -> @options = model: {}

      it 'throws no error if passed required options', ->
        options = @options
        expect(-> new AddLinkModalView(options)).not.toThrow()

      it 'throws error if not passed model', ->
        options = _(@options).extend(model: null)
        expect(-> new AddLinkModalView(@options)).toThrow('model required')

    describe 'rendering', ->
      beforeEach ->
        # create stub child view
        @registerUrlView = new Backbone.View()
        @registerUrlView.render = () ->
          @el = document.createElement('form')
          @
        sinon.spy(@registerUrlView, 'render')
        @model = sinon.stub()
        @RegisterUrlView = sinon.stub().returns(@registerUrlView)
        @view = new AddLinkModalView
          model: @model
          RegisterUrlView: @RegisterUrlView

      afterEach -> @registerUrlView.render.restore()

      it 'returns the view object', ->
        expect(@view.render()).toEqual(@view)

      it 'renders modal title', ->
        $el = @view.render().$el
        expect($el.find('.modal-header')).toHaveText(/Add a link/)

      it 'creates a RegisterUrlView', ->
        @view.render()
        expect(@RegisterUrlView).toHaveBeenCalledOnce()
        expect(@RegisterUrlView).toHaveBeenCalledWithExactly(model: @model)

      it 'renders newly-created RegisterUrlView', ->
        $el = @view.render().$el
        expect(@registerUrlView.render).toHaveBeenCalledOnce()

      it 'inserts form html into .modal-body element', ->
        $el = @view.render().$el
        expect($el.find('.modal-body')).toContain('form')
