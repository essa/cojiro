define (require) ->

  Backbone = require('backbone')
  TranslatableView = require('modules/translatable/view')
  TranslatableModel = require('modules/translatable/model')
  translatableFieldTemplate = require('modules/translatable/templates/_translatable_field')
  globals = require('globals')
  require('jquery')
  I18n = require('i18n')

  describe "TranslatableView", ->
    
    beforeEach ->
      I18n.locale = 'en'

    afterEach ->
      I18n.locale = I18n.defaultLocale

    sharedExamplesForTranslatableFields = (context) ->

      # selectors for translatable field elements
      parentSelector = (attr) -> ".translatable-field-parent[data-attribute='#{attr}']"
      fieldSelector = (attr) -> parentSelector(attr) + " .translatable-field"
      editButtonSelector = (attr) -> parentSelector(attr) + " button.edit-button"
      saveButtonSelector = (attr) -> parentSelector(attr) + " button.save-button"
      cancelButtonSelector = (attr) -> parentSelector(attr) + ' button ~ button.cancel-button'
      formSelector = (attr) -> fieldSelector(attr) + ' form'

      # for finding translatable field elements in the view
      findParent = (view, attr) -> view.$(parentSelector(attr))
      findField = (view, attr) -> view.$(fieldSelector(attr))
      findEditButton = (view, attr) -> view.$(editButtonSelector(attr))
      findCancelButton = (view, attr) -> view.$(cancelButtonSelector(attr))
      findForm = (view, attr) -> view.$(formSelector(attr))

      describe "shared behaviour for translatable fields", ->
        beforeEach ->
          globals.currentUser = @fixtures.User.valid
          @attr = context.attr
          @type = context.type || 'input'
          @model = new TranslatableModel
          _(@model).extend
            id: "123"
            schema: ->
              title:
                type: 'Text'
              summary:
                type: 'TextArea'
          @model.collection = new Backbone.Collection
          @model.collection.url = -> '/en/models'

          @showTranslatableFieldSpy = sinon.spy(TranslatableView.prototype, 'showTranslatableField')
          @submitTranslatableFieldFormSpy = sinon.spy(TranslatableView.prototype, 'submitTranslatableFieldForm')
          @saveTranslatableFieldSpy = sinon.spy(TranslatableView.prototype, 'saveTranslatableField')
          @revertTranslatableFieldSpy = sinon.spy(TranslatableView.prototype, 'revertTranslatableField')
          @view = new TranslatableView(model: @model)
          @view.render = ->
            @$el.append(translatableFieldTemplate(model: @model, attr_name: context.attr))
          @view.render()
          @$editButton = findEditButton(@view, @attr)

        afterEach ->
          globals.currentUser = null
          TranslatableView.prototype.showTranslatableField.restore()
          TranslatableView.prototype.submitTranslatableFieldForm.restore()
          TranslatableView.prototype.saveTranslatableField.restore()
          TranslatableView.prototype.revertTranslatableField.restore()

        describe "when edit button handler is fired", ->

          it 'calls showTranslatableField', ->
            @$editButton.trigger('click')
            expect(@showTranslatableFieldSpy).toHaveBeenCalledOnce()

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

          it 'calls saveTranslatableField', ->
            @$editButton.trigger('click')
            expect(@saveTranslatableFieldSpy).toHaveBeenCalledOnce()

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

        describe "when translatable field is submitted (e.g. by hitting enter while in form field)", ->
          beforeEach ->
            @$editButton.trigger('click')
            sinon.stub(@model, 'save').returns(null)
            @$form = findForm(@view, @attr)

          afterEach ->
            @model.save.restore()

          it 'calls submitTranslatableFieldForm', ->
            @$form.submit()
            expect(@submitTranslatableFieldFormSpy).toHaveBeenCalledOnce()

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

          it 'calls revertTranslatableField', ->
            @$cancelButton.trigger('click')
            expect(@revertTranslatableFieldSpy).toHaveBeenCalledOnce()

          it 'removes save and cancel buttons', ->
            @$cancelButton.trigger('click')

            expect(@view.$('button.cancel-button').length).toEqual(0)
            expect(@view.$('button.save-button').length).toEqual(0)

          it 'replaces form with original text', ->
            @view.$("#{@type}[name='#{@attr}']").val("abcdefg")
            @$cancelButton.trigger('click')

            @$translatableField = findField(@view, @attr)
            expect(@$translatableField).not.toContain('form')
            expect(@$translatableField).toHaveText(@originalFieldText)

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

            @$translatableField = findField(@view, @attr)
            expect(@$translatableField).toHaveText("abcdefg")
            expect(@$translatableField).toHaveClass("translated")

          it "if value is unchanged, replaces form with original text", ->
            @$editButton.trigger('click')
            @server.respond()

            @$translatableField = findField(@view, @attr)
            expect(@$translatableField).toHaveText(@originalFieldText)
            expect(@$translatableField).not.toContain('form')

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
        sharedExamplesForTranslatableFields(sharedContext)

      describe "for a model in another locale", ->
        beforeEach -> sharedContext.model = model_in_another_locale
        sharedExamplesForTranslatableFields(sharedContext)

    describe "textarea", ->
      sharedContext =
        attr: 'summary'
        type: 'textarea'

      describe "for a model in my locale", ->
        beforeEach -> sharedContext.model = model_in_my_locale
        sharedExamplesForTranslatableFields(sharedContext)

      describe "for a model in another locale", ->
        beforeEach -> sharedContext.model = model_in_another_locale
        sharedExamplesForTranslatableFields(sharedContext)
