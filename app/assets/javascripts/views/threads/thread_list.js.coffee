define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'views/threads/thread_list_item'
  'templates/threads/list'
  'jquery.timeago'
], ($, _, Backbone, Base, ThreadListItemView, threadsListTemplate) ->

  class ThreadListView extends Base.View
    id: 'threads_list'
    tagName: 'table'
    className: 'table table-striped'

    initialize: (options = {}) ->
      @ThreadListItemView = options.ThreadListItemView || ThreadListItemView

    render: ->
      @renderLayout()
      @renderListItems()
      @initTimeago()
      @

    renderLayout: ->
      @$el.html(threadsListTemplate())

    renderListItems: ->
      listItemsContainer = @.$('tbody')
      listItemsContainer.html('')

      self = @
      @collection.each (thread) ->
        threadListItemView = new self.ThreadListItemView(model: thread)
        self.renderChild(threadListItemView)
        listItemsContainer.append(threadListItemView.el)

      @

    initTimeago: ->
      @.$('time.timeago').timeago()
