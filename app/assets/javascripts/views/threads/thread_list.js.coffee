App.ThreadListView = App.Views.ThreadList = Backbone.View.extend
  id: 'threads_list'

  initialize: ->

  render: ->
    @$el.html(JST['threads/list'](threads: @collection))

    self = @
    @collection.each (thread) ->
      threadListItemView = new App.ThreadListItemView(model: thread)
      self.$('table').append(threadListItemView.render().el)

    @
