describe "App.NewThreadView", ->

  it "is defined with alias", ->
    expect(App.NewThreadView).toBeDefined()
    expect(App.Views.NewThread).toBeDefined()
    expect(App.NewThreadView).toEqual(App.Views.NewThread)

  describe "with stubbed Backbone.Form constructor", ->
    beforeEach ->
      @model = new Backbone.Model
      @view = new App.NewThreadView(model: @model)
      @$el = @view.$el
      @form = new Backbone.View
      @form.render = ->
        @el = document.createElement('form')
        @el.setAttribute('id', 'new_thread')
      sinon.stub(Backbone, 'CompositeForm').returns(@form)

    afterEach ->
      App.appRouter.navigate "jasmine"
      Backbone.CompositeForm.restore()

    describe "instantiation", ->

      it "creates the new thread element", ->
        expect(@$el).toBe("#new_thread")

    describe "rendering", ->

      it "creates a new form", ->
        @view.render()
        expect(Backbone.CompositeForm).toHaveBeenCalledOnce()
        expect(Backbone.CompositeForm).toHaveBeenCalledWith(model: @model)

      it "renders the form", ->
        spy = sinon.spy(@form, 'render')

        @view.render()
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith()

      it "puts the new form on the page", ->
        @view.render()
        expect(@view.$el).toContain('form#new_thread')

    describe "Template", ->

      it "renders the new thread form title", ->
        @view.render()
        expect(@$el).toHaveText(/Start a thread/)

  describe "with actual Backbone.Form constructor", ->
    beforeEach ->
      @collection = new Backbone.Collection
      @collection.url = '/en/threads'
      @model = new App.Thread
      @model.collection = @collection
      @view = new App.NewThreadView(model: @model, collection: @collection)
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
