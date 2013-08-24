define (require) ->

  Backbone = require('backbone')

  ModalFooterView = require('views/modals/footer')
  channel = require('modules/channel')

  describe 'ModalFooterView', ->
    beforeEach ->
      @view = new ModalFooterView
        cancel: 'Back'
        submit: 'Next'

    describe 'rendering', ->
      it 'returns the view', ->
        expect(@view.render()).toBe(@view)

      it 'renders previous button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn:contains("Back")')

      it 'renders next button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn.btn-primary:contains("Next")')
