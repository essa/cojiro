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
    attr = $el.prev().attr('data-attribute')
    $el.html(I18n.t('templates.threads.show.save'))
    form = new Backbone.Form(model: @model, fields: [attr] ).render()
    $el.prev().html(form.el)
