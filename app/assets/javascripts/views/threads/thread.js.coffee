App.ThreadView = App.Views.Thread = Support.CompositeView.extend
  id: 'thread'

  events:
    "click button.edit-button": "showEditableField"
    "click button.save-button": "saveEditableField"
    "submit form.in-place-form": "submitEditableFieldForm"

  initialize: ->
    _.bindAll @

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    if App.flash?
      @$el.prepend(JST['other/flash'](App.flash))
      App.flash = null
    @

  showEditableField: (e) ->
    $button = $(e.currentTarget)
    @convertToSaveButton($button)
    $editableField = @findEditableField($button)
    attr = @getAttributeName($editableField)
    @forms ||= {}
    form = (@forms[attr] ||= @createFormFor(attr))
    @renderChild(form)
    $editableField.html(form.el)

  submitEditableFieldForm: (e) ->
    e.preventDefault()
    $form = $(e.currentTarget)
    $button = $form.closest('span').next()
    $button.trigger('click')

  saveEditableField: (e) ->
    $button = $(e.currentTarget)
    $editableField = @findEditableField($button)
    attr = @getAttributeName($editableField)
    @forms[attr].commit()
    self = @
    @model.save({},
      success: (model, resp) ->
        self.convertToEditButton($button)
        $editableField.replaceWith(JST['shared/_translatable_attribute'](model: model, attr_name: attr))
    )

  convertToSaveButton: ($el) ->
    $el.addClass('save-button')
    $el.removeClass('edit-button')
    $el.html(I18n.t('views.threads.thread.save'))

  convertToEditButton: ($el) ->
    $el.addClass('edit-button')
    $el.removeClass('save-button')
    attr = @getAttributeName(@findEditableField($el))
    $el.replaceWith(JST['shared/_edit_add_button'](text: @model.get(attr)))

  findEditableField: ($el) -> $el.prev()
  getAttributeName: ($el) -> $el.attr('data-attribute')
  createFormFor: (attr) -> new Backbone.CompositeForm(model: @model, fields: [attr], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
