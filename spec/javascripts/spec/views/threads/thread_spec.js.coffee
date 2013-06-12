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
          ,
            text: 'comment 2'
            link:
              url: 'http://www.bar.com'
        ]

    afterEach ->
      I18n.locale = I18n.defaultLocale

    describe "rendering", ->
      it "renders the thread", ->
        @view = new ThreadView(model: @thread)
        $el = @view.render().$el
        expect($el).toBe("#thread")
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

      it 'renders link info', ->
        @view = new ThreadView(model: @thread)
        $el = @view.render().$el
        expect($el).toContain('a.link[href="http://www.foo.com"]')
        expect($el).toContain('a.link[href="http://www.bar.com"]')

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
        sandbox = document.createElement('div')
        sandbox.setAttribute('id', 'sandbox')
        $('body').append(sandbox)
        globals.currentUser = @fixtures.User.valid
        @view = new ThreadView(model: @thread)
        $('#sandbox').append(@view.render().el)
        $('#add-link-modal').hide()

      afterEach ->
        $('#sandbox').remove()
        $('body').removeClass()

      it 'creates showAddLinkModal with a new link model', ->
        expect(@view.addLinkModalView.model).toBeDefined()
        expect(@view.addLinkModalView.model instanceof Link).toBeTruthy()

      it "calls showAddLinkModel when user clicks on the 'add link' button", ->
        # ensure that modal is initially hidden -- bootstrap will do this
        expect($('.modal')).not.toBeVisible()
        $('a.add-link').trigger('click')
        expect($('.modal')).toBeVisible()
