define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'views/threads/thread_list_item',
  'templates/threads/list',
  'jquery.timeago'
], ($, _, Backbone, BaseView, ThreadListItemView) ->

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
      @$el.html(JST['threads/list'])

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
