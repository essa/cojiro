define (require) ->

  Backbone = require('backbone')

  ModalFooterView = require('views/modals/footer')
  channel = require('modules/channel')

  describe 'ModalFooterView', ->
    beforeEach ->
      @view = new ModalFooterView
        prevString: 'Back'
        nextString: 'Next'

    describe 'rendering', ->
      it 'returns the view', ->
        expect(@view.render()).toBe(@view)

      it 'renders previous button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn:contains("Back")')

      it 'renders next button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn.btn-primary:contains("Next")')

    describe 'events', ->
      beforeEach ->
        @view.render()

      it 'triggers modal:next event on channel when next button is clicked', ->
        eventSpy = sinon.spy()
        channel.on('modal:next', eventSpy)
        @view.$('button:contains("Next")').click()
        expect(eventSpy).toHaveBeenCalled()

      it 'triggers modal:prev event on channel when prev button is clicked', ->
        eventSpy = sinon.spy()
        channel.on('modal:prev', eventSpy)
        @view.$('button:contains("Back")').click()
        expect(eventSpy).toHaveBeenCalled()
