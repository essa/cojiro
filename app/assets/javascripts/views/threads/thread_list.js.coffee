App.ThreadListView = App.Views.ThreadList = Support.CompositeView.extend
  id: 'threads_list'
  tagName: 'table'
  className: 'table table-striped'

  initialize: ->

  render: ->
    @renderLayout()
    @renderListItems()
    @

  renderLayout: ->
    @$el.html(JST['threads/list'])

  renderListItems: ->
    listItemsContainer = @.$('tbody')
    listItemsContainer.html('')

    self = @
    @collection.each (thread) ->
      threadListItemView = new App.ThreadListItemView(model: thread)
      self.renderChild(threadListItemView)
      listItemsContainer.append(threadListItemView.el)

    @
