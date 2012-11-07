define [
  'jquery'
  'underscore'
  'backbone'
  'mixins/base_view'
  'views/threads/thread_list'
  'views/homepage/thread_filter'
  'globals'
  'i18n'
  'templates/homepage/index'
], ($, _, Backbone, BaseView, ThreadListView, ThreadFilterView, globals, I18n, index) ->

  class HomepageView extends BaseView
    id: 'homepage'

    initialize: ->
      @filteredCollection = @collection
      @collection.bind("change", @renderThreadList)

    render: ->
      @renderLayout()
      if globals.current_user?
        @renderThreadFilter()
      @renderThreadList()
      @

    renderLayout: ->
      @$el.html(index())

    renderThreadList: =>
      @threadListView = new ThreadListView(collection: @filteredCollection)
      threadListContainer = @.$('#threads')
      @renderChildInto(@threadListView, threadListContainer)

    renderThreadFilter: =>
      @threadFilterView = new ThreadFilterView
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
