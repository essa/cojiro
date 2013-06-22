define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base',
  'modules/translatable/templates/_in-place-field-form',
  'i18n'
], ($, _, Backbone, Base, formTemplate, I18n) ->

  class InPlaceField extends Base.View
    tagName: "span"
    className: "in-place-field"
    fieldTemplate: _.template('<span class="<%= status %>"><%= fieldText %></span>')
    buttonTemplate: _.template('<button class="edit-button btn btn-mini"><%= button_text %></button>')

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
      fieldVal = @model.getAttr(@field)
      @renderField(fieldVal)
      @renderButton(fieldVal) if @editable

    renderField: (fieldVal) ->
      if fieldVal
        fieldText = fieldVal
        status = "translated"
      else
        fieldText = @model.getAttrInSourceLocale(@field)
        status = "untranslated"
      @$el.html(@fieldTemplate(status: status, fieldText: fieldText))

    renderButton: (fieldVal) ->
      button_text = if !!fieldVal then I18n.t("templates.threads.show.edit") else I18n.t("templates.threads.show.add_in", lang: I18n.t(I18n.locale))
      @$el.append(@buttonTemplate(button_text: button_text))

    showForm: ->
      @$el.html(formTemplate(model: @model, field: @field, schema: @schema()))
      @$('.field').val(@model.getAttr(@field))

    submitForm: (e) ->
      e.preventDefault()
      @$('button.save-button').trigger('click')

    saveField: ->
      @model.setAttr(@field, @$('.field').val())
      self = @
      @model.save {},
        success: (model, resp) ->
          self.render()
