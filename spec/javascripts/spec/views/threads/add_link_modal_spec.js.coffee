define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  AddLinkModalView = require('views/threads/add_link_modal')
  RegisterUrlView = require('views/links/register_url')
  ConfirmLinkDetailsView = require('views/links/confirm_link_details')
  channel = require('modules/channel')

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
        # create stub child modal view
        @modalView = new Backbone.View()
        @modalView.render = () ->
          @el = document.createElement('div')
          @el.setAttribute('class', 'stub-modal')
          @
        sinon.spy(@modalView, 'render')

      describe 'register url view (step 1)', ->
        beforeEach ->
          @model = sinon.stub()
          @RegisterUrlView = sinon.stub().returns(@modalView)
          @view = new AddLinkModalView
            model: @model
            RegisterUrlView: @RegisterUrlView

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
          expect(@modalView.render).toHaveBeenCalledOnce()

        it 'inserts form html into .modal-body element', ->
          $el = @view.render().$el
          expect($el.find('.modal-body')).toContain('div.stub-modal')

      describe 'confirm link details view (step 2)', ->
        beforeEach ->
          @model = sinon.stub()
          @ConfirmLinkDetailsView = sinon.stub().returns(@modalView)
          @view = new AddLinkModalView
            model: @model
            ConfirmLinkDetailsView: @ConfirmLinkDetailsView
            step: 2

        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        it 'renders modal title', ->
          $el = @view.render().$el
          expect($el.find('.modal-header')).toHaveText(/Confirm link details/)

        it 'creates a ConfirmLinkDetailsView', ->
          @view.render()
          expect(@ConfirmLinkDetailsView).toHaveBeenCalledOnce()
          expect(@ConfirmLinkDetailsView).toHaveBeenCalledWithExactly(model: @model)

        it 'renders newly-created RegisterUrlView', ->
          $el = @view.render().$el
          expect(@modalView.render).toHaveBeenCalledOnce()

        it 'inserts form html into .modal-body element', ->
          $el = @view.render().$el
          expect($el.find('.modal-body')).toContain('div.stub-modal')

      describe 'after a url is successfully registered', ->
        beforeEach ->
          @model = sinon.stub()
          @ConfirmLinkDetailsView = sinon.stub().returns(@modalView)
          @view = new AddLinkModalView
            model: @model
            ConfirmLinkDetailsView: @ConfirmLinkDetailsView

        it 'increments the step variable', ->
          channel.trigger('registerUrlView:success')
          expect(@view.step).toEqual(2)

        it 're-renders the parent view', ->
          sinon.spy(@view, 'render')
          channel.trigger('registerUrlView:success')
          expect(@view.render).toHaveBeenCalledOnce()
          expect(@view.render).toHaveBeenCalledWithExactly()

        it 'renders the confirm details view', ->
          channel.trigger('registerUrlView:success')
          expect(@modalView.render).toHaveBeenCalledOnce()
          expect(@modalView.render).toHaveBeenCalledWithExactly()
