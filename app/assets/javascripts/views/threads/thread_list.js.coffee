class App.Views.ThreadList extends Backbone.View
  id: 'threads'

  initialize: ->

  render: ->
    @$el.html(JST['threads/index'](collection: @collection))
    @
