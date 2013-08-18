define (require) ->

  Thread = require('models/thread')
  StatbarView = require('views/threads/statbar')

  describe "StatbarView", ->
    beforeEach ->
      @thread = new Thread
      @thread.set
        created_at: new Date("2013", "4", "4", "12", "00").toJSON()
        updated_at: new Date("2013", "5", "5", "12", "00").toJSON()
        user:
          name: "csasaki"
          fullname: "Cojiro Sasaki"
          avatar_mini_url: "http://www.example.com/mini_csasaki.png"
        comments: [
            text: 'comment 1'
            link: url: 'http://www.foo.com'
          ,
            text: 'comment 2'
            link: url: 'http://www.bar.com'
        ]
      @renderSpy = sinon.spy(StatbarView::, 'render')
      @view = new StatbarView(model: @thread)

    afterEach -> @renderSpy.restore()

    describe 'rendering', ->

      it 'returns the view', ->
        expect(@view.render()).toEqual(@view)

      it 'renders thread info', ->
        @view.render()
        expect(@view.$el).toBe(".statbar")
        expect(@view.$el).toHaveText(/May 4, 2013\s*started/)
        expect(@view.$el).toHaveText(/June 5, 2013\s*last updated/)

      it 'renders user info', ->
        @view.render()
        expect(@view.$el).toHaveText(/@csasaki/)
        expect(@view.$el).toHaveText(/Cojiro Sasaki/)
        expect(@view.$el).toContain('img[src="http://www.example.com/mini_csasaki.png"]')

      it 'renders number of links', ->
        @view.render()
        expect(@view.$('span.stat')).toHaveText('2')

    describe 'events', ->
      describe 'comment added to thread', ->
        it 're-renders the statbar', ->
          @thread.trigger('add:comments')
          expect(@renderSpy).toHaveBeenCalledOnce()
          expect(@renderSpy).toHaveBeenCalledWithExactly()
