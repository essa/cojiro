class App.ThreadListView extends App.BaseView
  id: 'threads_list'
  tagName: 'table'
  className: 'table table-striped'

  initialize: ->

  render: ->
    @renderLayout()
    @renderListItems()
    @initTimeago()
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

  initTimeago: ->
    @.$('time.timeago').timeago()

App.Views.ThreadList = App.ThreadListView
