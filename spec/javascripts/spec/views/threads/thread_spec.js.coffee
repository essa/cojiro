define (require) ->
  Backbone = require('backbone')

  Thread = require('models/thread')
  Link = require('models/link')
  ThreadView = require('views/threads/thread')
  globals = require('globals')
  I18n = require('i18n')

  describe 'ThreadView', ->
    beforeEach ->
      @$sandbox = @createSandbox()
      @thread = new Thread
      @thread.set
        comments: [
            text: 'comment 1'
            link:
              url: 'http://www.foo.com'
              title: en: 'A link about foo'
              summary: en: 'A summary about foo'
              site_name: 'www.foo.com'
          ,
            text: 'comment 2'
            link:
              url: 'http://www.bar.com'
              title: en: 'A link about bar'
              summary: en: 'A summary about bar'
              site_name: 'www.bar.com'
        ]

    afterEach -> @destroySandbox()

    describe 'when isolated from dependencies', ->
      beforeEach ->

        # stubs
        @statbarView = new Backbone.View
        @statbarView.render = () ->
          @el = document.createElement('div')
          @el.setAttribute('class', 'statbar')

        @threadHeaderView = new Backbone.View
        @threadHeaderView.render = () ->
          @el = document.createElement('div')
          @el.setAttribute('class', 'thread-header')

        # constructors
        @StatbarView = sinon.stub().returns(@statbarView)
        @ThreadHeaderView = sinon.stub().returns(@threadHeaderView)

        # spies
        sinon.spy(@statbarView, 'render')

        # subject
        @view = new ThreadView(
          model: @thread
          StatbarView: @StatbarView
          ThreadHeaderView: @ThreadHeaderView
        )

      describe 'rendering', ->
        beforeEach -> globals.currentUser = null

        it 'renders the thread', ->
          @view.render()
          expect(@view.$el).toBe(".thread")

        describe 'thread header', ->

          it 'renders the thread header', ->
            @view.render()
            expect(@ThreadHeaderView).toHaveBeenCalledOnce()
            expect(@ThreadHeaderView).toHaveBeenCalledWithExactly(model: @thread)

          it 'inserts thread header into the view', ->
            @view.render()
            expect(@view.$('#thread-header')).toContain('div.thread-header')

        describe 'statbar', ->
          beforeEach -> @view.render()

          it 'creates a StatbarView', ->
            expect(@StatbarView).toHaveBeenCalledOnce()
            expect(@StatbarView).toHaveBeenCalledWithExactly(model: @thread)

          it 'renders newly-created StatbarView', ->
            expect(@statbarView.render).toHaveBeenCalledOnce()
            expect(@statbarView.render).toHaveBeenCalledWithExactly()

          it 'inserts statbar html into #statbar element', ->
            expect(@view.$('#statbar')).toContain('div.statbar')

        describe 'links', ->
          beforeEach ->
            @view.render()
            @fooSelector = '.url a[href="http://www.foo.com"]'
            @barSelector = '.url a[href="http://www.bar.com"]'

          it 'renders url', ->
            expect(@view.$el).toContain(@fooSelector)
            expect(@view.$el).toContain(@barSelector)

          it 'renders provider url', ->
            expect(@view.$("#{@fooSelector} .site")).toHaveText('www.foo.com')
            expect(@view.$("#{@barSelector} .site")).toHaveText('www.bar.com')

          it 'renders title', ->
            expect(@view.$(@fooSelector).closest('.link'))
              .toContainText('A link about foo')
            expect(@view.$(@barSelector).closest('.link'))
              .toContainText('A link about bar')

          it 'orders links with most recently added first', ->
            links = @view.$('.link-list .link')
            expect($(links[0])).toContain('a[href="http://www.bar.com"]')
            expect($(links[0])).not.toContain('a[href="http://www.foo.com"]')
            expect($(links[1])).toContain('a[href="http://www.foo.com"]')
            expect($(links[1])).not.toContain('a[href="http://www.bar.com"]')

        describe "logged-in user", ->
          beforeEach ->
            globals.currentUser = @fixtures.User.valid
            @view.render()

          it 'makes in-place-fields editable', ->
            expect(@view.$(':contains("A link about foo")')).toHaveClass('editable')
            expect(@view.$(':contains("A summary about foo")')).toHaveClass('editable')
            expect(@view.$(':contains("A link about bar")')).toHaveClass('editable')
            expect(@view.$(':contains("A summary about bar")')).toHaveClass('editable')

          it 'renders add link button', ->
            expect(@view.$el).toContain('a.add-link:contains("Add a link")')

        describe "logged-out user", ->
          beforeEach ->
            globals.currentUser = null
            @view.render()

          it 'does not render edit/add buttons', ->
            expect(@view.$el).not.toContain('button.edit-button:contains("Edit")')

          it 'does not render add link button', ->
            expect(@view.$el).not.toContain('a.add-link:contains("Add a link")')

      describe 'events', ->
        describe 'comment added to thread', ->
          beforeEach -> @view.render()

          it 're-renders links', ->
            @view.$('.link-list').empty()
            @thread.trigger('add:comments')
            expect(@view.$('.link-list')).toContain('.url a[href="http://www.foo.com"]')
            expect(@view.$('.link-list')).toContain('.url a[href="http://www.bar.com"]')

          it 'empties link list container', ->
            @thread.trigger('add:comments')
            expect(@view.$('.url a[href="http://www.foo.com"]').length).toEqual(1)
            expect(@view.$('.url a[href="http://www.bar.com"]').length).toEqual(1)

      describe "add a link modal", ->
        beforeEach -> globals.currentUser = @fixtures.User.valid

        describe 'click add link button', ->
          beforeEach ->
            $('#modal').hide()
            @view.render()
            @$sandbox.append(@view.el)

          it 'creates addLinkModal with a new link model', ->
            @view.$('a.add-link').click()
            expect(@view.addLinkModal.link).toBeDefined()
            expect(@view.addLinkModal.link instanceof Link).toBeTruthy()

          it "shows addLinkModal when user clicks on the 'add link' button", ->
            # ensure that modal is initially hidden -- bootstrap will do this
            expect($('#modal')).not.toBeVisible()
            $('a.add-link').trigger('click')
            expect($('#modal')).toBeVisible()

        describe 'leave', ->
          it 'calls leave when leaving the thread', ->
            @view.render()
            @$sandbox.append(@view.el)
            sinon.spy(@view.addLinkModal, 'leave')
            $('a.add-link').trigger('click')
            @view.leave()
            expect(@view.addLinkModal.leave).toHaveBeenCalledOnce()
            expect(@view.addLinkModal.leave).toHaveBeenCalledWithExactly()
            @view.addLinkModal.leave.restore()
