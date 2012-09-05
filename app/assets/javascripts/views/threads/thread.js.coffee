class App.ThreadView extends App.TranslatableFieldsView
  id: 'thread'

  initialize: ->
    super

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    if App.flash?
      @$el.prepend(JST['other/flash'](App.flash))
      App.flash = null
    @

App.Views.Thread = App.ThreadView
