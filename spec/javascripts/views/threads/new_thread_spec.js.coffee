describe "App.NewThreadView", ->
  beforeEach ->
    @model = new Backbone.Model()
    @view = new App.NewThreadView(model: @model)
    @el = @view.el
    @$el = $(@el)
    @form =
      render: () -> {}
    sinon.stub(Backbone, 'Form').returns(@form)

  afterEach ->
    Backbone.Form.restore()

  it "renders the new thread page", ->
    @view.render()
    expect(@$el).toBe("#new_thread")
    expect(@$el).toHaveText(/Start a thread/)
    expect(@$el).toContain("form")

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
    formContainer =
      append: () -> {}
      html: () -> {}
    stub = sinon.stub(@view, '$').returns(formContainer)
    htmlSpy = sinon.spy(formContainer, 'html')
    appendSpy = sinon.spy(formContainer, 'append')

    @view.render()
    expect(stub).toHaveBeenCalledOnce()
    expect(stub).toHaveBeenCalledWith('form')
    expect(htmlSpy).toHaveBeenCalledOnce()
    expect(htmlSpy).toHaveBeenCalledWith('')
    expect(appendSpy).toHaveBeenCalledOnce()
    expect(appendSpy).toHaveBeenCalledWith(@form.el)
