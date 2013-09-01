define (require) ->

  Backbone = require('backbone')
  FooterView = require('views/other/footer')
  I18n = require('i18n')
  globals = require('globals')

  describe 'FooterView', ->

    describe 'initialization', ->
      beforeEach -> @view = new FooterView

      it 'creates a footer', ->
        $el = @view.$el
        expect($el).toBe('div')
        expect($el).toHaveClass('navbar navbar-fixed-bottom')

    describe 'rendering', ->
      beforeEach -> @view = new FooterView

      it 'returns the view object', ->
        expect(@view.render()).toEqual(@view)

    describe 'template', ->
      beforeEach ->
        @view = new FooterView
        @$el = @view.render().$el

      it 'renders locale-switcher dropdown menu', ->
        expect(@$el).toContain('.dropdown-menu')

      it 'renders each language in I18n.availableLocales in dropdown menu', ->
        @$dropdown = @view.$('.dropdown-menu')
        expect(@$dropdown).toContain('a[lang="en"]:contains("English")')
        expect(@$dropdown).toContain('a[lang="ja"]:contains("日本語")')

    describe 'events', ->
      beforeEach ->
        @router = navigate: ->
        @view = new FooterView(router: @router)
        @view.render()
        
      xit 'jumps to page of dropdown language when selected', ->
        sinon.spy(@router, 'navigate')
        @view.$('a.dropdown-toggle').click()
        @view.$('ul.dropdown-menu').find('[lang="ja"]').click()
        expect(@router, 'navigate').toHaveBeenCalledOnce()
