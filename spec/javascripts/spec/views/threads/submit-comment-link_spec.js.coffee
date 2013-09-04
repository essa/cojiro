define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  Thread = require('models/thread')
  Comment = require('models/comment')
  User = require('models/user')
  SubmitCommentLinkView = require('views/threads/submit-comment-link')
  I18n = require('i18n')
  channel = require('modules/channel')

  titleSelector = '.title textarea'
  summarySelector = '.summary textarea'

  beforeEach ->
    @nextSpy = sinon.spy(SubmitCommentLinkView.prototype, 'next')
    @user = new User(name: 'foo')
    @thread = new Thread
    @thread.collection = url: '/collection'

  afterEach ->
    @nextSpy.restore()

  sharedExamples = (link_attributes) ->

    beforeEach ->
      @model = new Link(link_attributes)
      @model.set('user', @user)
      @view = new SubmitCommentLinkView(model: @model, thread: @thread)

    describe 'initialization', ->
      beforeEach -> @$el = @view.$el

      it 'creates a div element for the form', ->
        expect(@$el).toBe('div')

      it 'assigns options.thread to thread', ->
        expect(@view.thread).toEqual(@thread)

    describe 'rendering', ->
      beforeEach -> @view.render()

      it 'returns the view object', ->
        expect(@view.render()).toEqual(@view)

      it 'renders modal title', ->
        $el = @view.render().$el
        expect($el.find('.modal-header')).toHaveText(/Add/)

      it 'renders url in title', ->
        @view.render()
        expect(@view.$('.modal-header')).toContain('small:contains("http://ja.wikipedia.org/wiki/カポエイラ")')

      it 'renders form with bootstrap form-horizontal class', ->
        expect(@view.$('form')).toHaveClass('form-horizontal')

      it 'renders modal confirm button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn-primary:contains("Add to this thread")')

      it 'renders modal back button', ->
        @view.render()
        expect(@view.$el).toContain('button.btn:contains("Back")')

      describe 'source locale', ->
        it 'renders source_locale label', ->
          expect(@view.$el).toContainText('This link is in')

      describe 'cleaning up', ->

        it 'calls leave on any existing header', ->
          header =
            leave: ->
            render: ->
          sinon.spy(header, 'leave')
          @view.header = header
          @view.render()
          @view.leave()
          expect(header.leave).toHaveBeenCalledOnce()

        it 'calls leave on any existing footer', ->
          footer =
            leave: ->
            render: ->
          sinon.spy(footer, 'leave')
          @view.footer = footer
          @view.render()
          @view.leave()
          expect(footer.leave).toHaveBeenCalledOnce()

        xit 'calls leave on any existing form'

  describe 'SubmitCommentLinkView', ->
    describe 'for a link that is not yet registered', ->
      describe 'shared behavior', ->
        sharedExamples(
          url: 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9'
          display_url: 'http://ja.wikipedia.org/wiki/カポエイラ'
        )

      describe 'behavior specific to unregistered link', ->
        beforeEach ->
          @model = new Link(
            url: 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9'
            display_url: 'http://ja.wikipedia.org/wiki/カポエイラ')
          @model.set('user', @user)
          @view = new SubmitCommentLinkView(model: @model, thread: @thread)

        describe 'rendering', ->
          beforeEach -> @view.render()

          describe 'source_locale', ->

            it 'renders source_locale drop-down', ->
              expect(@view.$el).toContain('select[name="source_locale"]')

            it 'renders default option', ->
              expect(@view.$el).toContain('option[value=""]')
              expect(@view.$('option[value=""]')).toHaveText('Select a language')

            it 'renders an option for every locale in I18n.availableLocales', ->
              expect(@view.$el).toContain('option[value="en"]')
              expect(@view.$('option[value="en"]')).toHaveText('English')
              expect(@view.$el).toContain('option[value="ja"]')
              expect(@view.$('option[value="ja"]')).toHaveText('Japanese')

          describe 'title', ->

            it 'renders title field', ->
              expect(@view.$el).toContain(titleSelector)

            it 'sets title field to readonly until source locale has been selected', ->
              expect(@view.$(titleSelector)).toHaveAttr('readonly')

            it 'prefills title field with title from embed data', ->
              @model.getEmbedData = -> title: 'a title'
              @view.render()
              expect(@view.$(titleSelector)).toHaveValue('a title')

          describe 'summary', ->

            it 'renders summary field', ->
              expect(@view.$el).toContain(summarySelector)

            it 'sets summary field to readonly until source locale has been selected', ->
              expect(@view.$(summarySelector)).toHaveAttr('readonly')

            it 'prefills summary field with description from embed data', ->
              @model.getEmbedData = -> description: 'a summary'
              @view.render()
              expect(@view.$(summarySelector)).toHaveValue('a summary')

        describe 'events', ->
          describe 'when source locale is selected', ->
            beforeEach ->
              @view.render()

            it 'updates the title label with the language', ->
              expect(@view.$('.title label')).toHaveText('Title')
              @view.$('select').val('ja').trigger('change')
              expect(@view.$('.title label')).toHaveText('Title in Japanese')

            it 'updates the summary label with the language', ->
              expect(@view.$('.summary label')).toHaveText('Summary')
              @view.$('select').val('ja').trigger('change')
              expect(@view.$('.summary label')).toHaveText('Summary in Japanese')

            it 'removes readonly restriction on title field', ->
              expect(@view.$(titleSelector)).toHaveAttr('readonly')
              @view.$('select').val('ja').trigger('change')
              expect(@view.$(titleSelector)).not.toHaveAttr('readonly')

            it 'removes readonly restriction on summary field', ->
              expect(@view.$(summarySelector)).toHaveAttr('readonly')
              @view.$('select').val('ja').trigger('change')
              expect(@view.$(summarySelector)).not.toHaveAttr('readonly')

            it 'removes default source locale option', ->
              expect(@view.$('select[name="source_locale"] option[value=""]').length).toEqual(1)
              @view.$('select').val('ja').trigger('change')
              expect(@view.$('select[name="source_locale"] option[value=""]').length).toEqual(0)

            it 'removes any existing errors on source locale', ->
              @view.$('.form-group.source_locale').addClass('error')
              @view.$('.form-group .help-block').html('an error message')
              @view.$('select').val('en').trigger('change')
              expect(@view.$('.form-group.source_locale')).not.toHaveClass('error')
              expect(@view.$('.form-group .help-block')).toBeEmpty()

          describe 'submitting comment and nested link form data', ->
            beforeEach ->
              @view.render()
              @server = sinon.fakeServer.create()
              @$nextButton = @view.$('button[type="submit"]')

            afterEach -> @server.restore()

            it 'calls next', ->
              @$nextButton.click()
              expect(@nextSpy).toHaveBeenCalledOnce()

            describe 'with valid data', ->
              beforeEach ->
                @view.$('select').val('ja').trigger('change')
                @view.$('.title textarea').val('日本語のタイトル')
                @view.$('.summary textarea').val('日本語のサマリ')
                @view.$('.text textarea').val('a comment text')
                @thread.id = 123
                @server.respondWith(
                  'POST'
                  '/collection/123/comments'
                  @validResponse(id: '555')
                )

              describe 'saving the comment and link', ->

                it 'makes correct request', ->
                  @$nextButton.click()
                  expect(@server.requests.length).toEqual(1)
                  expect(@server.requests[0]).toBePOST()
                  expect(@server.requests[0]).toHaveUrl('/collection/123/comments')

                it 'sends valid data', ->
                  @$nextButton.click()
                  request = @server.requests[0]
                  params = JSON.parse(request.requestBody)
                  expect(params.comment).toBeDefined()
                  expect(params.comment.text).toEqual(en: 'a comment text')
                  expect(params.comment.link_attributes).toBeDefined()
                  expect(params.comment.link_attributes.source_locale).toEqual('ja')
                  expect(params.comment.link_attributes.title).toEqual(ja: '日本語のタイトル')
                  expect(params.comment.link_attributes.summary).toEqual(ja: '日本語のサマリ')

                it 'creates new comment on thread', ->
                  @$nextButton.click()
                  @server.respond()
                  comments = @thread.getComments()
                  expect(comments.length).toEqual(1)

                it 'sets comment id from response', ->
                  @$nextButton.click()
                  @server.respond()
                  comment = @thread.getComments().at(0)
                  expect(comment.getId()).toEqual('555')

                it 'associates link with comment', ->
                  @$nextButton.click()
                  @server.respond()
                  comment = @thread.getComments().at(0)
                  expect(comment.getLink()).toBeDefined()
                  expect(comment.getLink().getUrl()).toEqual('http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9')

                it 'sets comment values from form', ->
                  @$nextButton.click()
                  @server.respond()
                  comment = @thread.getComments().at(0)
                  expect(comment.getText()).toEqual('a comment text')

                it 'sets link values from form', ->
                  @$nextButton.click()
                  @server.respond()
                  expect(@model.getSourceLocale()).toEqual('ja')
                  expect(@model.getAttrInLocale('title', 'ja')).toEqual('日本語のタイトル')
                  expect(@model.getAttrInLocale('summary', 'ja')).toEqual('日本語のサマリ')

                it 'does not trigger any errors', ->
                  @$nextButton.click()
                  @server.respond()
                  expect(@view.$el).not.toContain('.error')
                  expect(@model.validationError).toBeNull()

              describe 'adding comment to the thread', ->
                # make sure that the event is actually triggered
                beforeEach ->
                  @eventSpy = sinon.spy()
                  @thread.on('add:comments', @eventSpy)
                afterEach -> expect(@eventSpy).toHaveBeenCalledOnce()

                it 'adds comment to thread only after link title and summary have been set', ->
                  thread = @thread
                  @thread.on('add:comments', ->
                    links = thread.getLinks()
                    expect(links[0].getAttrInLocale('title', 'ja')).toEqual('日本語のタイトル')
                    expect(links[0].getAttrInLocale('summary', 'ja')).toEqual('日本語のサマリ')
                  )
                  @$nextButton.click()
                  @server.respond()

                it 'adds comment to thread only after comment text has been set', ->
                  thread = @thread
                  @thread.on('add:comments', ->
                    comments = thread.getComments()
                    expect(comments.at(0).getText()).toEqual('a comment text')
                  )
                  @$nextButton.click()
                  @server.respond()

              describe 'after a successful save', ->

                it 'triggers a modal:next event on the channel', ->
                  eventSpy = sinon.spy()
                  channel.on('modal:next', eventSpy)
                  @$nextButton.click()
                  @server.respond()
                  expect(eventSpy).toHaveBeenCalledOnce()
                  expect(eventSpy).toHaveBeenCalledWithExactly()

                it 'calls leave on the view', ->
                  sinon.spy(@view, 'leave')
                  @$nextButton.click()
                  @server.respond()
                  expect(@view.leave).toHaveBeenCalledOnce()
                  expect(@view.leave).toHaveBeenCalledWithExactly()

            describe 'with invalid data', ->

              it 'makes no request', ->
                @$nextButton.click()
                expect(@server.requests.length).toEqual(0)

              it 'renders error if source locale is not set', ->
                @$nextButton.click()
                expect(@view.$('.form-group.source_locale')).toHaveClass('has-error')

              it 'renders error if title is blank', ->
                @view.$('select').val('en')
                @view.$('.title textarea').val('')
                @$nextButton.click()
                expect(@view.$('.form-group.title')).toHaveClass('has-error')

    describe 'for a link that is already registered', ->
      describe 'shared behavior', ->

        sharedExamples(
          url: 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9'
          display_url: 'http://ja.wikipedia.org/wiki/カポエイラ'
          source_locale: 'en'
          title: ja: '日本語のタイトル'
          summary: ja: '日本語のサマリ'
        )

      describe 'behavior specific to registered link', ->
        beforeEach ->
          @model = new Link(
            url: 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9'
            user_name: 'foo'
            display_url: 'http://ja.wikipedia.org/wiki/カポエイラ'
            source_locale: 'ja'
            title: ja: '日本語のタイトル'
            summary: ja: '日本語のサマリ'
            created_at: '2012-07-08T12:20:00Z'
          )
          @model.set('user', @user)
          @view = new SubmitCommentLinkView(model: @model, thread: @thread)

        describe 'rendering', ->
          beforeEach -> @view.render()

          describe 'source_locale', ->
            it 'replaces source locale field with form-control-static p tag', ->
              expect(@view.$el).toContain('p.form-control-static:contains("Japanese")')

            it 'does not render select tag', ->
              expect(@view.$el).not.toContain('select[name="source_locale"]')

          describe 'title', ->
            it 'renders title as static text', ->
              expect(@view.$('.title p.form-control-static')).toHaveText('日本語のタイトル')

          describe 'summary', ->
            it 'renders summary as static text', ->
              expect(@view.$('.summary p.form-control-static')).toHaveText('日本語のサマリ')

          describe 'flash message', ->
            it 'appends flash message', ->
              expect(@view.$el).toContainText(
                'This link is already registered in cojiro. It was added by @foo on July 8, 2012.'
              )

        describe 'submitting comment', ->
          beforeEach ->
            @view.render()
            @server = sinon.fakeServer.create()
            @$nextButton = @view.$('button[type="submit"]')

          afterEach -> @server.restore()

          it 'calls next', ->
            @$nextButton.click()
            expect(@nextSpy).toHaveBeenCalledOnce()

          describe 'saving the comment', ->
            beforeEach ->
              @thread.id = 123
              @view.$('.title textarea').val('another title')
              @view.$('.summary textarea').val('another summary')
              @server.respondWith(
                'POST'
                '/collection/123/comments'
                @validResponse(id: '555')
              )

            it 'makes correct request', ->
              @$nextButton.click()
              expect(@server.requests.length).toEqual(1)
              expect(@server.requests[0]).toBePOST()
              expect(@server.requests[0]).toHaveUrl('/collection/123/comments')

            it 'sends valid data for comment but ignores form inputs', ->
              @$nextButton.click()
              request = @server.requests[0]
              params = JSON.parse(request.requestBody)
              expect(params.comment).toBeDefined()
              expect(params.comment.link_attributes.url).toEqual('http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9')
              expect(params.comment.link_attributes.source_locale).toEqual('ja')
              expect(params.comment.link_attributes.title).toEqual(ja: '日本語のタイトル')
              expect(params.comment.link_attributes.summary).toEqual(ja: '日本語のサマリ')
