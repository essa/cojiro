App.ThreadListView = App.Views.ThreadList = Backbone.View.extend
  id: 'threads_list'

  initialize: ->

  render: ->
    @$el.html(JST['threads/index'](threads: @collection))
    @
