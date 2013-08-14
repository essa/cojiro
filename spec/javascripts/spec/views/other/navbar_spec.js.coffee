define (require) ->

  NavbarView = require('views/other/navbar')
  I18n = require('i18n')
  globals = require('globals')

  describe "NavbarView", ->

    describe "instantiation", ->
      beforeEach ->
        @view = new NavbarView

      it "creates a navbar", ->
        $el = @view.$el
        expect($el).toBe('div')
        expect($el).toHaveClass('navbar navbar-fixed-top')

    describe "rendering", ->
      beforeEach ->
        @view = new NavbarView

      it "returns the view object", ->
        expect(@view.render()).toEqual(@view)

    describe "Template", ->
      beforeEach ->
        @view = new NavbarView

      sharedExamplesForNavbar = (context) ->

        describe "shared behaviour for navbar", ->
          beforeEach ->
            I18n.locale = context.locale
            @start_a_thread = context.start_a_thread
            @logout = context.logout
            @twitter_sign_in = context.twitter_sign_in

          describe "logged-out user", ->
            beforeEach ->
              globals.currentUser = null
              @$el = @view.render().$el

            it "does not render start a thread link", ->
              expect(@$el).not.toHaveText(new RegExp(@start_a_thread))

            it "does not render a logout link", ->
              expect(@$el).not.toHaveText(new RegExp(@logout))

            it "renders twitter sign-in link", ->
              expect(@$el).toHaveText(new RegExp(@twitter_sign_in))

          describe "logged-in user", ->
            beforeEach ->
              globals.currentUser = @fixtures.User.valid
              @$el = @view.render().$el

            it "renders start a thread link", ->
              expect(@$el).toHaveText(new RegExp(@start_a_thread))

            it "renders logout link", ->
              expect(@$el).toHaveText(new RegExp(@logout))

            it "does not render twitter sign-in link", ->
              expect(@$el).not.toHaveText(new RegExp(@twitter_sign_in))

      describe "English locale", ->
        sharedExamplesForNavbar(
          locale: 'en'
          start_a_thread: "Start a thread"
          logout: "Logout"
          twitter_sign_in: "Sign in through Twitter"
        )

      describe "Japanese locale", ->
        sharedExamplesForNavbar(
          locale: 'ja'
          start_a_thread: "スレッドを立てる"
          logout: "ログアウト"
          twitter_sign_in: "Twitterでサインインする"
        )
