define [
  'jquery'
  'underscore'
  'backbone'
  'mixins/base_view'
  'views/threads/thread_list_item'
  'hamlcoffee'
  'templates/threads/list'
  'jquery.timeago'
], ($, _, Backbone, BaseView, ThreadListItemView, hc, threadsList) ->

  class ThreadListView extends BaseView
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
      @$el.html(threadsList())

    renderListItems: ->
      listItemsContainer = @.$('tbody')
      listItemsContainer.html('')

      self = @
      @collection.each (thread) ->
        threadListItemView = new ThreadListItemView(model: thread)
        self.renderChild(threadListItemView)
        listItemsContainer.append(threadListItemView.el)

      @

    initTimeago: ->
      @.$('time.timeago').timeago()
