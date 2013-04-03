define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base',
  'modules/translatable/templates/_field',
  'modules/translatable/templates/_form',
  'i18n'
], ($, _, Backbone, Base, fieldTemplate, formTemplate, I18n) ->

  class TranslatableField extends Base.View
    tagName: "span"
    className: "translatable-field"

    buildEvents: () ->
      _(super).extend
        "click button.edit-button": "showForm"
        "click button.save-button": "saveField"
        "submit form.in-place-form": "submitForm"
        "click button.cancel-button": "render"

    initialize: (options) ->
      super

      @field = options['field']
      @model = options['model']
      @editable = options['editable']
      @schema = () -> @model.schema()[@field]

    render: ->
      @$el.html(fieldTemplate(model: @model, field: @field, editable: @editable))

    showForm: (e) ->
      @$el.html(formTemplate(model: @model, field: @field, schema: @schema()))
      @$('.field').val(@model.get(@field))

    submitForm: (e) ->
      e.preventDefault()
      @$('button.save-button').trigger('click')

    saveField: (e) ->
      @model.set(@field, @$('.field').val())
      self = @
      @model.save {},
        success: (model, resp) ->
          self.render()
