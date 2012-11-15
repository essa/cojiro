define (require) ->

  Thread = require('models/thread')
  ThreadView = require('views/threads/thread')
  globals = require('globals')

  describe "ThreadView", ->

    describe "rendering", ->
      beforeEach ->
        thread = new Thread()
        thread.set
          title: "Geisha bloggers",
          summary: "Looking for info on geisha bloggers."
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
            avatar_mini_url: "http://www.example.com/mini_csasaki.png"
        @view = new ThreadView(model: thread)

      it "renders the thread", ->
        $el = @view.render().$el
        expect($el).toBe("#thread")
        expect($el).toHaveText(/Geisha bloggers/)
        expect($el).toHaveText(/Looking for info on geisha bloggers./)

      it "renders user info", ->
        $el = @view.render().$el
        expect($el).toHaveText(/@csasaki/)
        expect($el).toHaveText(/Cojiro Sasaki/)
        expect($el).toContain('img[src="http://www.example.com/mini_csasaki.png"]')

      describe "logged-in user", ->
        beforeEach ->
          globals.currentUser = @fixtures.User.valid

        it 'renders edit/add buttons', ->
          $el = @view.render().$el
          expect($el).toContain('button.edit-button:contains("Edit")')

      describe "logged-out user", ->
        beforeEach ->
          globals.currentUser = null

        it 'does not render edit/add buttons', ->
          $el = @view.render().$el
          expect($el).not.toContain('button.edit-button:contains("Edit")')
