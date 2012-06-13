describe "App.NewThreadView", ->
  beforeEach ->
    @model = new App.Thread()
    collection = url: '/collection'
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
      @formSpy = sinon.spy(@view.form, 'commit')
      @view.$('form').trigger('submit')

      expect(@formSpy).toHaveBeenCalledOnce()
      expect(@formSpy).toHaveBeenCalledWithExactly()

    it "saves the model if there are no errors", ->
      sinon.stub(@view.form, 'commit').returns(null)
      @modelSpy = sinon.spy(@model, 'save')
      @view.$('form').trigger('submit')

      expect(@modelSpy).toHaveBeenCalledOnce()

      @view.form.commit.restore()
