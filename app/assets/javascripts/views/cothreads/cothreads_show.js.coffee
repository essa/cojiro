class CojiroApp.Views.CothreadsShow extends Backbone.View
  id: 'thread'

  initialize: ->
    _.bindAll @
    @render()

  render: ->
    @$el.html(JST['cothreads/show'](model: @model))
    @
