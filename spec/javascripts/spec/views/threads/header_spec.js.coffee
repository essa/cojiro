define (require) ->

  Backbone = require('backbone')
  Thread = require('models/thread')
  ThreadHeaderView = require('views/threads/header')

  describe 'ThreadHeaderView', ->
    beforeEach ->
      @thread = new Thread
        title: en: 'Geisha bloggers'
        summary: en: 'Looking for info on geisha bloggers.'

      # constructors
      @InPlaceField = require('modules/translatable/in-place-field')

      # spies
      sinon.spy(@, 'InPlaceField')

      # subject
      @view = new ThreadHeaderView(
        model: @thread
        InPlaceField: @InPlaceField
      )

    afterEach -> @InPlaceField.restore()

    describe 'initialization', ->
      it 'creates title and summary uneditable translatable fields', ->
        expect(@InPlaceField).toHaveBeenCalledTwice()
        expect(@InPlaceField).toHaveBeenCalledWith(model: @thread, field: 'title', editable: false)
        expect(@InPlaceField).toHaveBeenCalledWith(model: @thread, field: 'summary', editable: false)

    describe 'rendering', ->
      beforeEach -> @$el = @view.render()

      it 'returns the view', -> expect(@$el).toEqual(@view)
      it 'renders title', -> expect(@view.$('#title')).toContainText('Geisha bloggers')
      it 'renders summary', -> expect(@view.$('#summary')).toContainText('Looking for info on geisha bloggers.')

    describe 'events', ->

      describe 'when thread is updated', ->
        beforeEach ->
          @view.render()

        it 're-renders the title', ->
          @thread.setAttr('title', 'a new title')
          expect(@view.$('#title')).toContainText('a new title')

        it 're-renders the summary', ->
          @thread.setAttr('summary', 'a new summary')
          expect(@view.$('#summary')).toContainText('a new summary')
