define (require) ->

  Thread = require('models/thread')
  StatbarView = require('views/threads/statbar')
  globals = require('globals')

  describe "StatbarView", ->
    beforeEach ->
      @thread = new Thread
      @thread.set
        created_at: new Date("2013", "4", "4", "12", "00").toJSON()
        updated_at: new Date("2013", "5", "5", "12", "00").toJSON()
        user:
          name: "csasaki"
          fullname: "Cojiro Sasaki"
          avatar_mini_url: "http://www.example.com/csasaki_mini.png"
        comments: [
            text: 'comment 1'
            link: url: 'http://www.foo.com'
          ,
            text: 'comment 2'
            link: url: 'http://www.bar.com'
        ]
      @renderSpy = sinon.spy(StatbarView::, 'render')

      # stubs
      @modal = new Backbone.View
      @modal.render = () ->
        @el = document.createElement('div')
        @el.setAttribute('class', 'thread-header-modal')

      # constructors
      @ThreadModal = sinon.stub().returns(@modal)

      # spies
      sinon.spy(@modal, 'render')

      # subject
      @view = new StatbarView(
        model: @thread
        ThreadModal: @ThreadModal
      )

    afterEach -> @renderSpy.restore()

    describe 'initialization', ->

      it 'creates a new ThreadModal view', ->
        expect(@ThreadModal).toHaveBeenCalledOnce()
        expect(@ThreadModal).toHaveBeenCalledWithExactly(model: @thread)

    describe 'rendering', ->

      it 'returns the view', ->
        expect(@view.render()).toEqual(@view)

      it 'renders thread info', ->
        @view.render()
        expect(@view.$el).toBe(".statbar")
        expect(@view.$el).toHaveText(/This thread was started on\s*May 4, 2013 by Cojiro Sasaki/)
        expect(@view.$el).toHaveText(/June 5, 2013\s*last updated/)

      it 'renders user avatar', ->
        @view.render()
        expect(@view.$el).toContain('img[src="http://www.example.com/csasaki_mini.png"]')

      it 'renders number of links', ->
        @view.render()
        expect(@view.$('span.stat')).toHaveText('2')

      it 'does not render thread header modal', ->
        @view.render()
        expect(@modal.render).not.toHaveBeenCalled()

      describe 'logged-in user', ->
        beforeEach -> globals.currentUser = @fixtures.User.valid

        it 'renders edit link', ->
          @view.render()
          expect(@view.$el).toContain('a#thread-edit')

      describe 'logged-out user', ->
        beforeEach -> globals.currentUser = null

        it 'does not render edit link', ->
          @view.render()
          expect(@view.$el).not.toContain('a#thread-edit')

    describe 'events', ->
      describe 'comment added to thread', ->
        it 're-renders the statbar', ->
          @thread.trigger('add:comments')
          expect(@renderSpy).toHaveBeenCalledOnce()
          expect(@renderSpy).toHaveBeenCalledWithExactly()

      describe 'when edit button is clicked', ->
        beforeEach ->
          globals.currentUser = @fixtures.User.valid
          @view.render()
          @eventSpy = sinon.spy()
          @modal.on('show', @eventSpy)

        describe 'logged-in user', ->
          beforeEach ->
            @view.$('a#thread-edit').click()

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
