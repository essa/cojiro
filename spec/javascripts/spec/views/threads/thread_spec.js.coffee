define (require) ->

  Thread = require('models/thread')
  ThreadView = require('views/threads/thread')
  globals = require('globals')
  I18n = require('i18n')

  describe "ThreadView", ->
    beforeEach ->
      I18n.locale = 'en'
      @thread = new Thread()
      @thread.set
        title:
          en: "Geisha bloggers"
        summary:
          en: "Looking for info on geisha bloggers."
        user:
          name: "csasaki"
          fullname: "Cojiro Sasaki"
          avatar_mini_url: "http://www.example.com/mini_csasaki.png"

    afterEach ->
      I18n.locale = I18n.defaultLocale

    describe "rendering", ->
      it "renders the thread", ->
        @view = new ThreadView(model: @thread)
        $el = @view.render().$el
        expect($el).toBe("#thread")
        expect($el).toHaveText(/Geisha bloggers/)
        expect($el).toHaveText(/Looking for info on geisha bloggers./)

      it "renders user info", ->
        @view = new ThreadView(model: @thread)
        $el = @view.render().$el
        expect($el).toHaveText(/@csasaki/)
        expect($el).toHaveText(/Cojiro Sasaki/)
        expect($el).toContain('img[src="http://www.example.com/mini_csasaki.png"]')

      describe "logged-in user", ->
        beforeEach ->
          globals.currentUser = @fixtures.User.valid
          @view = new ThreadView(model: @thread)

        it 'renders edit/add buttons', ->
          $el = @view.render().$el
          expect($el).toContain('button.edit-button:contains("Edit")')

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

    describe "add a link modal", ->
      beforeEach ->
        globals.currentUser = @fixtures.User.valid
        @view = new ThreadView(model: @thread)
        $('body').append(@view.render().el)
        $('#add-link-modal').hide()

      it "calls showAd when user clicks on the 'add link' button", ->
        # ensure that modal is initially hidden -- bootstrap will do this
        expect($('.modal')).not.toBeVisible()
        $('a.add-link').trigger('click')
        expect($('.modal')).toBeVisible()
