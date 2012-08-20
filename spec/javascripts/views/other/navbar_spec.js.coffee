describe "App.NavbarView", ->
  it "is defined with alias", ->
    expect(App.NavbarView).toBeDefined()
    expect(App.Views.Navbar).toBeDefined()
    expect(App.NavbarView).toEqual(App.Views.Navbar)

  describe "rendering", ->
    beforeEach ->
      @navbarView = new App.NavbarView()

    it "returns the view object", ->
      expect(@navbarView.render()).toEqual(@navbarView)

    it "renders the navbar", ->
      $el = $(@navbarView.render().el)
      expect($el).toBe(".navbar")
      expect($el).toHaveText(/cojiro/)

    sharedExamplesForNavbar = (context) ->

      describe "shared behaviour for navbar", ->
        beforeEach ->
          I18n.locale = context.locale
          @startAThread = context.startAThread
          @logout = context.logout
          @twitterSignIn = context.twitterSignIn

        describe "logged-out user", ->
          beforeEach ->
            App.currentUser = null
            @$el = @navbarView.render().$el

          it "does not render start a thread link", ->
            expect(@$el).not.toHaveText(new RegExp(@startAThread, "g"))

          it "does not render a logout link", ->
            expect(@$el).not.toHaveText(new RegExp(@logout, "g"))

          it "renders twitter sign-in link", ->
            expect(@$el).toHaveText(new RegExp(@twitterSignIn, "g"))

        describe "logged-in user", ->
          beforeEach ->
            App.currentUser = @fixtures.User.valid
            @$el = @navbarView.render().$el

          it "renders start a thread link", ->
            expect(@$el).toHaveText(new RegExp(@startAThread, "g"))

          it "renders logout link", ->
            expect(@$el).toHaveText(new RegExp(@logout, "g"))

          it "does not render twitter sign-in link", ->
            expect(@$el).not.toHaveText(new RegExp(@twitterSignIn, "g"))

    describe "English locale", ->
      sharedExamplesForNavbar(
        locale: 'en'
        startAThread: "Start a thread"
        logout: "Logout"
        twitterSignIn: "Sign in through Twitter"
      )

    describe "Japanese locale", ->
      sharedExamplesForNavbar(
        locale: 'ja'
        startAThread: "スレッドを立てる"
        logout: "ログアウト"
        twitterSignIn: "Twitterでサインインする"
      )
