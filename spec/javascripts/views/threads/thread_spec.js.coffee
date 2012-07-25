describe "App.ThreadView", ->
  it "is defined with alias", ->
    expect(App.ThreadView).toBeDefined()
    expect(App.Views.Thread).toBeDefined()
    expect(App.ThreadView).toEqual(App.Views.Thread)

  describe "rendering", ->
    beforeEach ->
      thread = new App.Thread()
      thread.set
        title: "Geisha bloggers",
        summary: "Looking for info on geisha bloggers."
        user:
          name: "csasaki"
          fullname: "Cojiro Sasaki"
          avatar_mini_url: "http://www.example.com/mini_csasaki.png"

      view = new App.ThreadView(model: thread)
      @el = view.render().el
      @$el = $(@el)

    it "renders the thread", ->
      expect(@$el).toBe("#thread")
      expect(@$el).toHaveText(/Geisha bloggers/)
      expect(@$el).toHaveText(/Looking for info on geisha bloggers./)

    it "renders user info", ->
      expect(@$el).toHaveText(/@csasaki/)
      expect(@$el).toHaveText(/Cojiro Sasaki/)
      expect(@$el).toContain('img[src="http://www.example.com/mini_csasaki.png"]')

    it 'renders edit/add button', ->
      expect(@$el).toContain('button.edit-button:contains("edit")')

  describe "editable fields", ->
    beforeEach ->
      @editableFieldSpy = sinon.spy(App.ThreadView.prototype, 'showEditableField')
      @thread = new App.Thread(@fixtures.Thread.valid)
      @view = new App.ThreadView(model: @thread)
      @el = @view.render().el
      @$el = $(@el)

    afterEach ->
      App.ThreadView.prototype.showEditableField.restore()

    describe "when title edit button handler is fired", ->
      beforeEach ->
        @$titleEditButton = @view.$('span[data-attribute="title"] ~ button.edit-button')

      it 'calls showEditableField', ->
        @$titleEditButton.trigger('click')
        expect(@editableFieldSpy).toHaveBeenCalledOnce()

      it 'creates a new backbone form for the "title" field and renders it', ->
        form =
          render: -> {}
          el: "<form></form>"
        sinon.stub(Backbone, 'Form').returns(form)
        sinon.spy(form, 'render')
        @$titleEditButton.trigger('click')

        expect(Backbone.Form).toHaveBeenCalledOnce()
        expect(Backbone.Form).toHaveBeenCalledWith(model: @thread, fields: [ "title" ])
        expect(form.render).toHaveBeenCalled()
        expect(form.render).toHaveBeenCalledWithExactly()

        Backbone.Form.restore()

      it 'changes the button text to "save"', ->
        @$titleEditButton.trigger('click')
        expect(@$titleEditButton).toHaveText('save')

      it 'renders the input field', ->
        @$titleEditButton.trigger('click')
        expect(@$titleEditButton.prev()).toContain('input[name="title"]')
