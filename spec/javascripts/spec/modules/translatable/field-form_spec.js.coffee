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
      @submitFormSpy = sinon.spy(FieldForm.prototype, 'submitForm')
      @closeFormSpy = sinon.spy(FieldForm.prototype, 'closeForm')

    afterEach ->
      FieldForm.prototype.saveField.restore()
      FieldForm.prototype.submitForm.restore()
      FieldForm.prototype.closeForm.restore()

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
          @$saveButton = @view.$('button.save-button')

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
        channel.on('fieldForm:close', eventSpy)
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
