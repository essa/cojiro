define (require) ->

  Link = require('models/link')
  User = require('models/user')
  Comment = require('models/comment')
  CommentLinkView = require('views/comments/comment-link')
  globals = require('globals')
  I18n = require('i18n')

  describe 'CommentLinkView', ->
    beforeEach ->
      I18n.locale = 'en'
      link = new Link(
        url: 'http://www.example.com'
        title: en: "What is CrossFit?"
        site_name: 'www.youtube.com'
        favicon_url: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico'
        source_locale: 'en')
      user = new User(@fixtures.User.valid)
      @comment = new Comment(link: link, user: user)

      # stub subclass
      @commentLinkContentView = new Backbone.View()
      @commentLinkContentView.render = () ->
        @el = $('<a class="description"></a>')
        @
      @CommentLinkContentView = sinon.stub().returns(@commentLinkContentView)

    afterEach ->
      I18n.locale = I18n.defaultLocale

    describe 'initialization', ->
      it 'throws no error if passed in comment with link as model', ->
        comment = @comment
        expect(-> new CommentLinkView(model: comment)).not.toThrow()

      it 'throws error if not passed comment as model', ->
        expect(-> new CommentLinkView()).toThrow('model required in CommentLinkView')

      it 'throws error if passed comment without link as model', ->
        expect(-> new CommentLinkView(model: new Comment)).toThrow('comment must have a link to render a CommentLinkView')

    describe 'with stubbed CommentLinkContentView', ->
      beforeEach ->
        @destroyPopoverSpy = sinon.spy(CommentLinkView::, 'destroyPopover')
        @renderPopoverSpy = sinon.spy(CommentLinkView::, 'renderPopover')
        @view = new CommentLinkView(
          model: @comment
          CommentLinkContentView: @CommentLinkContentView)

      afterEach ->
        @destroyPopoverSpy.restore()
        @renderPopoverSpy.restore()

      describe 'rendering', ->
        beforeEach -> @$el = @view.render().$el

        it 'renders link element', ->
          expect(@$el).toBe(".link")

        it 'renders content', ->
          expect(@$el).toContain('a.description')

        it 'renders original link with target="_blank" attribute', ->
          expect(@$el).toContain('a', href: 'http://www.example.com')
          expect(@view.$('a[href="http://www.example.com"]')).toHaveAttr('target', '_blank')

        it 'renders site name', ->
          expect(@view.$('.site')).toHaveText('www.youtube.com')

        it 'renders favicon', ->
          expect(@$el.find('.favicon')).toContain('img', src: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico' )

        it 'renders source locale', ->
          expect(@$el.find('.lang')).toHaveText('(en)')

      describe 'popover', ->

        it 'assigns popover to data-toggle attribute on .link-inner element', ->
          @view.render()
          expect(@view.$('.link-inner')).toHaveAttr('data-toggle', 'popover')

      describe 'events', ->

        describe 'when user mouseovers link', ->
          beforeEach -> @$sandbox = @createSandbox()
          afterEach -> @destroySandbox()

          it 'renders popover', ->
            @view.render()
            @$sandbox.html(@view.el)
            expect($('.popover')).not.toBeVisible()
            $('.link-inner').trigger('mouseover')
            expect($('.popover')).toBeVisible()

          describe 'comment has text', ->
            beforeEach ->
              @comment.set(text: en: 'a comment text')
              @view.render()
              @$sandbox.html(@view.el)
              $('.link-inner').trigger('mouseover')

            it 'assigns comment status message to popover title', ->
              expect($('.popover .popover-title')).toHaveText('@csasaki added less than a minute ago')

            it 'renders avatar pic into popover title', ->
              expect($('.popover .popover-title')).toContain('img[src="http://www.example.com/csasaki_mini.png"]')

            it 'assigns comment text to popover content', ->
              expect($('.popover .popover-content')).toHaveText(/a comment text/)

          describe 'comment has no text', ->
            beforeEach ->
              @view.render()
              @$sandbox.html(@view.el)
              $('.link-inner').trigger('mouseover')

            it 'assigns comment status message to popover content', ->
              expect($('.popover .popover-content')).toHaveText('@csasaki added less than a minute ago')

            it 'renders avatar pic into popover content', ->
              expect($('.popover .popover-content')).toContain('img[src="http://www.example.com/csasaki_mini.png"]')

            it 'does not set title', ->
              expect($('.popover')).not.toContain('.popover .popover-title')

        describe 'when content view is opened', ->
          beforeEach -> @view.render()

          it 'calls destroyPopover()', ->
            @view.contentView.trigger('open')
            expect(@destroyPopoverSpy).toHaveBeenCalledOnce()
            expect(@destroyPopoverSpy).toHaveBeenCalledWithExactly()

        describe 'when content view is closed', ->
          beforeEach -> @view.render()

          it 'calls renderPopover()', ->
            @renderPopoverSpy.reset()
            @view.contentView.trigger('close')
            expect(@renderPopoverSpy).toHaveBeenCalledOnce()
            expect(@renderPopoverSpy).toHaveBeenCalledWithExactly()
