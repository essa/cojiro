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
        expect($('#footer')).toContain('.navbar-inner')

      it 'returns the view object', ->
        expect(@view.render()).toEqual(@view)

    describe 'template', ->
      beforeEach -> @$el = @view.render().$el

      it 'renders locale-switcher dropdown menu', ->
        expect(@$el).toContain('.dropdown-menu')

      it 'renders each language in I18n.availableLocales in dropdown menu', ->
        @$dropdown = @view.$('.dropdown-menu')
        expect(@$dropdown).toContain('a[lang="en"]:contains("English")')
        expect(@$dropdown).toContain('a[lang="ja"]:contains("日本語")')

    describe 'events', ->
      beforeEach ->
        @view.render()
        
      xit 'jumps to page of dropdown language when selected', ->
        sinon.spy(@router, 'navigate')
        @view.$('a.dropdown-toggle').click()
        @view.$('ul.dropdown-menu').find('[lang="ja"]').click()
        expect(@router, 'navigate').toHaveBeenCalledOnce()
