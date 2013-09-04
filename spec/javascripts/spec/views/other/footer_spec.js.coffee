define (require) ->

  Backbone = require('backbone')
  FooterView = require('views/other/footer')
  I18n = require('i18n')
  globals = require('globals')

  describe 'FooterView', ->
    beforeEach ->
      @$sandbox = @createSandbox()
      @$sandbox.append($('<div id="footer" class="navbar navbar-fixed-bottom"></div>'))
      @router = navigate: ->
      @view = new FooterView(router: @router)

    afterEach -> @destroySandbox()

    describe 'initialization', ->

      it 'creates a footer', ->
        $el = @view.$el
        expect($el).toEqual($('#footer'))

      it 'assigns router', -> expect(@view.router).toEqual(@router)

    describe 'rendering', ->

      it 'renders into #footer element', ->
        $('#footer').empty()
        @view.render()
        expect($('#footer')).toContain('.container')

      it 'returns the view object', ->
        expect(@view.render()).toEqual(@view)

      describe 'English locale', ->

        it 'renders "Language" text', ->
          @view.render()
          expect(@view.$('a.dropdown-toggle')).toHaveText('Language')

      describe 'Japanese locale', ->

        it 'renders "Language" text', ->
          I18n.locale = 'ja'
          @view.render()
          expect(@view.$('a.dropdown-toggle')).toHaveText('言語')

    describe 'template', ->
      beforeEach -> @$el = @view.render().$el

      it 'renders locale-switcher dropdown menu', ->
        expect(@$el).toContain('.dropdown-menu')

      it 'renders each language in I18n.availableLocales in dropdown menu', ->
        @$dropdown = @view.$('.dropdown-menu')
        expect(@$dropdown).toContain('a[lang="en"]:contains("English")')
        expect(@$dropdown).toContain('a[lang="ja"]:contains("日本語")')

      it 'adds "disabled" class to current locale in dropdown', ->
        @$dropdown = @view.$('.dropdown-menu')
        expect(@$dropdown.find('[lang="en"]').closest('li')).toHaveClass('disabled')
        expect(@$dropdown.find('[lang="ja"]').closest('li')).not.toHaveClass('disabled')

    describe 'events', ->
      beforeEach ->
        @view.render()
        
      xit 'jumps to page of dropdown language when selected', ->
        sinon.spy(@router, 'navigate')
        @view.$('a.dropdown-toggle').click()
        @view.$('ul.dropdown-menu').find('[lang="ja"]').click()
        expect(@router, 'navigate').toHaveBeenCalledOnce()
