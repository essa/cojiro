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
      fieldSelector = (attr) -> "span[data-attribute='#{attr}']"
      editButtonSelector = (attr) -> fieldSelector(attr) + ' ~ button.edit-button'
      formSelector = (attr) -> fieldSelector(attr) + ' form'

      describe "shared behaviour for editable fields", ->
        beforeEach ->
          @attr = context.attr
          @type = context.type || 'input'
          @thread = new App.Thread(_(context.thread || @fixtures.Thread.valid).extend(id: "123"))
          @collection =
            url: '/en/threads'
            add: ->
          @thread.collection = @collection

        describe "when edit button handler is fired", ->
          beforeEach ->
            @showEditableFieldSpy = sinon.spy(App.ThreadView.prototype, 'showEditableField')
            @view = new App.ThreadView(model: @thread)
            @view.render()
            @$editButton = @view.$(editButtonSelector(@attr))

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
            @$editButton = @view.$(editButtonSelector(@attr))
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
            @$editButton = @view.$(editButtonSelector(@attr))
            @$editButton.trigger('click')
            sinon.stub(@thread, 'save').returns(null)
            @$form = @view.$(formSelector(@attr))

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
            @$editButton = @view.$(editButtonSelector(@attr))
            @originalText = @view.$(fieldSelector(@attr)).text()
            @$editButton.trigger('click')
            @server = sinon.fakeServer.create()
            @server.respondWith(
              'PUT',
              '/en/threads/123',
              [ 204, {'Content-Type': 'application/json'}, "" ]
            )

          afterEach ->
            @server.restore()

          it "changes the save button back to an edit button if field has content, and to an add button otherwise", ->
            @$editButton.trigger('click')
            @server.respond()

            @$editButton = @view.$(editButtonSelector(@attr))
            expect(@$editButton).toHaveClass('edit-button')
            expect(@$editButton).not.toHaveClass('save-button')
            if @thread.get(@attr)
              expect(@$editButton).toHaveText('Edit')
            else
              expect(@$editButton).toHaveText('Add English')

          it "if value is changed, replaces form with text with new attribute value and \"translated\" class", ->
            @view.$("#{@type}[name='#{@attr}']").val("abcdefg")
            @$editButton.trigger('click')
            @server.respond()

            @$editableField = @view.$(fieldSelector(@attr))
            expect(@$editableField).toHaveText("abcdefg")
            expect(@$editableField).toHaveClass("translated")

          it "if value is unchanged, replaces form with original text", ->
            @$editButton.trigger('click')
            @server.respond()

            @$editableField = @view.$(fieldSelector(@attr))
            expect(@$editableField).toHaveText(@originalText)
            expect(@$editableField).not.toContain('form')

    describe "title", ->
      sharedContext =
        attr: 'title'
        type: 'input'

      describe "for a thread in my locale", ->
        sharedExamplesForEditableFields(sharedContext)

      describe "for a thread in another locale", ->
        beforeEach ->
          sharedContext.thread = @fixtures.Thread.valid_in_ja

        sharedExamplesForEditableFields(sharedContext)

    describe "summary", ->
      sharedContext =
        attr: 'summary'
        type: 'textarea'

      describe "for a thread in my locale", ->
        sharedExamplesForEditableFields(sharedContext)

      describe "for a thread in another locale", ->
        beforeEach ->
          sharedContext.thread = @fixtures.Thread.valid_in_ja

        sharedExamplesForEditableFields(sharedContext)
