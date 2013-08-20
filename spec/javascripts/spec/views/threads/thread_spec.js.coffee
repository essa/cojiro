define (require) ->
  Backbone = require('backbone')

  Thread = require('models/thread')
  Link = require('models/link')
  ThreadView = require('views/threads/thread')
  globals = require('globals')
  I18n = require('i18n')

  describe "ThreadView", ->
    beforeEach ->
      $('body').append('<div id="sandbox"></div>')
      $('#sandbox').append('<div id="modal"></div>')
      @thread = new Thread
      @thread.set
        title: en: "Geisha bloggers"
        summary: en: "Looking for info on geisha bloggers."
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

    afterEach ->
      $('#sandbox').remove()
      $('body .modal-backdrop').remove()

    describe 'with stubbed StatbarView', ->
      beforeEach ->
        # create stub child view
        @statbarView = new Backbone.View
        @statbarView.render = () ->
          @el = document.createElement('div')
          @el.setAttribute('class', 'statbar')
          @
        @StatbarView = sinon.stub().returns(@statbarView)
        sinon.spy(@statbarView, 'render')
        @view = new ThreadView(model: @thread, StatbarView: @StatbarView)

      describe "rendering", ->
        beforeEach -> globals.currentUser = null

        it 'renders the thread', ->
          @view.render()
          expect(@view.$el).toBe(".thread")
          expect(@view.$el).toHaveText(/Geisha bloggers/)
          expect(@view.$el).toHaveText(/Looking for info on geisha bloggers./)

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

      describe 'translatable fields', ->

        it 'renders title field', ->
          sinon.spy(@view.titleField, 'render')
          @view.render()
          expect(@view.titleField.render).toHaveBeenCalledOnce()
          expect(@view.titleField.render).toHaveBeenCalledWithExactly()
          @view.titleField.render.restore()

        it 'renders summary field', ->
          sinon.spy(@view.summaryField, 'render')
          @view.render()
          expect(@view.summaryField.render).toHaveBeenCalledOnce()
          expect(@view.summaryField.render).toHaveBeenCalledWithExactly()
          @view.summaryField.render.restore()

        it 'calls leave on titleField when closing', ->
          sinon.spy(@view.titleField, 'leave')
          @view.render()
          @view.leave()
          expect(@view.titleField.leave).toHaveBeenCalledOnce()
          expect(@view.titleField.leave).toHaveBeenCalledWithExactly()
          @view.titleField.leave.restore()

        it 'calls leave on summaryField when closing', ->
          sinon.spy(@view.summaryField, 'leave')
          @view.render()
          @view.leave()
          expect(@view.summaryField.leave).toHaveBeenCalledOnce()
          expect(@view.summaryField.leave).toHaveBeenCalledWithExactly()
          @view.summaryField.leave.restore()

      describe "add a link modal", ->

        describe 'click add link button', ->
          beforeEach ->
            globals.currentUser = @fixtures.User.valid
            $('#modal').hide()
            @view.render()
            $('#sandbox').append(@view.el)

          it 'creates addLinkModal with a new link model', ->
            expect(@view.addLinkModal.link).toBeDefined()
            expect(@view.addLinkModal.link instanceof Link).toBeTruthy()

          it "shows addLinkModal when user clicks on the 'add link' button", ->
            # ensure that modal is initially hidden -- bootstrap will do this
            expect($('#modal')).not.toBeVisible()
            $('a.add-link').trigger('click')
            expect($('#modal')).toBeVisible()

        describe 'leave', ->
          it 'calls leave when leaving the thread', ->
            sinon.spy(@view.addLinkModal, 'leave')
            @view.render()
            @view.leave()
            expect(@view.addLinkModal.leave).toHaveBeenCalledOnce()
            expect(@view.addLinkModal.leave).toHaveBeenCalledWithExactly()
            @view.addLinkModal.leave.restore()
