define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/view',
  'i18n'
], ($, _, Backbone, BaseView, I18n) ->

  class InPlaceField extends BaseView
    tagName: "span"
    className: "in-place-field"
    fieldTemplate: _.template('<span class="<%= status %>"><%= fieldText %></span>')
    buttonTemplate: _.template('<button class="edit-button btn btn-mini"><%= button_text %></button>')
    formTemplate: _.template '
      <form class="in-place-form form-inline">
        <fieldset class="in-place-form">
          <span class="input-small">
            <<%= (type == "Text") ? "input" : "textarea" %> name="<%= field %>" type="text" class="field" />
          </span>
        </fieldset>
      </form>
      <button class="save-button btn btn-mini"><%= save_text %></button>
      <button class="cancel-button btn btn-mini"><%= cancel_text %></button>'

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
      save_text = I18n.t('views.mixins.translatable_fields.save')
      cancel_text = I18n.t('views.mixins.translatable_fields.cancel')
      html = @formTemplate(field: @field, type: @schema().type, save_text: save_text, cancel_text: cancel_text)
      @$el.html(html)
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
