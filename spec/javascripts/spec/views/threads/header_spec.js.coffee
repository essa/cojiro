define (require) ->

  Backbone = require('backbone')
  Thread = require('models/thread')
  ThreadHeaderView = require('views/threads/header')

  describe 'ThreadHeaderView', ->
    beforeEach ->
      @thread = new Thread
        title:
          en: 'Geisha bloggers'
        summary:
          en: 'Looking for info on geisha bloggers.'

      # stubs
      @threadHeaderModal = new Backbone.View
      @threadHeaderModal.render = () ->
        @el = document.createElement('div')
        @el.setAttribute('class', 'thread-header-modal')

      # constructors
      @ThreadHeaderModal = sinon.stub().returns(@threadHeaderModal)
      @InPlaceField = require('modules/translatable/in-place-field')

      # spies
      sinon.spy(@threadHeaderModal, 'render')
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
      beforeEach ->
        @$el = @view.render()
      it 'returns the view', -> expect(@$el).toEqual(@view)
      it 'renders title', -> expect(@view.$('#title')).toContainText('Geisha bloggers')
      it 'renders summary', -> expect(@view.$('#summary')).toContainText('Looking for info on geisha bloggers.')
      it 'renders thread header modal', ->
        expect(@threadHeaderModal.render).toHaveBeenCalledOnce()
        expect(@threadHeaderModal.render).toHaveBeenCalledWithExactly()
