App.ThreadView = App.Views.Thread = Support.CompositeView.extend
  id: 'thread'

  initialize: ->
    _.bindAll @

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    if App.flash?
      @$el.prepend(JST['other/flash'](App.flash))
      App.flash = null
    @
