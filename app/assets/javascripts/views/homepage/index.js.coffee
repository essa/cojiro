App.HomepageView = App.Views.Homepage = Support.CompositeView.extend
  id: 'homepage'

  initialize: ->
    _.bindAll @, "renderThreadList"
    @collection.on("change", @renderThreadList)

  render: ->
    @renderLayout()
    @renderThreadList()
    @

  renderLayout: ->
    @$el.html(JST['homepage/index'])

  renderThreadList: ->
    threadListView = new App.ThreadListView(collection: @collection)
    threadListContainer = @.$('#threads')
    @renderChildInto(threadListView, threadListContainer)
