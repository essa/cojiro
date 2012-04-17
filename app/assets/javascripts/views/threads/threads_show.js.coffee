class CojiroApp.Views.ThreadsShow extends Backbone.View
  id: 'thread'

  initialize: ->
    _.bindAll @
    @render()

  render: ->
    @$el.html(JST['threads/show'](model: @model))
    @
