define (require) ->

  $ = require('jquery')
  _ = require('underscore')
  Backbone = require('backbone')
  I18n = require('i18n')
  FieldForm = require('modules/translatable/field-form')
  BaseView = require('modules/base/view')
  Model = require('modules/translatable/model')
  channel = require('modules/channel')
  MyModel = Model.extend(translatableAttributes: ['title', 'summary'])

  describe 'Translatable.FieldForm', ->
    beforeEach ->
      I18n.locale = 'en'

      @model = new MyModel
      _(@model).extend
        id: '123'
        schema: ->
          title:
            type: 'Text'
          summary:
            type: 'TextArea'
      @model.set
        source_locale: 'en'
        title: en: 'Co-working spaces in Tokyo'
        summary: en: 'a summary'
      @model.collection = url: '/collection'

      @saveFieldSpy = sinon.spy(FieldForm.prototype, 'saveField')
      @closeFormSpy = sinon.spy(FieldForm.prototype, 'closeForm')

    afterEach ->
      FieldForm.prototype.saveField.restore()
      FieldForm.prototype.closeForm.restore()

    describe 'instantiation', ->
      beforeEach ->
        @options =
          field: 'title'
          model: @model
          type: 'Text'

      it 'throws no error if passed required options', ->
        options = @options
        expect(-> new FieldForm(options)).not.toThrow()

      it 'throws error if not passed field', ->
        options = _(@options).extend(field: null)
        expect(-> new FieldForm(options)).toThrow("field required")

      it 'throws error if not passed model', ->
        options = _(@options).extend(model: null)
        expect(-> new FieldForm(options)).toThrow("model required")

      it 'throws error if not passed type', ->
        options = _(@options).extend(type: null)
        expect(-> new FieldForm(options)).toThrow("type required")

    describe 'rendering', ->

      describe 'html elements', ->
        beforeEach ->
          # we're not testing this here, but need it for view to properly render
          @view = new FieldForm model: @model, field: 'title', type: 'Text'
          @view.render()

        it 'renders div with editable-input class', ->
          expect(@view.$el).toContain('.editable-input')

        it 'renders submit button', ->
          expect(@view.$el).toContain('button.save-button')

        it 'renders submit button icon', ->
          expect(@view.$('button.save-button')).toContain('icon.icon-ok')

        it 'renders cancel button', ->
          expect(@view.$el).toContain('button.cancel-button')

        it 'renders cancel button icon', ->
          expect(@view.$('button.cancel-button')).toContain('icon.icon-remove')

      describe 'text field form elements', ->
        beforeEach ->
          @view = new FieldForm model: @model, field: 'title', type: 'Text'
          @view.render()

        it 'renders input element with text type in div with editable-input class', ->
          expect(@view.$('.editable-input')).toContain('input.field[type="text"]')

        it 'sets current value of field', ->
          expect(@view.$('input').val()).toEqual('Co-working spaces in Tokyo')

      describe 'textarea field form elements', ->
        beforeEach ->
          @view = new FieldForm model: @model, field: 'summary', type: 'TextArea'
          @view.render()

        it 'renders textarea element with text type in div with editable-input class', ->
          expect(@view.$('.editable-input')).toContain('textarea.field[type="text"]')

        it 'sets current value of field', ->
          expect(@view.$('textarea').val()).toEqual('a summary')

    describe 'saving the field', ->
      beforeEach ->
        @view = new FieldForm model: @model, field: 'title', type: 'Text'
        # prevent actual server requests
        sinon.stub(@model, 'save').returns(null)
        @view.render()

      afterEach ->
        @model.save.restore()

      describe 'when save button is clicked', ->

        it 'calls saveField', ->
          @view.$('button.save-button').click()
          expect(@saveFieldSpy).toHaveBeenCalledOnce()

        it 'sets the field in the current locale', ->
          sinon.stub(@model, 'setAttr')
          @view.$('input').val('abcdef')
          @view.$('button.save-button').click()
          expect(@model.setAttr).toHaveBeenCalledOnce()
          expect(@model.setAttr).toHaveBeenCalledWithExactly('title', 'abcdef')
          @model.setAttr.restore()

        it 'saves the model', ->
          @view.$('input').val('a new value')
          @view.$('button.save-button').click()
          expect(@model.save).toHaveBeenCalledOnce()

      describe 'when form is submitted (by hitting enter while in form field)', ->
        beforeEach ->
          @$form = @view.$('form')

        it 'calls saveField', ->
          @$form.submit()
          expect(@saveFieldSpy).toHaveBeenCalledOnce()

        it 'sets the field in the current locale', ->
          sinon.stub(@model, 'setAttr')
          @view.$('input').val('abcdef')
          @$form.submit()
          expect(@model.setAttr).toHaveBeenCalledOnce()
          expect(@model.setAttr).toHaveBeenCalledWithExactly('title', 'abcdef')
          @model.setAttr.restore()

        it 'saves the model', ->
          @view.$('input').val('a new value')
          @$form.submit()
          expect(@model.save).toHaveBeenCalledOnce()

    describe 'when cancel button is clicked', ->
      beforeEach ->
        @view = new FieldForm model: @model, field: 'title', type: 'Text'
        @view.render()

      it 'calls closeForm', ->
        @view.$('button.cancel-button').click()
        expect(@closeFormSpy).toHaveBeenCalledOnce()

      it 'calls leave to unbind events and remove from document', ->
        sinon.spy(@view, 'leave')
        @view.$('button.cancel-button').click()
        expect(@view.leave).toHaveBeenCalled()
        expect(@view.leave).toHaveBeenCalledWithExactly()
        @view.leave.restore()

      it 'triggers fieldForm.close event on channel', ->
        eventSpy = sinon.spy()
        @view.cid = '123'
        channel.on('fieldForm:123:close', eventSpy)
        @view.$('button.cancel-button').click()
        expect(eventSpy).toHaveBeenCalledOnce()

    describe 'after a successful save', ->
      beforeEach ->
        @view = new FieldForm model: @model, field: 'title', type: 'Text'
        @view.render()

        @server = sinon.fakeServer.create()
        @server.respondWith(
          'PUT',
          '/collection/123',
          [ 204, {'Content-Type': 'application/json'}, '' ]
        )

      afterEach ->
        @server.restore()

      it 'destroys popover', ->
        @view.$('.editable-input')
          .popover(content: 'dummy text', trigger: 'manual')
          .popover('show')
        @view.$('button.save-button').click()
        @server.respond()
        expect(@view.$el).not.toContain('.popover')

      it 'calls closeForm', ->
        @view.$('button.save-button').click()
        @server.respond()
        expect(@closeFormSpy).toHaveBeenCalledOnce()
