App.ThreadView = App.Views.Thread = Support.CompositeView.extend
  id: 'thread'

  events:
    "click button.edit-button": "showEditableField"

  initialize: ->
    _.bindAll @

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    if App.flash?
      @$el.prepend(JST['other/flash'](App.flash))
      App.flash = null
    @

  showEditableField: (e) ->
    $el = $(e.currentTarget)
    $el.addClass('save-button')
    $el.removeClass('edit-button')
    $el.html(I18n.t('templates.threads.show.save'))
    $editable = $el.prev()
    attr = $editable.attr('data-attribute')
    @forms ||= new Object()
    @forms[attr] = form = new Backbone.Form(model: @model, fields: [attr], template: 'inPlaceForm', fieldsetTemplate: 'inPlaceFieldset', fieldTemplate: 'inPlaceField').render()
    $editable.html(form.el)
