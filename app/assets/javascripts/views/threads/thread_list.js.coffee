App.ThreadListView = App.Views.ThreadList = Backbone.View.extend
  id: 'threads'

  initialize: ->

  render: ->
    @$el.html(JST['threads/index'](collection: @collection))
    @
