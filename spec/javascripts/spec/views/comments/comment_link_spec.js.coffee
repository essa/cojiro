define (require) ->

  Link = require('models/link')
  User = require('models/user')
  Comment = require('models/comment')
  CommentLinkView = require('views/comments/comment_link')
  globals = require('globals')
  I18n = require('i18n')

  describe 'CommentLinkView', ->
    beforeEach ->
      I18n.locale = 'en'
      link = new Link(
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
      describe 'rendering', ->
        beforeEach ->
          @view = new CommentLinkView(
            model: @comment
            CommentLinkContentView: @CommentLinkContentView)
          @$el = @view.render().$el

        it 'renders link element', ->
          expect(@$el).toBe(".link")

        it 'renders content', ->
          expect(@$el).toContain('a.description')

        it 'renders site name', ->
          expect(@view.$('.site')).toHaveText('www.youtube.com')

        it 'renders favicon', ->
          expect(@$el.find('.favicon')).toContain('img', src: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico' )

      describe 'popover', ->
        beforeEach ->
          @destroyPopoverSpy = sinon.spy(CommentLinkView::, 'destroyPopover')
          @renderPopoverSpy = sinon.spy(CommentLinkView::, 'renderPopover')
          @view = new CommentLinkView(
            model: @comment
            CommentLinkContentView: @CommentLinkContentView
          )

        afterEach ->
          @destroyPopoverSpy.restore()
          @renderPopoverSpy.restore()

        it 'assigns popover to data-toggle attribute on .link-inner element', ->
          @view.render()
          expect(@view.$('.link-inner')).toHaveAttr('data-toggle', 'popover')

        describe 'comment has text', ->
          beforeEach ->
            @comment.set(text: en: 'a comment text')

          it 'assigns comment text to popover content', ->
            @view.render()
            expect(@view.$('.link-inner')).toHaveAttr('data-content', 'a comment text')

          it 'assigns comment status message to popover title', ->
            sinon.stub(@comment, 'getStatusMessage').returns('foo updated 10 hours ago')
            @view.render()
            title = $(@view.$('.link-inner').data('original-title'))
            expect(title).toHaveText('foo updated 10 hours ago')

          it 'renders avatar pic into popover title', ->
            sinon.stub(@comment, 'getStatusMessage').returns('foo updated 10 hours ago')
            @view.render()
            title = $(@view.$('.link-inner').data('original-title'))
            expect(title).toContain('img[src="http://www.example.com/csasaki_mini.png"]')

        describe 'comment has no text', ->
          it 'assigns comment status message to popover content', ->
            sinon.stub(@comment, 'getStatusMessage').returns('foo updated 10 hours ago')
            @view.render()
            content = $(@view.$('.link-inner').data('content'))
            expect(content).toHaveText('foo updated 10 hours ago')

          it 'renders avatar pic into popover content', ->
            sinon.stub(@comment, 'getStatusMessage').returns('foo updated 10 hours ago')
            @view.render()
            content = $(@view.$('.link-inner').data('content'))
            expect(content).toContain('img[src="http://www.example.com/csasaki_mini.png"]')

          it 'does not set title', ->
            @view.render()
            expect(@view.$('.link-inner')).toHaveAttr('data-original-title', '')

        describe 'events', ->
          beforeEach -> @view.render()

          # TODO: actually check that popover is being rendered
          # in each case. for some reason this wasn't working
          # so just checking that methods are being called.
          describe 'when user mouseovers link', ->
            it 'renders popover'

          describe 'when content view is opened', ->
            it 'calls destroyPopover()', ->
              @view.contentView.trigger('open')
              expect(@destroyPopoverSpy).toHaveBeenCalledOnce()
              expect(@destroyPopoverSpy).toHaveBeenCalledWithExactly()

          describe 'when content view is closed', ->
            it 'calls renderPopover()', ->
              @renderPopoverSpy.reset()
              @view.contentView.trigger('close')
              expect(@renderPopoverSpy).toHaveBeenCalledOnce()
              expect(@renderPopoverSpy).toHaveBeenCalledWithExactly()
