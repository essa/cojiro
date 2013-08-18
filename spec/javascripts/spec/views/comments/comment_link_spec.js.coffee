define (require) ->

  Link = require('models/link')
  Comment = require('models/comment')
  CommentLinkView = require('views/comments/comment_link')
  globals = require('globals')
  I18n = require('i18n')

  describe 'CommentLinkView', ->
    beforeEach ->
      I18n.locale = 'en'
      @link = new Link()
      @link.set
        title: en: "What is CrossFit?"
        summary: en: "CrossFit is an effective way to get fit. Anyone can do it."
        user: 'csasaki'
        site_name: 'www.youtube.com'
        favicon_url: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico'
        source_locale: 'en'
      @comment = new Comment(link: @link)

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

    describe 'rendering', ->
      beforeEach ->
        @view = new CommentLinkView(model: @comment)
        @$el = @view.render().$el

      it 'renders link element', ->
        expect(@$el).toBe(".link")

      it 'renders title', ->
        expect(@$el.find('.title')).toContainText(/What is CrossFit/)

      it 'renders summary', ->
        expect(@$el.find('.summary')).toContainText(/CrossFit is an effective way to get fit. Anyone can do it./)

      it 'renders site name', ->
        expect(@view.$('.site')).toHaveText('www.youtube.com')

      it 'renders favicon', ->
        expect(@$el.find('.favicon')).toContain('img', src: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico' )

    describe 'popover', ->
      beforeEach ->
        @view = new CommentLinkView(model: @comment)

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
          expect(@view.$('.link-inner')).toHaveAttr('data-original-title', 'foo updated 10 hours ago')

      describe 'comment has no text', ->
        it 'assigns comment status message to popover content', ->
          sinon.stub(@comment, 'getStatusMessage').returns('foo updated 10 hours ago')
          @view.render()
          expect(@view.$('.link-inner')).toHaveAttr('data-content', 'foo updated 10 hours ago')

        it 'does not set title', ->
          @view.render()
          expect(@view.$('.link-inner')).toHaveAttr('data-original-title', '')

    describe 'translatable fields', ->
      beforeEach ->
        @view = new CommentLinkView(model: new Comment(link: new Link))

      it 'renders title field', ->
        sinon.spy(@view.titleField, 'render')
        @view.render()
        expect(@view.titleField.render).toHaveBeenCalledOnce()
        expect(@view.titleField.render).toHaveBeenCalledWithExactly()
        @view.titleField.render.restore()

      it 'renders summary field', ->
        sinon.spy(@view.summaryField, 'render')
        @view.render()
        expect(@view.summaryField.render).toHaveBeenCalledOnce()
        expect(@view.summaryField.render).toHaveBeenCalledWithExactly()
        @view.summaryField.render.restore()

      it 'calls leave on titleField when closing', ->
        sinon.spy(@view.titleField, 'leave')
        @view.render()
        @view.leave()
        expect(@view.titleField.leave).toHaveBeenCalledOnce()
        expect(@view.titleField.leave).toHaveBeenCalledWithExactly()
        @view.titleField.leave.restore()

      it 'calls leave on summaryField when closing', ->
        sinon.spy(@view.summaryField, 'leave')
        @view.render()
        @view.leave()
        expect(@view.summaryField.leave).toHaveBeenCalledOnce()
        expect(@view.summaryField.leave).toHaveBeenCalledWithExactly()
        @view.summaryField.leave.restore()
