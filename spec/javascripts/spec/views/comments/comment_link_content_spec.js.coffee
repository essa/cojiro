define (require) ->

  Link = require('models/link')
  User = require('models/user')
  Comment = require('models/comment')
  CommentLinkContentView = require('views/comments/comment_link_content')
  globals = require('globals')

  describe 'CommentLinkContent', ->
    beforeEach ->
      globals.currentUser = @fixtures.User.valid
      link = new Link(
        title: en: "What is CrossFit?"
        summary: en: "CrossFit is an effective way to get fit. Anyone can do it."
        site_name: 'www.youtube.com'
        favicon_url: 'http://s.ytimg.com/yts/img/favicon-vfldLzJxy.ico'
        source_locale: 'en')
      user = new User(@fixtures.User.valid)
      @comment = new Comment(link: link, user: user)

    describe 'events', ->
      beforeEach ->
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

    describe 'translatable fields', ->
      beforeEach ->
        @view = new CommentLinkContentView(model: new Comment(link: new Link))

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
