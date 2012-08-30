describe "App.NavbarView", ->
  it "is defined with alias", ->
    expect(App.NavbarView).toBeDefined()
    expect(App.Views.Navbar).toBeDefined()
    expect(App.NavbarView).toEqual(App.Views.Navbar)

  describe "instantiation", ->
    beforeEach ->
      @view = new App.NavbarView()

    it "creates a navbar", ->
      $el = @view.$el
      expect($el).toBe('div')
      expect($el).toHaveClass('navbar navbar-fixed-top')

  describe "rendering", ->
    beforeEach ->
      @view = new App.NavbarView()

    it "returns the view object", ->
      expect(@view.render()).toEqual(@view)

  describe "Template", ->
    beforeEach ->
      @view = new App.NavbarView()

    it "renders the site name", ->
      $el = @view.render().$el
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
            @$el = @view.render().$el

          it "does not render start a thread link", ->
            expect(@$el).not.toHaveText(new RegExp(@startAThread))

          it "does not render a logout link", ->
            expect(@$el).not.toHaveText(new RegExp(@logout))

          it "renders twitter sign-in link", ->
            expect(@$el).toHaveText(new RegExp(@twitterSignIn))

        describe "logged-in user", ->
          beforeEach ->
            App.currentUser = @fixtures.User.valid
            @$el = @view.render().$el

          it "renders start a thread link", ->
            expect(@$el).toHaveText(new RegExp(@startAThread))

          it "renders logout link", ->
            expect(@$el).toHaveText(new RegExp(@logout))

          it "does not render twitter sign-in link", ->
            expect(@$el).not.toHaveText(new RegExp(@twitterSignIn))

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
