define [
  'jquery'
  'underscore',
  'backbone',
  'modules/base/view',
  'modules/channel'
  'i18n'
  'bootstrap'
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
        "submit form.in-place-form": "saveField"
        "click button.cancel-button": "closeForm"

    initialize: (options = {}) ->
      super(options)

      throw('field required') unless @field = options.field
      throw('model required') unless @model = options.model
      throw('type required') unless @type = options.type

    render: ->
      @$el.html(@template(field: @field, type: @type))
      if @model.getSourceLocale() != (locale = I18n.locale)
        @$('textarea').attr(
          'placeholder',
          I18n.t('modules.translatable.field-form.translate_to_lang', lang: I18n.t(locale))
        )
      @renderVal()
      @

    renderVal: ->
      @$('.field').val(@model.getAttr(@field))

    saveField: (e) ->
      e.preventDefault()
      @model.setAttr(@field, @$('.field').val())
      self = @
      @model.save {},
        success: (model, resp) ->
          self.$('.editable-input').popover('destroy')
          self.closeForm()

    closeForm: ->
      channel.trigger("fieldForm:#{@cid}:close")
      @leave()
