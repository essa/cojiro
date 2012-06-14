describe "App.NewThreadView", ->
  beforeEach ->
    @model = new App.Thread()
    collection = url: '/en/threads'
    @model.collection = collection
    @view = new App.NewThreadView(model: @model)
    @$el = $(@view.el)

  describe "instantiation", ->

    it "creates the new thread element", ->
      @view.render()
      expect(@$el).toBe("#new_thread")

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

    it "renders the form onto the page", ->
      spy = sinon.spy(@view.$el, 'append')

      @view.render()
      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWith("<form></form>")

  describe "submitting the new thread", ->
    beforeEach ->
      $('.content').empty().append(@view.render().el)
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    it "commits the form data", ->
      spy = sinon.spy(@view.form, 'commit')
      @view.$('form').trigger('submit')

      expect(spy).toHaveBeenCalledOnce()
      expect(spy).toHaveBeenCalledWithExactly()

    it "saves the model if there are no errors", ->
      sinon.stub(@view.form, 'commit').returns(null)
      spy = sinon.spy(@model, 'save')
      @view.$('form').trigger('submit')

      expect(spy).toHaveBeenCalledOnce()

      @view.form.commit.restore()

    it "renders the newly-created thread for valid form input", ->
      sinon.spy(App, 'ThreadView')

      @server.respondWith(
        'POST',
        '/en/threads',
        [ 200, {'Content-Type': 'application/json'}, '{"id":123,"title":"a title","summary":"a summary"}']
      )
      @view.$('form input[name="title"]').val("a title")
      @view.$('form textarea[name="summary"]').val("a summary")
      #console.log(@view.form)
      #console.log(@view.form.getValue())
      #console.log(@view.form.commit())

      @view.$('form').trigger('submit')
      #console.log(@model)
      expect(App.ThreadView).toHaveBeenCalledOnce()

      App.ThreadView.restore()
