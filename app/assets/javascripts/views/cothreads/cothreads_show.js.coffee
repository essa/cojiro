CojiroApp.Views.CothreadsShow = Backbone.View.extend
  id: 'thread'

  initialize: ->

  render: ->
    this.$el.html(JST['cothreads/show'])
    return this
