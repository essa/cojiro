App.ThreadView = App.Views.Thread = Backbone.View.extend
  id: 'thread'

  initialize: ->
    _.bindAll @
    @render()

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    @
