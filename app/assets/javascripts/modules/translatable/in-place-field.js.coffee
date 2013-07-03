define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/view',
  'modules/translatable/field-form'
  'i18n'
  'bootstrap-popover'
], ($, _, Backbone, BaseView, FieldForm, I18n) ->

  class InPlaceField extends BaseView
    tagName: "span"
    className: "in-place-field"
    template: _.template '
      <span class="<%= status + (editable ? " editable" : "") %>">
        <%= fieldText %>
      </span>'

    buildEvents: () ->
      _(super).extend
        "click span.editable": "showForm"

    initialize: (options) ->
      super(options)

      @field = options.field
      @model = options.model
      @editable = options.editable
      @schema = () -> @model.schema()[@field]
      @type = @schema().type
      @FieldForm = options.FieldForm || FieldForm

    render: ->
      fieldVal = @model.getAttr(@field)
      @renderField(fieldVal)

    renderField: (fieldVal) ->
      editable = @editable
      if fieldVal
        fieldText = fieldVal
        status = "translated"
      else
        fieldText = @model.getAttrInSourceLocale(@field)
        status = "untranslated"
      fieldHtml = @template
        status: status
        fieldText: fieldText
        editable: editable
      @$el.html(fieldHtml)

    showForm: ->
      form = new @FieldForm(model: @model, field: @field, type: @type)
      @renderChild(form)
      @$el.html(form.el)
      if I18n.locale != @model.getSourceLocale()
        @showPopover()

    showPopover: ->
      if (source_text = @model.getAttrInSourceLocale(@field))
       @$('.editable-input')
          .popover
            content: source_text
            placement: 'top'
            trigger: 'manual'
          .popover('show')
