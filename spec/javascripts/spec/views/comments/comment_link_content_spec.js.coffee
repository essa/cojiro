define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  User = require('models/user')
  Comment = require('models/comment')
  CommentLinkContentView = require('views/comments/comment_link_content')
  globals = require('globals')

  describe 'CommentLinkContent', ->
    beforeEach ->
      globals.currentUser = @fixtures.User.valid

    describe 'initialization', ->
      beforeEach ->
        @InPlaceField = sinon.stub().returns(new Backbone.View)
        @link = new Link
        @options =
          InPlaceField: @InPlaceField
          model: new Comment(link: @link)

      describe 'link media type', ->
        beforeEach -> @view = new CommentLinkContentView(@options)

        it 'creates title and summary translatable fields', ->
          expect(@InPlaceField).toHaveBeenCalledTwice()
          expect(@InPlaceField).toHaveBeenCalledWith(model: @link, field: 'title', editable: true)
          expect(@InPlaceField).toHaveBeenCalledWith(model: @link, field: 'summary', editable: true)

      describe 'video media type', ->
        beforeEach ->
          sinon.stub(@link, 'getMediaType').returns('video')
          @view = new CommentLinkContentView(@options)

        it 'creates one translatable field', ->
          expect(@InPlaceField).toHaveBeenCalledOnce()
          expect(@InPlaceField).toHaveBeenCalledWith(model: @link, field: 'title', editable: true)

    describe 'rendering', ->
      beforeEach ->
        titleField = @titleField = new Backbone.View
        @titleField.render = () -> @el = document.createElement('span')
        summaryField = @summaryField = new Backbone.View
        @summaryField.render = () -> @el = document.createElement('span')

        self = @
        @InPlaceField = (options) ->
          switch options.field
            when 'title' then titleField
            when 'summary' then summaryField
            else throw(TypeError)

        @linkThumbnailView = new Backbone.View
        @linkThumbnailView.render = -> @el = document.createElement('img')
        @LinkThumbnailView = sinon.stub().returns(@linkThumbnailView)

        @link = new Link
        @options =
          InPlaceField: @InPlaceField
          LinkThumbnailView: @LinkThumbnailView
          model: new Comment(link: @link)

      describe 'link media type', ->
        beforeEach -> @view = new CommentLinkContentView(@options)

        describe 'translatable fields', ->

          it 'renders title field', ->
            spy = sinon.spy(@titleField, 'render')
            @view.render()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

          it 'inserts title into template', ->
            @view.render()
            expect(@view.$('h3.title')).toContain('span')

          it 'renders summary field', ->
            spy = sinon.spy(@summaryField, 'render')
            @view.render()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

          it 'inserts summary into template wrapped in p tag', ->
            @view.render()
            expect(@view.$('.preview p.summary')).toContain('span')

          it 'calls leave on title field when closing', ->
            @titleField.leave = ->
            spy = sinon.spy(@titleField, 'leave')
            @view.render()
            @view.leave()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

          it 'calls leave on summary field when closing', ->
            @summaryField.leave = ->
            spy = sinon.spy(@summaryField, 'leave')
            @view.render()
            @view.leave()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

      describe 'video media type', ->
        beforeEach ->
          sinon.stub(@link, 'getMediaType').returns('video')
          @view = new CommentLinkContentView(@options)

        describe 'translatable fields', ->
          it 'renders title field', ->
            spy = sinon.spy(@titleField, 'render')
            @view.render()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

          it 'does not render summary field', ->
            spy = sinon.spy(@summaryField, 'render')
            @view.render()
            expect(spy).not.toHaveBeenCalledOnce()

        describe 'thumbnail', ->
          it 'renders thumbnail', ->
            spy = sinon.spy(@linkThumbnailView, 'render')
            @view.render()
            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

          it 'inserts thumbnail into template', ->
            @view.render()
            expect(@view.$('.preview')).toContain('img')

    describe 'events', ->
      beforeEach ->
        link = new Link(
          title: en: "What is CrossFit?"
          summary: en: "CrossFit is an effective way to get fit. Anyone can do it."
          site_name: 'www.youtube.com'
          favicon_url: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico'
          source_locale: 'en')
        user = new User(@fixtures.User.valid)
        @comment = new Comment(link: link, user: user)
        @view = new CommentLinkContentView(model: @comment)
        @view.render()

      describe 'when title field is opened', ->
        it 'triggers open event if this is the first field opened', ->
          eventSpy = sinon.spy()
          @view.on('open', eventSpy)
          @view.$('.title .editable').click()
          expect(eventSpy).toHaveBeenCalledOnce()
          expect(eventSpy).toHaveBeenCalledWithExactly(@view)

        it 'does not trigger open event if other fields were already open', ->
          @view.$('.title .editable').click()
          eventSpy = sinon.spy()
          @view.on('open', eventSpy)
          @view.$('.summary .editable').click()
          expect(eventSpy).not.toHaveBeenCalledOnce()

      describe 'when title field is closed', ->
        it 'triggers close event if all fields are closed', ->
          eventSpy = sinon.spy()
          @view.on('close', eventSpy)
          @view.$('.title .editable').click()
          @view.$('button[type="cancel"]').click()
          expect(eventSpy).toHaveBeenCalledOnce()
          expect(eventSpy).toHaveBeenCalledWithExactly(@view)

        it 'does not trigger close event if other fields are still open', ->
          @view.$('.title .editable').click()
          @view.$('.summary .editable').click()
          eventSpy = sinon.spy()
          @view.on('close', eventSpy)
          @view.$('.title button[type="cancel"]').click()
          expect(eventSpy).not.toHaveBeenCalledOnce()

      describe 'when summary field is opened', ->
        it 'triggers open event', ->
          eventSpy = sinon.spy()
          @view.on('open', eventSpy)
          @view.$('.summary .editable').click()
          expect(eventSpy).toHaveBeenCalledOnce()
          expect(eventSpy).toHaveBeenCalledWithExactly(@view)

      describe 'when summary field is closed', ->
        it 'triggers close event', ->
          eventSpy = sinon.spy()
          @view.on('close', eventSpy)
          @view.$('.summary .editable').click()
          @view.$('button[type="cancel"]').click()
          expect(eventSpy).toHaveBeenCalledOnce()
          expect(eventSpy).toHaveBeenCalledWithExactly(@view)
