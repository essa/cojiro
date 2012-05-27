App.ThreadListView = App.Views.ThreadList = Backbone.View.extend
  id: 'threads_list'
  tagName: 'table'
  className: 'table table-striped'

  initialize: ->

  render: ->
    @$el.html(JST['threads/list'])

    self = @
    @collection.each (thread) ->
      threadListItemView = new App.ThreadListItemView(model: thread)
      self.$('tbody').append(threadListItemView.render().el)

    @
