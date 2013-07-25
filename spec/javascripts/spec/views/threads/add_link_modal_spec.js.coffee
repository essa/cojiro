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

      it 'throws no error if passed no options', ->
        expect(-> new AddLinkModalView().not.toThrow())

      it 'throws error if passed model in options', ->
        options = model: {}
        expect(-> new AddLinkModalView(options)).toThrow('no model needed')

    describe 'rendering', ->
      beforeEach ->
        # create stub child modal view
        @modalView = new Backbone.View
        @modalView.render = () ->
          @el = document.createElement('div')
          @el.setAttribute('class', 'stub-modal')
          @
        @modalView.leave = ->
        sinon.spy(@modalView, 'render')

        @model = sinon.stub()
        @model.getUrl = -> 'http://www.example.com'

        modalEl = $('<div id="modal" class="modal hide fade"></div>')
        $('body').append(modalEl)

      afterEach ->
        $('#modal').remove()

      describe 'invalid step', ->
        it 'throws error', ->
          @view = new AddLinkModalView
          @view.step = -1
          self = @
          expect(-> self.view.render()).toThrow('invalid step')

      #TODO: refactor this into shared examples
      describe 'register url view (step 1)', ->
        beforeEach ->
          @RegisterUrlView = sinon.stub().returns(@modalView)
          @ConfirmLinkDetailsView = sinon.stub().returns(@modalView)
          @Link = sinon.stub().returns(@model)
          @view = new AddLinkModalView
            Link: @Link
            RegisterUrlView: @RegisterUrlView
            ConfirmLinkDetailsView: @ConfirmLinkDetailsView

        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        describe 'cleaning up', ->
          it 'calls leave on any existing modal', ->
            modal = leave: ->
            sinon.spy(modal, 'leave')
            @view.modal = modal
            @view.render()
            expect(modal.leave).toHaveBeenCalledOnce()

          it 'creates a new link model', ->
            @view.render()
            expect(@Link.calledWithNew()).toBeTruthy()
            expect(@Link).toHaveBeenCalledWithExactly()

        describe 'element classes', ->

          it 'has default classes', ->
            @view.render()
            expect(@view.$el).toHaveClass('modal')
            expect(@view.$el).toHaveClass('hide')
            expect(@view.$el).toHaveClass('fade')

          it 'has register-url class', ->
            @view.render()
            expect(@view.$el).toHaveClass('register-url')

          it 'does not leave classes from other steps', ->
            originalClass = @view.render().$el.attr('class')
            @view.step = 2
            @view.render()
            @view.step = 1
            expect(@view.render().$el).toHaveAttr('class', originalClass)

        describe 'rendering the modal', ->

          it 'creates a RegisterUrlView', ->
            @view.render()
            expect(@RegisterUrlView).toHaveBeenCalledOnce()
            expect(@RegisterUrlView).toHaveBeenCalledWithExactly(model: @model)

          it 'renders newly-created RegisterUrlView', ->
            $el = @view.render().$el
            expect(@modalView.render).toHaveBeenCalledOnce()

          it 'inserts form html into .modal-body element', ->
            $el = @view.render().$el
            expect($el).toContain('div.stub-modal')

      describe 'confirm link details view (step 2)', ->
        beforeEach ->
          @ConfirmLinkDetailsView = sinon.stub().returns(@modalView)
          @Link = sinon.stub()
          @view = new AddLinkModalView
            ConfirmLinkDetailsView: @ConfirmLinkDetailsView
            Link: @Link
            step: 2
          @view.model = @model

        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        describe 'cleaning up', ->
          it 'calls leave on any existing modal', ->
            modal = leave: ->
            sinon.spy(modal, 'leave')
            @view.modal = modal
            @view.render()
            expect(modal.leave).toHaveBeenCalledOnce()

        describe 'element classes', ->

          it 'has default classes', ->
            @view.render()
            expect(@view.$el).toHaveClass('modal')
            expect(@view.$el).toHaveClass('hide')
            expect(@view.$el).toHaveClass('fade')

          it 'has confirm-link-details class', ->
            @view.render()
            expect(@view.$el).toHaveClass('confirm-link-details')

          it 'does not leave classes from other steps', ->
            originalClass = @view.render().$el.attr('class')
            @view.step = 1
            @view.render()
            @view.step = 2
            expect(@view.render().$el).toHaveAttr('class', originalClass)

        describe 'rendering the modal', ->

          it 'does not create a new model', ->
            @view.render()
            expect(@Link.calledWithNew()).toBeFalsy()

          it 'creates a ConfirmLinkDetailsView', ->
            @view.render()
            expect(@ConfirmLinkDetailsView).toHaveBeenCalledOnce()
            expect(@ConfirmLinkDetailsView).toHaveBeenCalledWithExactly(model: @model)

          it 'renders newly-created RegisterUrlView', ->
            $el = @view.render().$el
            expect(@modalView.render).toHaveBeenCalledOnce()

          it 'inserts form html into .modal-body element', ->
            $el = @view.render().$el
            expect($el).toContain('div.stub-modal')

    describe 'events', ->
      beforeEach ->
        @ConfirmLinkDetailsView = sinon.stub()
        @RegisterUrlView = sinon.stub()
        @Link = sinon.stub()
        @view = new AddLinkModalView
          ConfirmLinkDetailsView: @ConfirmLinkDetailsView
          RegisterUrlView: @RegisterUrlView
          Link: @Link
        sinon.stub(@view, 'render')

      afterEach ->
        @view.render.restore()

      describe 'go to next step', ->
        it 'increments the step', ->
          channel.trigger('modal:next')
          expect(@view.step).toEqual(2)

        it 're-renders the view', ->
          channel.trigger('modal:next')
          expect(@view.render).toHaveBeenCalledOnce()
          expect(@view.render).toHaveBeenCalledWithExactly()

      describe 'go to previous step', ->
        it 'decrements the step if step > 1', ->
          @view.step = 2
          channel.trigger('modal:prev')
          expect(@view.step).toEqual(1)

        it 'does not change the step if step == 1', ->
          @view.step = 1
          channel.trigger('modal:prev')
          expect(@view.step).toEqual(1)

        it 're-renders the view', ->
          channel.trigger('modal:prev')
          expect(@view.render).toHaveBeenCalledOnce()
          expect(@view.render).toHaveBeenCalledWithExactly()
