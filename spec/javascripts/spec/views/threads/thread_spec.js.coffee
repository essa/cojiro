define (require) ->

  Thread = require('models/thread')
  Link = require('models/link')
  ThreadView = require('views/threads/thread')
  globals = require('globals')
  I18n = require('i18n')

  describe "ThreadView", ->
    beforeEach ->
      I18n.locale = 'en'
      @thread = new Thread()
      @thread.set
        created_at: new Date("2013", "4", "4", "12", "00").toJSON()
        updated_at: new Date("2013", "5", "5", "12", "00").toJSON()
        title:
          en: "Geisha bloggers"
        summary:
          en: "Looking for info on geisha bloggers."
        user:
          name: "csasaki"
          fullname: "Cojiro Sasaki"
          avatar_mini_url: "http://www.example.com/mini_csasaki.png"
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
      I18n.locale = I18n.defaultLocale

    describe "rendering", ->
      it "renders the thread", ->
        @view = new ThreadView(model: @thread)
        $el = @view.render().$el
        expect($el).toBe(".thread")
        expect($el).toHaveText(/Geisha bloggers/)
        expect($el).toHaveText(/Looking for info on geisha bloggers./)
        expect($el).toHaveText(/May 4, 2013\s*started/)
        expect($el).toHaveText(/June 5, 2013\s*last updated/)

      it "renders user info", ->
        @view = new ThreadView(model: @thread)
        $el = @view.render().$el
        expect($el).toHaveText(/@csasaki/)
        expect($el).toHaveText(/Cojiro Sasaki/)
        expect($el).toContain('img[src="http://www.example.com/mini_csasaki.png"]')

      describe 'link info', ->
        beforeEach ->
          @view = new ThreadView(model: @thread)

        it 'renders url', ->
          $el = @view.render().$el
          expect($el).toContain('.url a[href="http://www.foo.com"]')
          expect($el).toContain('.url a[href="http://www.bar.com"]')

        it 'renders provider url', ->
          $el = @view.render().$el
          sites = $el.find('.site')
          expect($(sites[0])).toHaveText('www.foo.com')
          expect($(sites[1])).toHaveText('www.bar.com')

        it 'renders title', ->
          $el = @view.render().$el
          links = $el.find('.link')
          expect($(links[0])).toContainText('A link about foo')
          expect($(links[1])).toContainText('A link about bar')


      describe "logged-in user", ->
        beforeEach ->
          globals.currentUser = @fixtures.User.valid
          @view = new ThreadView(model: @thread)

        it 'makes in-place-fields editable', ->
          $el = @view.render().$el
          expect($el.find(':contains("A link about foo")')).toHaveClass('editable')
          expect($el.find(':contains("A summary about foo")')).toHaveClass('editable')
          expect($el.find(':contains("A link about bar")')).toHaveClass('editable')
          expect($el.find(':contains("A summary about bar")')).toHaveClass('editable')

        it 'renders add link button', ->
          $el = @view.render().$el
          expect($el).toContain('a.add-link:contains("Add a link")')

      describe "logged-out user", ->
        beforeEach ->
          globals.currentUser = null
          @view = new ThreadView(model: @thread)

        it 'does not render edit/add buttons', ->
          $el = @view.render().$el
          expect($el).not.toContain('button.edit-button:contains("Edit")')

        it 'does not render add link button', ->
          $el = @view.render().$el
          expect($el).not.toContain('a.add-link:contains("Add a link")')

    describe 'translatable fields', ->
      beforeEach ->
        @view = new ThreadView(model: @thread)

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
          $('body').append('<div id="sandbox"></div>')
          $('#sandbox').append('<div id="modal"></div>')

          globals.currentUser = @fixtures.User.valid
          @view = new ThreadView(model: @thread)
          $('#modal').hide()
          @view.render()
          $('#sandbox').append(@view.el)

        afterEach ->
          $('#sandbox').remove()
          $('body').removeClass()
          $('body .modal-backdrop').remove()

        it 'creates addLinkModal with a new link model', ->
          expect(@view.addLinkModal.model).toBeDefined()
          expect(@view.addLinkModal.model instanceof Link).toBeTruthy()

        it "shows addLinkModal when user clicks on the 'add link' button", ->
          # ensure that modal is initially hidden -- bootstrap will do this
          expect($('#modal')).not.toBeVisible()
          $('a.add-link').trigger('click')
          expect($('#modal')).toBeVisible()

      describe 'leave', ->
        beforeEach -> @view = new ThreadView(model: @thread)

        it 'calls leave when leaving the thread', ->
          sinon.spy(@view.addLinkModal, 'leave')
          @view.render()
          @view.leave()
          expect(@view.addLinkModal.leave).toHaveBeenCalledOnce()
          expect(@view.addLinkModal.leave).toHaveBeenCalledWithExactly()
          @view.addLinkModal.leave.restore()
