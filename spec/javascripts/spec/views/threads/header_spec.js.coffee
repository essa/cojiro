define (require) ->

  Backbone = require('backbone')
  Thread = require('models/thread')
  ThreadHeaderView = require('views/threads/header')
  globals = require('globals')

  describe 'ThreadHeaderView', ->
    beforeEach ->
      @thread = new Thread
        title: en: 'Geisha bloggers'
        summary: en: 'Looking for info on geisha bloggers.'

      # stubs
      @modal = new Backbone.View
      @modal.render = () ->
        @el = document.createElement('div')
        @el.setAttribute('class', 'thread-header-modal')

      # constructors
      @ThreadHeaderModal = sinon.stub().returns(@modal)
      @InPlaceField = require('modules/translatable/in-place-field')

      # spies
      sinon.spy(@modal, 'render')
      sinon.spy(@, 'InPlaceField')

      # subject
      @view = new ThreadHeaderView(
        model: @thread
        ThreadHeaderModal: @ThreadHeaderModal
        InPlaceField: @InPlaceField
      )

    afterEach -> @InPlaceField.restore()

    describe 'initialization', ->
      it 'creates a new ThreadHeaderModal view', ->
        expect(@ThreadHeaderModal).toHaveBeenCalledOnce()
        expect(@ThreadHeaderModal).toHaveBeenCalledWithExactly(model: @thread)

      it 'creates title and summary uneditable translatable fields', ->
        expect(@InPlaceField).toHaveBeenCalledTwice()
        expect(@InPlaceField).toHaveBeenCalledWith(model: @thread, field: 'title', editable: false)
        expect(@InPlaceField).toHaveBeenCalledWith(model: @thread, field: 'summary', editable: false)

    describe 'rendering', ->
      beforeEach -> @$el = @view.render()

      it 'returns the view', -> expect(@$el).toEqual(@view)
      it 'renders title', -> expect(@view.$('#title')).toContainText('Geisha bloggers')
      it 'renders summary', -> expect(@view.$('#summary')).toContainText('Looking for info on geisha bloggers.')
      it 'does not render thread header modal', ->
        expect(@modal.render).not.toHaveBeenCalled()

    describe 'events', ->

      describe 'when thread header is clicked', ->
        beforeEach ->
          @view.render()
          @eventSpy = sinon.spy()
          @modal.on('show', @eventSpy)

        describe 'logged-in user', ->
          beforeEach ->
            globals.currentUser = @fixtures.User.valid
            @view.$el.click()

          it 'triggers "show" event on header modal', ->
            expect(@eventSpy).toHaveBeenCalled()

          it 'renders thread header modal', ->
            expect(@modal.render).toHaveBeenCalledOnce()
            expect(@modal.render).toHaveBeenCalledWithExactly()

        describe 'logged-out user', ->
          beforeEach ->
            globals.currentUser = null
            @view.$el.click()

          it 'does not trigger "show" event on modal', ->
            expect(@eventSpy).not.toHaveBeenCalled()

          it 'does not render thread header modal', ->
            expect(@modal.render).not.toHaveBeenCalled()
