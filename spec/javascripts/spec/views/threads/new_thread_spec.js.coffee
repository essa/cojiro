define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')

  Thread = require('models/thread')
  NewThreadView = require('views/threads/new_thread')

  router = navigate: ->

  describe "NewThreadView", ->
    beforeEach ->
      @submitFormSpy = sinon.spy(NewThreadView.prototype, 'submitForm')

    afterEach ->
      NewThreadView.prototype.submitForm.restore()

    describe "with stubbed Thread model", ->
      beforeEach ->
        @model = new Backbone.Model
        @view = new NewThreadView(model: @model, router: router)
        @$el = @view.$el

      describe "instantiation", ->

        it "creates the new thread element", ->
          expect(@$el).toBe("#new_thread")

      describe "Template", ->

        it "renders the new thread form title", ->
          I18n.locale = 'en'
          @view.render()
          expect(@$el).toHaveText(/Start a thread/)
          I18n.locale = I18n.defaultLocale

    describe "NewThreadView (with actual Thread model)", ->

      beforeEach ->
        @collection = new Backbone.Collection
        @collection.url = '/en/threads'
        @model = new Thread
        @model.collection = @collection
        @view = new NewThreadView(model: @model, collection: @collection, router: router)
        @$el = @view.$el

      describe "submitting the form data", ->
        beforeEach ->
          @view.render()
          @$form = @view.$('form')

        it 'calls submitForm', ->
          @$form.submit()
          expect(@submitFormSpy).toHaveBeenCalledOnce()

        it 'prevents default form submission', ->
          spyEvent = spyOnEvent(@$form, 'submit')
          @$form.submit()
          expect('submit').toHaveBeenPreventedOn(@$form)
          expect(spyEvent).toHaveBeenPrevented()

        it 'sets title and summary values', ->
          @view.$("input#title").val("a title")
          @view.$("textarea#summary").val("a summary")
          sinon.stub(@model, 'save')
          @$form.trigger('submit')

          expect(@model.getAttr('title')).toEqual("a title")
          expect(@model.getAttr('summary')).toEqual("a summary")

        it "saves the model", ->
          sinon.stub(@model, 'set').returns(null)
          sinon.stub(@model, 'save')
          @view.$('form').trigger('submit')

          expect(@model.save).toHaveBeenCalledOnce()

          @model.set.restore()

      describe "after a successful save", ->
        beforeEach ->
          @view.render()
          @server = sinon.fakeServer.create()
          @server.respondWith(
            'POST',
            '/en/threads',
            [ 200, {'Content-Type': 'application/json'}, JSON.stringify(_(@fixtures.Thread.valid).extend(id: "123")) ]
          )
          sinon.stub(router, 'navigate')
          @view.$('form input[name="title"]').val("a title")
          @view.$('form textarea[name="summary"]').val("a summary")

        afterEach ->
          @server.restore()
          router.navigate.restore()

        it "adds the thread to the collection", ->
          spy = sinon.spy(@collection, 'add')

          @view.$('form').trigger('submit')
          @server.respond()

          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWith(@model)

        it "navigates to the new thread", ->
          @view.$('form').trigger('submit')
          @server.respond()

          expect(router.navigate).toHaveBeenCalledOnce()
          expect(router.navigate).toHaveBeenCalledWith('/en/threads/123', true)
