define (require) ->

  Backbone = require('backbone')

  form = new Backbone.View
  form.render = ->
    @el = document.createElement('form')
    @el.setAttribute('id', 'new_thread')
  Form = sinon.stub().returns(form)
  I18n = require('i18n')

  Thread = require('models/thread')

  # need to make sure 'app' is loaded
  # when called with 'require'
  App = require('app')
  App.appRouter = navigate: ->

  context(
    "backbone": Backbone
    "backbone-forms": Form
    "app": App
    "i18n": I18n
  ) ["views/threads/new_thread"], (NewThreadView) ->

    describe "NewThreadView (with stubbed Backbone.Form constructor)", ->
      beforeEach ->
        @model = new Backbone.Model
        @view = new NewThreadView(model: @model)
        @$el = @view.$el

      describe "instantiation", ->

        it "creates the new thread element", ->
          expect(@$el).toBe("#new_thread")

      describe "rendering", ->

        it "creates a new form", ->
          @view.render()
          expect(Form.calledWithNew()).toBeTruthy()
          expect(Form).toHaveBeenCalledWith(model: @model)

        it "renders the form", ->
          spy = sinon.spy(form, 'render')

          @view.render()
          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWith()

        it "puts the new form on the page", ->
          @view.render()
          expect(@view.$el).toContain('form#new_thread')

      describe "Template", ->

        it "renders the new thread form title", ->
          I18n.locale = 'en'
          @view.render()
          expect(@$el).toHaveText(/Start a thread/)
          I18n.locale = I18n.defaultLocale

  context(
    "backbone": Backbone
    "models/thread": Thread
  ) ["views/threads/new_thread"], (NewThreadView) ->

    describe "NewThreadView (with actual Backbone.Form constructor)", ->

      beforeEach ->
        @collection = new Backbone.Collection
        @collection.url = '/en/threads'
        @model = new Thread
        @model.collection = @collection
        @view = new NewThreadView(model: @model, collection: @collection)
        @$el = @view.$el

      describe "submitting the form data", ->
        beforeEach ->
          @view.render()

        it "commits the form data", ->
          spy = sinon.spy(@view.form, 'commit')
          @view.$('form').trigger('submit')

          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWithExactly()

        it "saves the model", ->
          sinon.stub(@view.form, 'commit').returns(null)
          sinon.stub(@model, 'save')
          @view.$('form').trigger('submit')

          expect(@model.save).toHaveBeenCalledOnce()

          @view.form.commit.restore()

      describe "after a successful save", ->
        beforeEach ->
          @view.render()
          @server = sinon.fakeServer.create()
          @server.respondWith(
            'POST',
            '/en/threads',
            [ 200, {'Content-Type': 'application/json'}, JSON.stringify(_(@fixtures.Thread.valid).extend(id: "123")) ]
          )
          sinon.stub(App.appRouter, 'navigate')
          @view.$('form input[name="title"]').val("a title")
          @view.$('form textarea[name="summary"]').val("a summary")

        afterEach ->
          @server.restore()
          App.appRouter.navigate.restore()

        it "adds the thread to the collection", ->
          spy = sinon.spy(@collection, 'add')

          @view.$('form').trigger('submit')
          @server.respond()

          expect(spy).toHaveBeenCalledOnce()
          expect(spy).toHaveBeenCalledWith(@model)

        it "navigates to the new thread", ->
          @view.$('form').trigger('submit')
          @server.respond()

          expect(App.appRouter.navigate).toHaveBeenCalledOnce()
          expect(App.appRouter.navigate).toHaveBeenCalledWith('/en/threads/123', true)
