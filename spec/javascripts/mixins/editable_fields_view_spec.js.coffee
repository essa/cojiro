describe "App.EditableFieldsView", ->

  sharedExamplesForEditableFields = (context) ->

    # selectors for editable field elements
    parentSelector = (attr) -> ".editable-field-parent[data-attribute='#{attr}']"
    fieldSelector = (attr) -> parentSelector(attr) + " .editable-field"
    editButtonSelector = (attr) -> parentSelector(attr) + " button.edit-button"
    saveButtonSelector = (attr) -> parentSelector(attr) + " button.save-button"
    cancelButtonSelector = (attr) -> parentSelector(attr) + ' button ~ button.cancel-button'
    formSelector = (attr) -> fieldSelector(attr) + ' form'

    # for finding editable field elements in the view
    findParent = (view, attr) -> view.$(parentSelector(attr))
    findField = (view, attr) -> view.$(fieldSelector(attr))
    findEditButton = (view, attr) -> view.$(editButtonSelector(attr))
    findCancelButton = (view, attr) -> view.$(cancelButtonSelector(attr))
    findForm = (view, attr) -> view.$(formSelector(attr))

    describe "shared behaviour for editable fields", ->
      beforeEach ->
        App.currentUser = @fixtures.User.valid
        @attr = context.attr
        @type = context.type || 'input'
        @model = new App.EditableFieldsModel
        _(@model).extend
          id: "123"
          schema: ->
            title:
              type: 'Text'
            summary:
              type: 'TextArea'
        @model.collection = new Backbone.Collection
        @model.collection.url = -> '/en/models'

        @showEditableFieldSpy = sinon.spy(App.EditableFieldsView.prototype, 'showEditableField')
        @submitEditableFieldFormSpy = sinon.spy(App.EditableFieldsView.prototype, 'submitEditableFieldForm')
        @saveEditableFieldSpy = sinon.spy(App.EditableFieldsView.prototype, 'saveEditableField')
        @revertEditableFieldSpy = sinon.spy(App.EditableFieldsView.prototype, 'revertEditableField')
        @view = new App.EditableFieldsView(model: @model)
        @view.render = ->
          @$el.append(JST['shared/_editable_field'](model: @model, attr_name: context.attr))
        @view.render()
        @$editButton = findEditButton(@view, @attr)

      afterEach ->
        App.currentUser = null
        App.EditableFieldsView.prototype.showEditableField.restore()
        App.EditableFieldsView.prototype.submitEditableFieldForm.restore()
        App.EditableFieldsView.prototype.saveEditableField.restore()
        App.EditableFieldsView.prototype.revertEditableField.restore()

      describe "when edit button handler is fired", ->

        it 'calls showEditableField', ->
          @$editButton.trigger('click')
          expect(@showEditableFieldSpy).toHaveBeenCalledOnce()

        it 'changes the edit button into a save button', ->
          @$editButton.trigger('click')
          expect(@$editButton).toHaveClass('save-button')
          expect(@$editButton).not.toHaveClass('edit-button')
          expect(@$editButton).toHaveText('Save')

        it 'inserts a cancel button after the save button', ->
          @$editButton.trigger('click')
          $cancelButton = findCancelButton(@view, @attr)
          expect($cancelButton).toBe('button')
          expect($cancelButton).toHaveClass('cancel-button')
          expect($cancelButton).toHaveText('Cancel')

        it "uses existing form if @forms[\"#{context.attr}\"] already exists", ->
          form =
            render: -> @
          @view.forms = {}
          @view.forms[@attr] = form
          sinon.spy(Backbone, 'Form')
          sinon.spy(form, 'render')
          @$editButton.trigger('click')

          expect(Backbone.Form).not.toHaveBeenCalled()
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
          expect(Backbone.Form).toHaveBeenCalledWith(model: @model, fields: [ @attr ], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
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
          @$editButton.trigger('click')
          sinon.stub(@model, 'save').returns(null)

        afterEach ->
          @model.save.restore()

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

          expect(@model.save).toHaveBeenCalledOnce()

          @view.forms[@attr].commit.restore()

      describe "when editable field is submitted (e.g. by hitting enter while in form field)", ->
        beforeEach ->
          @$editButton.trigger('click')
          sinon.stub(@model, 'save').returns(null)
          @$form = findForm(@view, @attr)

        afterEach ->
          @model.save.restore()

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

      describe "when cancel button is fired", ->
        beforeEach ->
          @originalFieldText = findField(@view, @attr).text().trim()
          @$editButton.trigger('click')
          @$cancelButton = findCancelButton(@view, @attr)

        it 'calls revertEditableField', ->
          @$cancelButton.trigger('click')
          expect(@revertEditableFieldSpy).toHaveBeenCalledOnce()

        it 'removes save and cancel buttons', ->
          @$cancelButton.trigger('click')

          expect(@view.$('button.cancel-button').length).toEqual(0)
          expect(@view.$('button.save-button').length).toEqual(0)

        it 'replaces form with original text', ->
          @view.$("#{@type}[name='#{@attr}']").val("abcdefg")
          @$cancelButton.trigger('click')

          @$editableField = findField(@view, @attr)
          expect(@$editableField).not.toContain('form')
          expect(@$editableField).toHaveText(@originalFieldText)

      describe "after a successful save", ->
        beforeEach ->
          @originalButtonText = @$editButton.text().trim()
          @originalFieldText = findField(@view, @attr).text().trim()
          @$editButton.trigger('click')
          @server = sinon.fakeServer.create()
          @server.respondWith(
            'PUT',
            '/en/models/123',
            [ 204, {'Content-Type': 'application/json'}, "" ]
          )

        afterEach ->
          @server.restore()

        it "changes the button text back to its original value (\"Edit\" or \"Add Engish\")", ->
          @$editButton.trigger('click')
          @server.respond()

          @$editButton = findEditButton(@view, @attr)
          expect(@$editButton).toHaveClass('edit-button')
          expect(@$editButton).not.toHaveClass('save-button')
          expect(@$editButton).toHaveText(@originalButtonText)

        it "removes the cancel button", ->
          $cancelButton = findCancelButton(@view, @attr)
          @$editButton.trigger('click')
          @server.respond()

          expect($('button.cancel-button').length).toEqual(0)

        it "if value is changed, replaces form with text with new attribute value and \"translated\" class", ->
          @view.$("#{@type}[name='#{@attr}']").val("abcdefg")
          @$editButton.trigger('click')
          @server.respond()

          @$editableField = findField(@view, @attr)
          expect(@$editableField).toHaveText("abcdefg")
          expect(@$editableField).toHaveClass("translated")

        it "if value is unchanged, replaces form with original text", ->
          @$editButton.trigger('click')
          @server.respond()

          @$editableField = findField(@view, @attr)
          expect(@$editableField).toHaveText(@originalFieldText)
          expect(@$editableField).not.toContain('form')

  model_in_my_locale =
    title: "Co-working spaces in Tokyo"
    summary: "a summary"

  model_in_another_locale =
    title_in_source_locale: "東京のコワーキングスペース"
    summary_in_source_locale: "東京のコワーキングスペースについてブログを書こうかと思います。"

  describe "text input", ->
    sharedContext =
      attr: 'title'
      type: 'input'

    describe "for a model in my locale", ->
      beforeEach -> sharedContext.model = model_in_my_locale
      sharedExamplesForEditableFields(sharedContext)

    describe "for a model in another locale", ->
      beforeEach -> sharedContext.model = model_in_another_locale
      sharedExamplesForEditableFields(sharedContext)

  describe "textarea", ->
    sharedContext =
      attr: 'summary'
      type: 'textarea'

    describe "for a model in my locale", ->
      beforeEach -> sharedContext.model = model_in_my_locale
      sharedExamplesForEditableFields(sharedContext)

    describe "for a model in another locale", ->
      beforeEach -> sharedContext.model = model_in_another_locale
      sharedExamplesForEditableFields(sharedContext)
