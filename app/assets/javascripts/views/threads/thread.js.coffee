class App.Views.Thread extends Backbone.View
  id: 'thread'

  initialize: ->
    _.bindAll @
    @render()

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    @
