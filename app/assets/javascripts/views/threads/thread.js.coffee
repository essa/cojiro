App.ThreadView = App.Views.Thread = Support.CompositeView.extend
  id: 'thread'

  events:
    "click button.edit-button": "showEditableField"
    "click button.save-button": "saveEditableField"
    "submit form.in-place-form": "submitEditableFieldForm"
    "click button.cancel-button": "revertEditableField"

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
    @insertCancelButtonAfter($button)
    $editableField = @findEditableFieldFromButton($button)
    attr = @getAttributeName($editableField)
    @forms ||= {}
    form = (@forms[attr] ||= @createFormFor(attr))
    @renderChild(form)
    $editableField.html(form.el)

  submitEditableFieldForm: (e) ->
    e.preventDefault()
    $form = $(e.currentTarget)
    $button = @findButtonFromForm($form)
    $button.trigger('click')

  saveEditableField: (e) ->
    $button = $(e.currentTarget)
    $editableField = @findEditableFieldFromButton($button)
    attr = @getAttributeName($editableField)
    @forms[attr].commit()
    self = @
    @model.save({},
      success: (model, resp) ->
        self.removeCancelButtonAfter($button)
        self.convertToEditButton($button)
        $editableField.replaceWith(JST['shared/_translatable_attribute'](model: model, attr_name: attr))
    )

  revertEditableField: (e) ->
    $button = $(e.currentTarget)
    $editableField = $button.prev().prev()
    $editButton = $button.prev()
    attr = @getAttributeName($editableField)
    $button.remove()
    @convertToEditButton($editButton)
    $editableField.replaceWith(JST['shared/_translatable_attribute'](model: @model, attr_name: attr))

  convertToSaveButton: ($el) ->
    $el.addClass('save-button')
    $el.removeClass('edit-button')
    $el.html(I18n.t('views.threads.thread.save'))

  insertCancelButtonAfter: ($el) -> $el.after("<button class='cancel-button btn btn-mini'>#{I18n.t('views.threads.thread.cancel')}</button>")
  removeCancelButtonAfter: ($el) -> $el.next().remove()

  convertToEditButton: ($el) ->
    $el.addClass('edit-button')
    $el.removeClass('save-button')
    attr = @getAttributeName(@findEditableFieldFromButton($el))
    $el.replaceWith(JST['shared/_edit_add_button'](text: @model.get(attr)))

  findEditableFieldFromButton: ($el) -> $el.prev()
  findButtonFromForm: ($el) -> $el.closest('span').next()
  getAttributeName: ($el) -> $el.attr('data-attribute')
  createFormFor: (attr) -> new Backbone.CompositeForm(model: @model, fields: [attr], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
