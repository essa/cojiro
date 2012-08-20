class App.HomepageView extends Support.CompositeView
  id: 'homepage'

  initialize: ->
    @collection.on("change", @renderThreadList)

  render: ->
    @renderLayout()
    @renderThreadList()
    @

  renderLayout: ->
    @$el.html(JST['homepage/index'])

  renderThreadList: =>
    threadListView = new App.ThreadListView(collection: @collection)
    threadListContainer = @.$('#threads')
    @renderChildInto(threadListView, threadListContainer)

App.Views.Homepage = App.HomepageView
