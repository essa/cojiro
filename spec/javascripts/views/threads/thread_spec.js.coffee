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
      expect(@$el).toContain('button.edit-button:contains("Edit")')

  describe "editable fields", ->
    beforeEach ->
      @thread = new App.Thread(_(@fixtures.Thread.valid).extend(id: "123"))
      @collection =
        url: '/en/threads'
        add: ->
      @thread.collection = @collection

    describe "when title edit button handler is fired", ->
      beforeEach ->
        @showEditableFieldSpy = sinon.spy(App.ThreadView.prototype, 'showEditableField')
        @view = new App.ThreadView(model: @thread)
        @view.render()
        @$titleEditButton = @view.$('span[data-attribute="title"] ~ button.edit-button')

      afterEach ->
        App.ThreadView.prototype.showEditableField.restore()

      it 'calls showEditableField', ->
        @$titleEditButton.trigger('click')
        expect(@showEditableFieldSpy).toHaveBeenCalledOnce()

      it 'changes the edit button into a save button', ->
        @$titleEditButton.trigger('click')
        expect(@$titleEditButton).toHaveClass('save-button')
        expect(@$titleEditButton).not.toHaveClass('edit-button')
        expect(@$titleEditButton).toHaveText('Save')

      it 'creates a new backbone form for the "title" field, assigns it to @forms["title"] and renders it', ->
        form =
          render: -> @
          el: "<form></form>"
        sinon.stub(Backbone, 'Form').returns(form)
        sinon.spy(form, 'render')
        @$titleEditButton.trigger('click')

        expect(Backbone.Form).toHaveBeenCalledOnce()
        expect(Backbone.Form).toHaveBeenCalledWith(model: @thread, fields: [ "title" ], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
        expect(@view.forms['title']).toEqual(form)
        expect(form.render).toHaveBeenCalled()
        expect(form.render).toHaveBeenCalledWithExactly()

        Backbone.Form.restore()

      it 'renders the input field', ->
        @$titleEditButton.trigger('click')
        expect(@$titleEditButton.prev()).toContain('input[name="title"]')

    describe "when title save button is fired", ->
      beforeEach ->
        @saveEditableFieldSpy = sinon.spy(App.ThreadView.prototype, 'saveEditableField')
        @view = new App.ThreadView(model: @thread)
        @view.render()
        @$titleEditButton = @view.$('span[data-attribute="title"] ~ button.edit-button')
        @$titleEditButton.trigger('click')
        sinon.stub(@thread, 'save').returns(null)

      afterEach ->
        App.ThreadView.prototype.saveEditableField.restore()
        @thread.save.restore()

      it 'calls saveEditableField', ->
        @$titleEditButton.trigger('click')
        expect(@saveEditableFieldSpy).toHaveBeenCalledOnce()

      it 'commits the form for the edited field', ->
        spy = sinon.spy(@view.forms['title'], 'commit')
        @$titleEditButton.trigger('click')

        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWithExactly()

      it 'saves the model', ->
        sinon.stub(@view.forms['title'], 'commit').returns(null)
        @$titleEditButton.trigger('click')

        expect(@thread.save).toHaveBeenCalledOnce()

        @view.forms['title'].commit.restore()

    describe "after a successful save", ->
      beforeEach ->
        @view = new App.ThreadView(model: @thread)
        @view.render()
        @$titleEditButton = @view.$('span[data-attribute="title"] ~ button.edit-button')
        @$titleEditButton.trigger('click')
        @server = sinon.fakeServer.create()
        @server.respondWith(
          'PUT',
          '/en/threads/123',
          [ 200, {'Content-Type': 'application/json'}, JSON.stringify(@fixtures.Thread.valid) ]
        )

      afterEach ->
        @server.restore()

      it "changes the save button back to an edit button", ->
        @$titleEditButton.trigger('click')
        @server.respond()

        expect(@$titleEditButton).toHaveClass('edit-button')
        expect(@$titleEditButton).not.toHaveClass('save-button')
        expect(@$titleEditButton).toHaveText('Edit')
