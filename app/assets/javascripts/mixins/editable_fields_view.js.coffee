class App.EditableFieldsView extends App.BaseView
  
  buildEvents: () ->
    _(super).extend
      "click button.edit-button": "showEditableField"
      "click button.save-button": "saveEditableField"
      "submit form.in-place-form": "submitEditableFieldForm"
      "click button.cancel-button": "revertEditableField"

  showEditableField: (e) ->
    $button = $(e.currentTarget)
    @convertToSaveButton($button)
    @insertCancelButtonAfter($button)
    $parent = @findParent($button)
    attr = @getAttributeName($parent)
    form = @createAndRenderFormFor(attr)
    @insertFormIntoEditableField($parent, form)

  submitEditableFieldForm: (e) ->
    e.preventDefault()
    $form = $(e.currentTarget)
    $button = @findSaveButton($form)
    $button.trigger('click')

  saveEditableField: (e) ->
    $button = $(e.currentTarget)
    $parent = @findParent($button)
    attr = @getAttributeName($parent)
    @forms[attr].commit()
    self = @
    @model.save({},
      success: (model, resp) ->
        $parent.replaceWith(JST['shared/_editable_field'](model: model, attr_name: attr))
    )

  revertEditableField: (e) ->
    $button = $(e.currentTarget)
    $parent = @findParent($button)
    attr = @getAttributeName($parent)
    $parent.replaceWith(JST['shared/_editable_field'](model: @model, attr_name: attr))

  convertToSaveButton: ($el) ->
    $el.addClass('save-button')
    $el.removeClass('edit-button')
    $el.html(I18n.t('views.threads.thread.save'))

  insertFormIntoEditableField: ($el, form) -> @findEditableField($el).html(form.el)
  insertCancelButtonAfter: ($el) -> $el.after("<button class='cancel-button btn btn-mini'>#{I18n.t('views.threads.thread.cancel')}</button>")
  removeCancelButtonAfter: ($el) -> $el.next().remove()
  findParent: ($el) -> $el.closest('.editable-field-parent')
  findEditableField: ($el) -> @findParent($el).find('.editable-field')
  findSaveButton: ($el) -> @findParent($el).find('button.save-button')
  getAttributeName: ($el) -> $el.attr('data-attribute')
  createFormFor: (attr) -> new Backbone.CompositeForm(model: @model, fields: [attr], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
  createAndRenderFormFor: (attr) ->
    @forms ||= {}
    form = (@forms[attr] ||= @createFormFor(attr))
    @renderChild(form)
    return form
  renderEditableField: ($el, attr) -> @findParent($el).replaceWith(JST['shared/_editable_field'](model: @model, attr_name: attr))
