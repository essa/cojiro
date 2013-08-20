define (require) ->

  $ = require('jquery')
  _ = require('underscore')
  Backbone = require('backbone')
  I18n = require('i18n')
  InPlaceField = require('modules/translatable/in-place-field')
  FieldForm = require('modules/translatable/field-form')
  Model = require('modules/translatable/model')
  channel = require('modules/channel')
  MyModel = Model.extend(translatableAttributes: ['title'])

  describe 'Translatable.InPlaceField', ->
    beforeEach -> I18n.locale = 'en'

    describe 'with stubbed FieldForm', ->
      beforeEach ->
        # create stub child view
        @fieldForm = new Backbone.View()
        @fieldForm.render = () ->
          @el = $('<div>')
          @el.append($('<form>').addClass('in-place-form').append($('<div>').addClass('editable-input')))
          @
        @FieldForm = sinon.stub().returns(@fieldForm)

        @field = 'title'
        @model = new MyModel
        _(@model).extend
          id: '123'
          schema: -> title: type: 'Text'
        @model.set
          source_locale: 'en'
          title: en: 'Co-working spaces in Tokyo'

        @showFormSpy = sinon.spy(InPlaceField.prototype, 'showForm')

        @view = new InPlaceField
          model: @model
          field: @field
          editable: true
          FieldForm: @FieldForm

      afterEach ->
        InPlaceField.prototype.showForm.restore()

      describe 'initialization', ->
        beforeEach ->
          @options =
            field: 'title'
            model: @model

        it 'throws no error if passed required options', ->
          options = @options
          expect(-> new InPlaceField(options)).not.toThrow()

        it 'throws error if not passed field', ->
          options = _(@options).extend(field: null)
          expect(-> new InPlaceField(options)).toThrow("field required")

        it 'throws error if not passed model', ->
          options = _(@options).extend(model: null)
          expect(-> new InPlaceField(options)).toThrow("model required")

        it 'throws error if model does not have schema', ->
          options = _(@options).extend(model: {})
          expect(-> new InPlaceField(options)).toThrow('model schema must be defined')

        it 'throws error if model schema is not a function', ->
          options = _(@options).extend(model: schema: {})
          expect(-> new InPlaceField(options)).toThrow('model schema must be a function')

        it 'throws error if model schema does not have field as key', ->
          options = _(@options).extend(model: schema: -> {})
          expect(-> new InPlaceField(options)).toThrow('model schema must have field as key')

        it 'throws error if model schema does not have a type', ->
          options = _(@options).extend(model: schema: -> title: {})
          expect(-> new InPlaceField(options)).toThrow('model schema must have a type')

      describe 'rendering', ->
        it 'wraps field in span with translated class if field exists in this locale', ->
          I18n.locale = 'en'
          @view.render()
          expect(@view.$('span:contains("Co-working spaces in Tokyo")')).toHaveClass('translated')

        it 'wraps field in span with untranslated class if field does not exist in this locale', ->
          I18n.locale = 'fr'
          @view.render()
          expect(@view.$('span:contains("Co-working spaces in Tokyo")')).toHaveClass('untranslated')

      describe 'events', ->
        describe 'when editable handler is fired', ->
          beforeEach ->
            @view.render()
            @$clickableField = @view.$('span.editable')

          it 'calls showForm', ->
            @$clickableField.click()
            expect(@showFormSpy).toHaveBeenCalledOnce()

          it 'triggers open event after field is opened', ->
            eventSpy = sinon.spy()
            @view.on('open', eventSpy)
            @view.on 'open', (view) ->
              expect(view.$el).toContain('.editable-input')
            @$clickableField.click()
            expect(eventSpy).toHaveBeenCalledOnce()
            expect(eventSpy).toHaveBeenCalledWithExactly(@view)

          it 'creates a FieldForm', ->
            @$clickableField.click()
            expect(@FieldForm).toHaveBeenCalledOnce()
            expect(@FieldForm).toHaveBeenCalledWith
              model: @model
              field: @field
              type: @model.schema()[@field].type

          it 'renders a FieldForm', ->
            sinon.spy(@fieldForm, 'render')
            @$clickableField.click()
            expect(@fieldForm.render).toHaveBeenCalledOnce()
            @fieldForm.render.restore()

          it 'replaces field with form', ->
            originalFieldText = @view.$el.text().trim()
            @$clickableField.click()
            expect(@view.$el).toContain('form.in-place-form')
            expect(@view.$el).not.toHaveText(originalFieldText)

          describe 'popover with field in source locale', ->
            afterEach -> _.each $('body .popover'), (popover) -> $(popover).remove()

            it 'does not render popover if we\'re in the source locale', ->
              @$clickableField.click()
              expect(@view.$el).not.toContain('.popover')

            it 'renders popover if source locale is different from this one', ->
              I18n.locale = 'fr'
              @$clickableField.click()
              expect($('body')).toContain('.popover:contains("Co-working spaces in Tokyo")')

        describe 'when field form is closed', ->
          beforeEach ->
            @view.render()
            @$clickableField = @view.$('span.editable')

          it 're-renders field', ->
            @$clickableField.click()
            sinon.spy(@view, 'render')
            channel.trigger("fieldForm:#{@fieldForm.cid}:close")
            expect(@view.render).toHaveBeenCalledOnce()
            @view.render.restore()

          it 'triggers close event after field is closedd', ->
            eventSpy = sinon.spy()
            @view.on('close', eventSpy)
            @view.on 'close', (view) ->
              expect(view.$el).not.toContain('.editable-input')
              expect(view.$el).toContainText('Co-working spaces in Tokyo')
            @$clickableField.click()
            channel.trigger("fieldForm:#{@fieldForm.cid}:close")
            expect(eventSpy).toHaveBeenCalledOnce()
            expect(eventSpy).toHaveBeenCalledWithExactly(@view)

    describe 'with real FieldForm', ->
      beforeEach ->
        @field = 'title'
        @model = new MyModel
        _(@model).extend
          id: '123'
          schema: -> title: type: 'Text'
        @model.collection = url: '/collection'
        @model.set
          source_locale: 'en'
          title: en: 'Co-working spaces in Tokyo'
        @view = new InPlaceField model: @model, field: @field, editable: true

        @server = sinon.fakeServer.create()
        @server.respondWith(
          'PUT',
          '/collection/123',
          [ 204, {'Content-Type': 'application/json'}, '' ]
        )

      describe 'successful save', ->
        beforeEach ->
          @view.render()
          @view.$('span.editable').click()
          @view.$('input').val('abcdef')
          @view.$('button.save-button').click()
          @server.respond()

        it 'saves new value to model', ->
          expect(@model.getAttr(@field)).toEqual('abcdef')

        it 'renders new field value', ->
          expect(@view.$el).toHaveText('abcdef')

      describe 'cancelled save', ->
        beforeEach ->
          @view.render()
          @view.$('span.editable').click()
          @view.$('input').val('abcdef')
          @view.$('button.cancel-button').click()

        it 'resets field to original value', ->
          expect(@view.$el).toHaveText('Co-working spaces in Tokyo')

        it 'does not change value in model', ->
          expect(@model.getAttr(@field)).toEqual('Co-working spaces in Tokyo')
