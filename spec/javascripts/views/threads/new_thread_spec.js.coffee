describe "App.NewThreadView", ->
  beforeEach ->
    @model = new Backbone.Model
    collection = url: '/collection'
    @model.collection = collection
    @model.save = () -> {}

    @view = new App.NewThreadView(model: @model)
    @el = @view.el
    @$el = $(@el)

    @form =
      render: () -> {}
      commit: () -> null
      el: "<form></form>"
    sinon.stub(Backbone, 'Form').returns(@form)

  afterEach ->
    Backbone.Form.restore()

  it "renders the new thread page", ->
    @view.render()
    expect(@$el).toBe("#new_thread")
    expect(@$el).toHaveText(/Start a thread/)

  it "instantiates a new form", ->
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

  it "saves the form data", ->
    @view.render()
    formSpy = sinon.spy(@form, 'commit')

    @view.submit()
    expect(formSpy).toHaveBeenCalledOnce()
    expect(formSpy).toHaveBeenCalledWithExactly()

  it "saves the model if there are no errors", ->
    @view.render()
    modelSpy = sinon.spy(@model, 'save')

    @view.submit()
    expect(modelSpy).toHaveBeenCalledOnce()
