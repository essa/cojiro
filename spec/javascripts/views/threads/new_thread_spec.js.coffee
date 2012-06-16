describe "App.NewThreadView", ->
  beforeEach ->
    @model = new App.Thread()
    collection = url: '/en/threads'
    @model.collection = collection
    @view = new App.NewThreadView(model: @model)
    @$el = $(@view.el)

  afterEach ->
    window.app_router.navigate "jasmine"

  describe "instantiation", ->

    it "creates the new thread element", ->
      @view.render()
      expect(@$el).toBe("#new_thread")

    it "extends the form with leave functionality", ->
      @view.render()
      unbindSpy = sinon.spy(@view.form, 'unbind')
      removeSpy = sinon.spy(@view.form, 'remove')
      removeChildSpy = sinon.spy(@view, '_removeChild')

      @view.leave()

      expect(unbindSpy).toHaveBeenCalledOnce()
      expect(unbindSpy).toHaveBeenCalledWithExactly()
      expect(removeSpy).toHaveBeenCalledOnce()
      expect(removeSpy).toHaveBeenCalledWithExactly()
      expect(removeChildSpy).toHaveBeenCalledOnce()
      expect(removeChildSpy).toHaveBeenCalledWith(@view.form)

  describe "rendering", ->
    beforeEach ->
      @form =
        render: () -> {}
        el: "<form></form>"
      sinon.stub(Backbone, 'Form').returns(@form)

    afterEach ->
      Backbone.Form.restore()

    it "renders the thread onto the page", ->
      @view.render()
      expect(@$el).toHaveText(/Start a thread/)

    it "creates a new form", ->
      @view.render()
      expect(Backbone.Form).toHaveBeenCalledOnce()
      expect(Backbone.Form).toHaveBeenCalledWith(model: @model)

    it "renders the form", ->
      spy = sinon.spy(@form, 'render')

      @view.render()
      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWith()

    it "appends the form onto the page", ->
      spy = sinon.spy(@view.$el, 'append')

      @view.render()
      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWith("<form></form>")

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
      spy = sinon.spy(@model, 'save')
      @view.$('form').trigger('submit')

      expect(spy).toHaveBeenCalledOnce()

      @view.form.commit.restore()

  describe "after a successful save", ->
    beforeEach ->
      @view.render()
      @server = sinon.fakeServer.create()
      @server.respondWith(
        'POST',
        '/en/threads',
        [ 200, {'Content-Type': 'application/json'},'{"created_at":1339766056,"id":123,"source_language":"en","summary":"a summary","title":"a title","updated_at":1339766056,"user":{"fullname":"Cojiro Sasaki","id":1,"location":"Tokyo","name":"csasaki","profile":"A profile.","avatar_url":"/uploads/avatars/1/60v5906zg8b8bvp3nd9z.png","avatar_mini_url":"/uploads/avatars/1/mini_60v5906zg8b8bvp3nd9z.png"}}']
      )
      @view.$('form input[name="title"]').val("a title")
      @view.$('form textarea[name="summary"]').val("a summary")

    afterEach ->
      @server.restore()

    it "adds the thread to the collection", ->
      spy = sinon.spy(App.threads, 'add')

      @view.$('form').trigger('submit')
      @server.respond()

      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWith(@model)

    it "navigates to the new thread", ->
      spy = sinon.spy(window.app_router, 'navigate')

      @view.$('form').trigger('submit')
      @server.respond()

      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWith('/en/threads/123', trigger: true)
