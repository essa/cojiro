define (require) ->

  Backbone = require('backbone')
  Thread = require('models/thread')
  Threads = require('collections/threads')

  # make sure dependencies are loaded before stubbing, for unstubbed tests
  ThreadListItemView = require('views/threads/thread-list-item')
  ThreadListView = require('views/threads/thread-list')

  describe "ThreadListView", ->
    beforeEach -> @renderSpy = sinon.spy(ThreadListView::, 'render')
    afterEach -> @renderSpy.restore()

    describe 'with stubbed ThreadListItemView', ->
      beforeEach ->
        # create stub child view
        @listItemView = new Backbone.View()
        @listItemView.render = () ->
          @el = document.createElement('tr')
          @
        @ThreadListItemView = sinon.stub().returns(@listItemView)

      describe "initialization", ->
        beforeEach ->
          @view = new ThreadListView(
            ThreadListItemView: @ThreadListItemView
            collection: new Backbone.Collection)
          @$el = @view.$el

        it "creates a table element for a threads list", ->
          expect(@$el).toBe("table.threads_list")

        it "has bootstrap classes", ->
          expect(@$el).toHaveClass("table")
          expect(@$el).toHaveClass("table-striped")

      describe "rendering", ->
        beforeEach ->
          sinon.spy(@listItemView, "render")
          @thread1 = new Backbone.Model()
          @thread2 = new Backbone.Model()
          @thread3 = new Backbone.Model()
          @view = new ThreadListView(
            ThreadListItemView: @ThreadListItemView
            collection: new Backbone.Collection([ @thread1, @thread2, @thread3 ]))
          @returnVal = @view.render()

        afterEach ->
          @listItemView.render.restore()

        it "returns the view object", ->
          expect(@returnVal).toEqual(@view)

        it "creates a ThreadListItemView for each model", ->
          #expect(ThreadListItemView.alwaysCalledWithNew()).toBeTruthy()
          expect(@ThreadListItemView).toHaveBeenCalledThrice()
          expect(@ThreadListItemView).toHaveBeenCalledWith(model: @thread1)
          expect(@ThreadListItemView).toHaveBeenCalledWith(model: @thread2)
          expect(@ThreadListItemView).toHaveBeenCalledWith(model: @thread3)

        it "renders each ThreadListItemView", ->
          expect(@listItemView.render).toHaveBeenCalledThrice()

        it "appends list items to the list", ->
          expect(@view.$('tbody').children().length).toEqual(3)

        it "has list item views as children (for cleanup)", ->
          expect(@view.children).toBeDefined()
          expect(@view.children.size()).toEqual(3)

      describe 'events', ->
        describe 'thread added to collection', ->
          beforeEach ->
            @collection = new Backbone.Collection
            @view = new ThreadListView(
              ThreadListItemView: @ThreadListItemView
              collection: @collection)

          it 're-renders the thread list', ->
            @collection.trigger('add')
            expect(@renderSpy).toHaveBeenCalledOnce()
            expect(@renderSpy).toHaveBeenCalledWithExactly()

    describe "with actual ThreadListItemView", ->

      describe "dynamic jquery timeago tag", ->
        beforeEach ->
          @clock = sinon.useFakeTimers()
          @thread = new Thread(_(@fixtures.Thread.valid).extend(updated_at: new Date().toJSON()))
          @threads = new Threads([@thread])

          # TODO: figure out why we need this
          # -> something to do with Backbone.Relational
          @thread.collection = @threads

          @view = new ThreadListView(collection: @threads)
          @view.render()

        afterEach ->
          @clock.restore()

        it "fills in time tag field on new models", ->
          expect(@view.$('time.timeago')[0]).toHaveText('less than a minute ago')

        it "updates time tag as time passes", ->
          @clock.tick(60000)
          expect(@view.$('time.timeago')[0]).toHaveText('about a minute ago')
          @clock.tick(3600000)
          expect(@view.$('time.timeago')[0]).toHaveText('about an hour ago')