define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')

  InPlaceField = require('modules/translatable/in-place-field')
  Model = require('modules/translatable/model')
  MyModel = Model.extend(translatableAttributes: ['title', 'summary'])
  require('jquery')

  describe 'Translatable.InPlaceField', ->

    beforeEach ->
      I18n.locale = 'en'

    afterEach ->
      I18n.locale = I18n.defaultLocale

    sharedExamplesForInPlaceFields = (context) ->

      describe 'shared behaviour for translatable fields', ->
        beforeEach ->
          @field = context.field
          @type = context.type || 'input'
          @model = new MyModel
          _(@model).extend
            id: '123'
            schema: ->
              title:
                type: 'Text'
              summary:
                type: 'TextArea'
          @model.set(context.model)
          @model.collection = new Backbone.Collection
          @model.collection.url = -> '/en/models'

          @showFormSpy = sinon.spy(InPlaceField.prototype, 'showForm')
          @submitFormSpy = sinon.spy(InPlaceField.prototype, 'submitForm')
          @saveFieldSpy = sinon.spy(InPlaceField.prototype, 'saveField')
          @renderSpy = sinon.spy(InPlaceField.prototype, 'render')
          @view = new InPlaceField(model: @model, field: @field, editable: true)
          @view.render()
          @editButtonSelector = '.edit-button'
          @saveButtonSelector = '.save-button'
          @cancelButtonSelector = '.cancel-button'
          @$editButton = @view.$(@editButtonSelector)
          @originalFieldText = @view.$el.text().trim()

        afterEach ->
          InPlaceField.prototype.showForm.restore()
          InPlaceField.prototype.submitForm.restore()
          InPlaceField.prototype.saveField.restore()
          InPlaceField.prototype.render.restore()

        describe 'before edit button handler is fired', ->
          it 'has field value wrapped in correct tag', ->
            if @model.getAttr(@field) is undefined
              expect(@view.$('span.untranslated')).toHaveText(@model.getAttrInSourceLocale(@field))
            else
              expect(@view.$('span.translated')).toHaveText(@model.getAttr(@field))

          it 'has correct edit/save button text', ->
            if @model.getAttr(@field) is undefined
              expect(@view.$('button.edit-button')).toHaveText('Add English')
            else
              expect(@view.$('button.edit-button')).toHaveText('Edit')

        describe 'when edit button handler is fired', ->
          beforeEach ->
            @$editButton.trigger('click')

          it 'calls showForm', ->
            expect(@showFormSpy).toHaveBeenCalledOnce()

          it 'renders save button', ->
            expect(@view.$el).toContain('.save-button')
            expect(@view.$('.save-button')).toHaveText('Save')

          it 'renders cancel button', ->
            expect(@view.$el).toContain('.cancel-button')
            expect(@view.$('.cancel-button')).toHaveText('Cancel')

          it 'removes edit button', ->
            expect(@view.$el).not.toContain('.edit-button')

          it 'renders form field', ->
            expect(@view.$el).toContain("#{@type}[name='#{@field}']")

        describe 'when save button is fired', ->
          beforeEach ->
            @$editButton.trigger('click')
            sinon.stub(@model, 'setAttr').returns(null)
            sinon.stub(@model, 'save').returns(null)

          afterEach ->
            @model.save.restore()

          it 'calls saveField', ->
            @view.$(@saveButtonSelector).trigger('click')
            expect(@saveFieldSpy).toHaveBeenCalledOnce()

          it 'sets the field', ->
            @view.$(@type).val('abcdef')
            @view.$(@saveButtonSelector).trigger('click')
            expect(@model.setAttr).toHaveBeenCalledOnce()
            expect(@model.setAttr).toHaveBeenCalledWith(@field, 'abcdef')

          it 'saves the model', ->
            @view.$(@type).val('a new value')
            @view.$(@saveButtonSelector).trigger('click')
            expect(@model.save).toHaveBeenCalledOnce()

        describe 'when translatable field is submitted (e.g. by hitting enter while in form field)', ->
          beforeEach ->
            @$editButton.trigger('click')
            sinon.stub(@model, 'save').returns(null)
            @$form = @view.$('form')
            @$saveButton = @view.$(@saveButtonSelector)

          afterEach ->
            @model.save.restore()

          it 'calls submitForm', ->
            @$form.submit()
            expect(@submitFormSpy).toHaveBeenCalledOnce()

          it 'prevents default form submission', ->
            spyEvent = spyOnEvent(@$form, 'submit')
            @$form.submit()
            expect('submit').toHaveBeenPreventedOn(@$form)
            expect(spyEvent).toHaveBeenPrevented()

          it 'triggers click event on save button', ->
            spyEvent = spyOnEvent(@$saveButton, 'click')
            @$form.submit()
            expect('click').toHaveBeenTriggeredOn(@$saveButton)
            expect(spyEvent).toHaveBeenTriggered()

        describe 'when cancel button is fired', ->
          beforeEach ->
            @$editButton.trigger('click')
            @$cancelButton = @view.$(@cancelButtonSelector)

          it 'calls render', ->
            # called twice, once when it first renders the field, and once when it re-renders it
            @$cancelButton.trigger('click')
            expect(@renderSpy).toHaveBeenCalledTwice()

          it 'removes save and cancel buttons', ->
            @$cancelButton.trigger('click')
            expect(@view.$el).not.toContain('.cancel-button')
            expect(@view.$el).not.toContain('.save-button')

          it 'replaces form with original text', ->
            @view.$(@type).val('abcdefg')
            @$cancelButton.trigger('click')

            expect(@view.$el).not.toContain('form')
            expect(@view.$el).toHaveText(@originalFieldText)

        describe 'after a successful save', ->
          beforeEach ->
            @originalButtonText = @$editButton.text().trim()
            @$editButton.trigger('click')
            @server = sinon.fakeServer.create()
            @server.respondWith(
              'PUT',
              '/en/models/123',
              [ 204, {'Content-Type': 'application/json'}, '' ]
            )

          afterEach ->
            @server.restore()

          it 'changes the button text back to its original value ("Edit" or "Add Engish")', ->
            @view.$(@saveButtonSelector).trigger('click')
            @server.respond()
            expect(@view.$el).toContain(@editButtonSelector)
            expect(@view.$el).not.toContain(@saveButtonSelector)
            expect(@view.$('.edit-button')).toHaveText(@originalButtonText)

          it 'removes cancel button', ->
            @view.$(@saveButtonSelector).trigger('click')
            @server.respond()
            expect(@view.$el).not.toContain(@cancelButtonSelector)

          it 'if value is changed, replaces form with text with new attribute value and "translated" class', ->
            @view.$(@type).val('abcdefg')
            @view.$(@saveButtonSelector).trigger('click')
            @server.respond()
            expect(@view.$('.translated')).toHaveText('abcdefg')

    model_in_my_locale =
      source_locale: 'en'
      title:
        en: 'Co-working spaces in Tokyo'
      summary:
        en: 'a summary'

    model_in_another_locale =
      source_locale: 'ja'
      title:
        ja: '東京のコワーキングスペース'
      summary:
        ja: '東京のコワーキングスペースについてブログを書こうかと思います。'

    describe 'text input', ->
      sharedContext =
        field: 'title'
        type: 'input'

      describe 'for a model in my locale', ->
        beforeEach -> sharedContext.model = model_in_my_locale
        sharedExamplesForInPlaceFields(sharedContext)

      describe 'for a model in another locale', ->
        beforeEach -> sharedContext.model = model_in_another_locale
        sharedExamplesForInPlaceFields(sharedContext)

    describe 'textarea', ->
      sharedContext =
        field: 'summary'
        type: 'textarea'

      describe 'for a model in my locale', ->
        beforeEach -> sharedContext.model = model_in_my_locale
        sharedExamplesForInPlaceFields(sharedContext)

      describe 'for a model in another locale', ->
        beforeEach -> sharedContext.model = model_in_another_locale
        sharedExamplesForInPlaceFields(sharedContext)
