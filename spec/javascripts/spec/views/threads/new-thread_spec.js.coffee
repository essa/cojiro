define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')

  Thread = require('models/thread')
  NewThreadView = require('views/threads/new-thread')

  router = navigate: ->

  describe 'NewThreadView', ->
    beforeEach ->
      @submitFormSpy = sinon.spy(NewThreadView.prototype, 'submitForm')

    afterEach -> NewThreadView.prototype.submitForm.restore()

    describe 'with stubbed Thread model', ->
      beforeEach ->
        @model = new Backbone.Model
        _(@model).extend schema: -> {}
        @view = new NewThreadView(model: @model, router: router)
        @$el = @view.$el

      describe 'initialization', ->

        it 'creates the new thread element', ->
          expect(@$el).toBe('#new-thread')

        it 'assigns router', -> expect(@view.router).toEqual(router)

      describe 'rendering', ->

        it 'renders the new thread form title', ->
          I18n.locale = 'en'
          @view.render()
          expect(@$el).toHaveText(/Start a thread/)
          I18n.locale = I18n.defaultLocale

        it 'renders form submit button', ->
          @view.render()
          expect(@view.$el).toContain('button.btn.btn-primary:contains("Create thread")')

        it 'renders cancel button', ->
          @view.render()
          expect(@view.$el).toContain('.btn:contains("Cancel")')

    describe 'with actual Thread model', ->

      beforeEach ->
        @model = new Thread
        @collection = new Backbone.Collection([], model: Thread, url: '/collection')
        @model.collection = @collection
        @view = new NewThreadView(model: @model, collection: @collection, router: router)
        @$el = @view.$el

      describe 'submitting the form data', ->
        beforeEach ->
          @view.render()
          @$form = @view.$('form')
          sinon.stub(@model, 'save')

        afterEach ->
          @model.save.restore()

        it 'calls submitForm', ->
          @$form.submit()
          expect(@submitFormSpy).toHaveBeenCalledOnce()

        it 'prevents default form submission', ->
          spyEvent = spyOnEvent(@$form, 'submit')
          @$form.submit()
          expect('submit').toHaveBeenPreventedOn(@$form)
          expect(spyEvent).toHaveBeenPrevented()

        it 'sets title and summary values', ->
          @view.$el.findField('Title').val('a title')
          @view.$el.findField('Summary').val('a summary')
          @$form.submit()

          expect(@model.getAttr('title')).toEqual('a title')
          expect(@model.getAttr('summary')).toEqual('a summary')

        it 'saves the model', ->
          sinon.stub(@model, 'set').returns(null)
          sinon.stub(@model, 'validate')
          @$form.submit()
          expect(@model.save).toHaveBeenCalledOnce()
          @model.set.restore()

      describe 'with errors', ->
        beforeEach ->
          @view.render()
          @$form = @view.$('form')

        it 'renders inline errors', ->
          @$form.submit()
          expect(@view.$('.title')).toContainText('can\'t be blank')

        it 'removes any previous alert(s) and adds a new one', ->
          @$form.submit()
          expect(@view.$('.has-error')).toHaveLength(1)

      describe 'after a successful save', ->
        beforeEach ->
          @view.render()
          @server = sinon.fakeServer.create()
          @server.respondWith(
            'POST'
            '/collection'
            @validResponse(_(@fixtures.Thread.valid)
              .extend(
                id: '123'
                title: 'a title'
                summary: 'a summary'
              ))
          )
          sinon.stub(router, 'navigate')
          @view.$('form input').val('a title')
          @view.$('form textarea').val('a summary')

        afterEach ->
          @server.restore()
          router.navigate.restore()

        it 'adds the thread to the collection', ->
          spy = sinon.spy(@collection, 'add')

          @view.$('form').trigger('submit')
          @server.respond()

          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWith(@model)

        it 'saves the user data for the thread', ->
          @view.$('form').trigger('submit')
          @server.respond()
          expect(@model.getUserName()).toEqual('csasaki')

        it 'navigates to the new thread', ->
          @view.$('form').trigger('submit')
          @server.respond()

          expect(router.navigate).toHaveBeenCalledOnce()
          expect(router.navigate).toHaveBeenCalledWith('/collection/123', true)
