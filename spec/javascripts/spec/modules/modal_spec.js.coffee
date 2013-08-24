define (require) ->

  Backbone = require 'backbone'
  ModalView = require 'modules/modal'

  describe 'ModalView', ->
    beforeEach ->
      @$sandbox = @createSandbox()
      @$modal = $('#modal')
      @view = new ModalView

    afterEach ->
      @destroySandbox()
      @view.remove()

    describe 'template', ->
      beforeEach -> @$el = $('<div></div>').html(@view.template())
      it 'has a header div', -> expect(@$el).toContain('.modal-header')
      it 'has a body div', -> expect(@$el).toContain('.modal-body')
      it 'has a footer div', -> expect(@$el).toContain('.modal-footer')

    describe 'events', ->

      describe 'when "show" event is fired', ->
        beforeEach -> @view.template = -> '<div class="myDiv"></div>'

        it 'renders the view', ->
          sinon.spy(@view, 'render')
          @view.trigger('show')
          expect(@view.render).toHaveBeenCalledOnce()
          expect(@view.render).toHaveBeenCalledWithExactly()

        it 'shows the modal', ->
          @$modal.hide()
          expect(@$modal).not.toBeVisible()
          @view.trigger('show')
          expect(@$modal).toBeVisible()
          expect(@$modal).toContain('div.myDiv')

      describe 'when "hide" event is fired', ->
        beforeEach -> @view.template = -> '<div class="myDiv"></div>'

        it 'hides the modal', ->
          @view.trigger('show')
          expect(@$modal).toBeVisible()
          @view.trigger('hide')
          expect(@$modal).not.toBeVisible()

        it 'empties the modal', ->
          @view.trigger('show')
          expect(@$modal).toBeVisible()
          @view.trigger('hide')
          expect(@$modal).toBeEmpty()

        it 'removes non-modal classes from modal element', ->
          @view.trigger('show')
          @view.$el.addClass('some-class')
          @view.trigger('hide')
          expect(@$modal).not.toHaveClass('some-class')
          expect(@$modal).toHaveClass('modal hide fade')

      describe 'when close button is clicked', ->
        beforeEach -> @view.template = -> '<button class="close"></button>'

        it 'hides the modal', ->
          @view.trigger('show')
          expect(@$modal).toBeVisible()
          @view.$('button').click()
          expect(@$modal).not.toBeVisible()

        it 'empties the modal', ->
          @view.trigger('show')
          expect(@$modal).toBeVisible()
          @view.$('button').click()
          expect(@$modal).toBeEmpty()

        it 'removes non-modal classes from modal element', ->
          @view.trigger('show')
          @view.$el.addClass('some-class')
          @view.$('button').click()
          expect(@$modal).not.toHaveClass('some-class')
          expect(@$modal).toHaveClass('modal hide fade')

    describe '#remove', ->
      it 'does not remove #modal element from page', ->
        @view.remove()
        expect($('body')).toContain('#modal')

      it 'empties #modal element', ->
        @view.template = -> '<div>some content</div>'
        @view.render()
        expect(@$modal).toHaveText('some content')
        @view.remove()
        expect(@$modal).toBeEmpty()

      it 'hides modal', ->
        @view.trigger('show')
        expect(@$modal).toBeVisible()
        @view.remove()
        expect(@$modal).not.toBeVisible()

      it 'unbinds show event', ->
        @$modal.hide()
        expect(@$modal).not.toBeVisible()
        @view.remove()
        @view.trigger('show')
        expect(@$modal).not.toBeVisible()

      it 'stops listening to other events', ->
        eventSpy = sinon.spy()
        model = new Backbone.Model
        @view.model = model
        @view.listenTo(model, 'change', eventSpy)
        @view.remove()
        model.set('foo', 'bar')
        expect(eventSpy).not.toHaveBeenCalled()

      it 'returns the view',  -> expect(@view.remove()).toEqual(@view)
