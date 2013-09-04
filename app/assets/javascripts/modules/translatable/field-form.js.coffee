define [
  'jquery'
  'underscore',
  'backbone',
  'modules/base/view',
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, channel, I18n) ->

  class FieldForm extends BaseView
    template: _.template '
      <form class="in-place-form">
        <div class="editable-input">
          <span class="input-small">
            <<%= (type == "Text") ? "input" : "textarea" %> name="<%= field %>" type="text" class="field input-medium form-control" />
          </span>
        </div>
      </form>
      <button class="save-button btn btn-primary btn-sm" type="submit">
        <span class="glyphicon glyphicon-ok glyphicon-white" />
      </button>
      <button class="cancel-button btn btn-sm" type="cancel">
        <span class="glyphicon glyphicon-remove" />
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
