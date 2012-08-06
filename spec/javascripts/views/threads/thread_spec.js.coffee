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

    sharedExamplesForEditableFields = (context) ->

      describe "shared behaviour for editable fields", ->
        beforeEach ->
          @attr = context.attr
          @type = context.type || 'input'
          @thread = new App.Thread(_(@fixtures.Thread.valid).extend(id: "123"))
          @collection =
            url: '/en/threads'
            add: ->
          @thread.collection = @collection

        describe "when edit button handler is fired", ->
          beforeEach ->
            @showEditableFieldSpy = sinon.spy(App.ThreadView.prototype, 'showEditableField')
            @view = new App.ThreadView(model: @thread)
            @view.render()
            @$editButton = @view.$("span[data-attribute='#{@attr}'] ~ button.edit-button")

          afterEach ->
            App.ThreadView.prototype.showEditableField.restore()

          it 'calls showEditableField', ->
            @$editButton.trigger('click')
            expect(@showEditableFieldSpy).toHaveBeenCalledOnce()

          it 'changes the edit button into a save button', ->
            @$editButton.trigger('click')
            expect(@$editButton).toHaveClass('save-button')
            expect(@$editButton).not.toHaveClass('edit-button')
            expect(@$editButton).toHaveText('Save')

          it "uses exiting form if @forms[\"#{context.attr}\"] already exists", ->
            form =
              render: -> @
            @view.forms = {}
            @view.forms[@attr] = form
            sinon.spy(Backbone, 'Form')
            sinon.spy(form, 'render')
            @$editButton.trigger('click')

            expect(Backbone.Form).not.toHaveBeenCalled()
            expect(form.render).toHaveBeenCalled()
            expect(form.render).toHaveBeenCalled()
            expect(form.render).toHaveBeenCalledWithExactly()

            Backbone.Form.restore()

          it "creates a new backbone form, assigns it to @forms[\"#{context.attr}\"] and renders it as a child if form has not yet been created", ->
            form =
              render: -> @
            sinon.stub(Backbone, 'Form').returns(form)
            sinon.spy(form, 'render')
            @$editButton.trigger('click')

            expect(Backbone.Form).toHaveBeenCalledOnce()
            expect(Backbone.Form).toHaveBeenCalledWith(model: @thread, fields: [ @attr ], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
            expect(@view.forms[@attr]).toEqual(form)
            expect(form.render).toHaveBeenCalled()
            expect(form.render).toHaveBeenCalledWithExactly()
            expect(@view.children.last()).toEqual(form)

            Backbone.Form.restore()

          it 'renders the form field', ->
            @$editButton.trigger('click')
            expect(@$editButton.prev()).toContain("#{@type}[name='#{@attr}']")

        describe "when save button is fired", ->
          beforeEach ->
            @saveEditableFieldSpy = sinon.spy(App.ThreadView.prototype, 'saveEditableField')
            @view = new App.ThreadView(model: @thread)
            @view.render()
            @$editButton = @view.$("span[data-attribute='#{@attr}'] ~ button.edit-button")
            @$editButton.trigger('click')
            sinon.stub(@thread, 'save').returns(null)

          afterEach ->
            App.ThreadView.prototype.saveEditableField.restore()
            @thread.save.restore()

          it 'calls saveEditableField', ->
            @$editButton.trigger('click')
            expect(@saveEditableFieldSpy).toHaveBeenCalledOnce()

          it 'commits the form for the edited field', ->
            spy = sinon.spy(@view.forms[@attr], 'commit')
            @$editButton.trigger('click')

            expect(spy).toHaveBeenCalledOnce()
            expect(spy).toHaveBeenCalledWithExactly()

          it 'saves the model', ->
            sinon.stub(@view.forms[@attr], 'commit').returns(null)
            @$editButton.trigger('click')

            expect(@thread.save).toHaveBeenCalledOnce()

            @view.forms[@attr].commit.restore()

        describe "when editable field is submitted (e.g. by hitting enter while in form field)", ->
          beforeEach ->
            @submitEditableFieldFormSpy = sinon.spy(App.ThreadView.prototype, 'submitEditableFieldForm')
            @view = new App.ThreadView(model: @thread)
            @view.render()
            @$editButton = @view.$("span[data-attribute='#{@attr}'] ~ button.edit-button")
            @$editButton.trigger('click')
            sinon.stub(@thread, 'save').returns(null)
            @$form = @view.$("span[data-attribute='#{@attr}'] form")

          afterEach ->
            App.ThreadView.prototype.submitEditableFieldForm.restore()
            @thread.save.restore()

          it 'calls submitEditableFieldForm', ->
            @$form.submit()
            expect(@submitEditableFieldFormSpy).toHaveBeenCalledOnce()

          it 'prevents default form submission', ->
            spyEvent = spyOnEvent(@$form, 'submit')
            @$form.submit()
            expect('submit').toHaveBeenPreventedOn(@$form)
            expect(spyEvent).toHaveBeenPrevented()

          it 'triggers click event on save button', ->
            spyEvent = spyOnEvent(@$editButton, 'click')
            @$form.submit()
            expect('click').toHaveBeenTriggeredOn(@$editButton)
            expect(spyEvent).toHaveBeenTriggered()

        describe "after a successful save", ->
          beforeEach ->
            @view = new App.ThreadView(model: @thread)
            @view.render()
            @$editButton = @view.$("span[data-attribute='#{@attr}'] ~ button.edit-button")
            @$editableField = @view.$("span[data-attribute='#{@attr}']")
            @$editButton.trigger('click')
            @server = sinon.fakeServer.create()
            @server.respondWith(
              'PUT',
              '/en/threads/123',
              [ 204, {'Content-Type': 'application/json'}, "" ]
            )

          afterEach ->
            @server.restore()

          it "changes the save button back to an edit button", ->
            @$editButton.trigger('click')
            @server.respond()

            expect(@$editButton).toHaveClass('edit-button')
            expect(@$editButton).not.toHaveClass('save-button')
            expect(@$editButton).toHaveText('Edit')

          it "changes the input field to text with the new attribute value", ->
            @view.$("#{@type}[name='#{@attr}']").val("abcdefg")
            @$editButton.trigger('click')
            @server.respond()

            expect(@$editableField).toHaveText("abcdefg")

    describe "title", ->
      sharedContext =
        attr: 'title'
        type: 'input'
      sharedExamplesForEditableFields(sharedContext)

    describe "summary", ->
      sharedContext =
        attr: 'summary'
        type: 'textarea'
      sharedExamplesForEditableFields(sharedContext)
