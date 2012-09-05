class App.TranslatableFieldsView extends App.BaseView
  
  buildEvents: () ->
    _(super).extend
      "click button.edit-button": "showTranslatableField"
      "click button.save-button": "saveTranslatableField"
      "submit form.in-place-form": "submitTranslatableFieldForm"
      "click button.cancel-button": "revertTranslatableField"

  showTranslatableField: (e) ->
    $button = $(e.currentTarget)
    @convertToSaveButton($button)
    @insertCancelButtonAfter($button)
    $parent = @findParent($button)
    attr = @getAttributeName($parent)
    form = @createAndRenderFormFor(attr)
    @insertFormIntoTranslatableField($parent, form)

  submitTranslatableFieldForm: (e) ->
    e.preventDefault()
    $form = $(e.currentTarget)
    $button = @findSaveButton($form)
    $button.trigger('click')

  saveTranslatableField: (e) ->
    $button = $(e.currentTarget)
    $parent = @findParent($button)
    attr = @getAttributeName($parent)
    @forms[attr].commit()
    self = @
    @model.save({},
      success: (model, resp) ->
        $parent.replaceWith(JST['shared/_translatable_field'](model: model, attr_name: attr))
    )

  revertTranslatableField: (e) ->
    $button = $(e.currentTarget)
    $parent = @findParent($button)
    attr = @getAttributeName($parent)
    $parent.replaceWith(JST['shared/_translatable_field'](model: @model, attr_name: attr))

  convertToSaveButton: ($el) ->
    $el.addClass('save-button')
    $el.removeClass('edit-button')
    $el.html(I18n.t('views.mixins.translatable_fields.save'))

  insertFormIntoTranslatableField: ($el, form) -> @findTranslatableField($el).html(form.el)
  insertCancelButtonAfter: ($el) -> $el.after("<button class='cancel-button btn btn-mini'>#{I18n.t('views.mixins.translatable_fields.cancel')}</button>")
  removeCancelButtonAfter: ($el) -> $el.next().remove()
  findParent: ($el) -> $el.closest('.translatable-field-parent')
  findTranslatableField: ($el) -> @findParent($el).find('.translatable-field')
  findSaveButton: ($el) -> @findParent($el).find('button.save-button')
  getAttributeName: ($el) -> $el.attr('data-attribute')
  createFormFor: (attr) -> new Backbone.CompositeForm(model: @model, fields: [attr], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
  createAndRenderFormFor: (attr) ->
    @forms ||= {}
    form = (@forms[attr] ||= @createFormFor(attr))
    @renderChild(form)
    return form
  renderTranslatableField: ($el, attr) -> @findParent($el).replaceWith(JST['shared/_translatable_field'](model: @model, attr_name: attr))
