define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/threads/thread_list'
  'views/homepage/thread_filter'
  'globals'
  'i18n'
  'templates/homepage/index'
], ($, _, Backbone, BaseView, ThreadListView, ThreadFilterView, globals, I18n, indexTemplate) ->

  class HomepageView extends BaseView
    id: 'homepage'

    initialize: (options = {}) ->
      # isolate dependencies
      @ThreadListView = options.ThreadListView || ThreadListView
      @ThreadFilterView = options.ThreadFilterView || ThreadFilterView

      # initialize view
      @filteredCollection = @collection
      @collection.bind("change", @renderThreadList)

    render: ->
      @renderLayout()
      if globals.currentUser?
        @renderThreadFilter()
      @renderThreadList()
      @

    renderLayout: ->
      @$el.html(indexTemplate())

    renderThreadList: =>
      @threadListView = new @ThreadListView(collection: @filteredCollection)
      threadListContainer = @.$('#threads')
      @renderChildInto(@threadListView, threadListContainer)

    renderThreadFilter: =>
      @threadFilterView = new @ThreadFilterView
      @threadFilterView.bind("changed", @filterThreads)
      threadFilterContainer = @.$('#content-header')
      @renderChildInto(@threadFilterView, threadFilterContainer)

    filterThreads: (scope) =>
      switch(scope)
        when "all"
          @filteredCollection = @collection
          @renderThreadList()
        when "mine"
          @filteredCollection = @collection.byUser(globals.currentUser.name)
          @renderThreadList()
