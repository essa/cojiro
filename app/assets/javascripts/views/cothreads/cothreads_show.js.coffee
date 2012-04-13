class CojiroApp.Views.CothreadsShow extends Backbone.View
  id: 'thread'

  initialize: ->

  render: ->
    @$el.html(JST['cothreads/show'])
    @
