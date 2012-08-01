App.ThreadView = App.Views.Thread = Support.CompositeView.extend
  id: 'thread'

  events:
    "click button.edit-button": "showEditableField"
    "click button.save-button": "saveEditableField"

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
    @forms = @createForms()
    @forms[attr] = form = @createFormFor(attr)
    $editableField.html(form.render().el)

  saveEditableField: (e) ->
    $button = $(e.currentTarget)
    $editableField = @findEditableField($button)
    attr = @getAttributeName($editableField)
    @forms[attr].commit()
    @model.save()

  convertToSaveButton: ($el) ->
    $el.addClass('save-button')
    $el.removeClass('edit-button')
    $el.html(I18n.t('templates.threads.show.save'))

  findEditableField: ($el) -> $el.prev()
  getAttributeName: ($el) -> $el.attr('data-attribute')
  createForms: (forms) -> forms || new Object()
  createFormFor: (attr) -> new Backbone.Form(model: @model, fields: [attr], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField')
