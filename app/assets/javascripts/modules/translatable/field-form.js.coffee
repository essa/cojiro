define [
  'jquery'
  'underscore',
  'backbone',
  'modules/base/view',
  'modules/channel'
  'i18n'
  'bootstrap-popover'
], ($, _, Backbone, BaseView, channel, I18n) ->

  class FieldForm extends BaseView
    template: _.template '
      <form class="in-place-form form-inline">
        <div class="control-group">
          <div class="editable-input">
            <span class="input-small">
              <<%= (type == "Text") ? "input" : "textarea" %> name="<%= field %>" type="text" class="field input-medium" />
            </span>
          </div>
        </div>
      </form>
      <button class="save-button btn btn-primary btn-small" type="submit">
        <icon class="icon-ok icon-white" />
      </button>
      <button class="cancel-button btn btn-small" type="cancel">
        <icon class="icon-remove" />
      </button>'

    buildEvents: () ->
      _(super).extend
        "click button.save-button": "saveField"
        "submit form.in-place-form": "submitForm"
        "click button.cancel-button": "closeForm"

    initialize: (options) ->
      super(options)

      @field = options.field
      @model = options.model
      @type = options.type

    render: ->
      @$el.html(@template(field: @field, type: @type))
      @renderVal()
      @

    renderVal: ->
      @$('.field').val(@model.getAttr(@field))

    submitForm: (e) ->
      e.preventDefault()
      @$('button.save-button').trigger('click')

    saveField: ->
      @model.setAttr(@field, @$('.field').val())
      self = @
      @model.save {},
        success: (model, resp) ->
          self.$('.editable-input').popover('destroy')
          self.closeForm()

    closeForm: ->
      @leave()
      channel.trigger('fieldForm:close')
