define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/translatable/field-form'
  'modules/channel'
  'i18n'
  'bootstrap-popover'
], ($, _, Backbone, BaseView, FieldForm, channel, I18n) ->

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

    initialize: (options = {}) ->
      super(options)

      throw('field required') unless @field = options.field
      throw('model required') unless @model = options.model
      @editable = options.editable || false
      throw('model schema must be defined') unless @model.schema
      throw('model schema must be a function') unless _.isFunction(@model.schema)
      @schema = () -> @model.schema()[@field]
      throw('model schema must have field as key') unless @schema()
      throw('model schema must have a type') unless @type = @schema().type
      @FieldForm = options.FieldForm || FieldForm

    render: ->
      @destroyPopover()
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
      channel.unbind("fieldForm:#{@form.cid}:close") if @form
      @form = new @FieldForm(model: @model, field: @field, type: @type)
      self = @
      channel.on "fieldForm:#{@form.cid}:close", -> self.render()
      @renderChild(@form)
      @$el.html(@form.el)
      if I18n.locale != @model.getSourceLocale()
        @showPopover()

    showPopover: ->
      if (source_text = @model.getAttrInSourceLocale(@field))
       @$('.editable-input')
          .popover
            content: source_text
            placement: 'top'
            trigger: 'manual'
            container: 'body'
          .popover('show')

    destroyPopover: ->
      @$('.editable-input').popover('destroy')
