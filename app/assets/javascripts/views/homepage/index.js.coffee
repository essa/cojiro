class App.HomepageView extends Support.CompositeView
  id: 'homepage'

  initialize: ->
    @filteredCollection = @collection
    @collection.bind("change", @renderThreadList)

  render: ->
    @renderLayout()
    if App.currentUser?
      @renderThreadFilter()
    @renderThreadList()
    @

  renderLayout: ->
    @$el.html(JST['homepage/index'])

  renderThreadList: =>
    @threadListView = new App.ThreadListView(collection: @filteredCollection)
    threadListContainer = @.$('#threads')
    @renderChildInto(@threadListView, threadListContainer)

  renderThreadFilter: =>
    @threadFilterView = new App.ThreadFilterView
    @threadFilterView.bind("changed", @filterThreads)
    threadFilterContainer = @.$('#content-header')
    @renderChildInto(@threadFilterView, threadFilterContainer)

  filterThreads: (scope) =>
    switch(scope)
      when "all"
        @filteredCollection = @collection
        @renderThreadList()
      when "mine"
        @filteredCollection = @collection.byUser(App.currentUser.name)
        @renderThreadList()

App.Views.Homepage = App.HomepageView
