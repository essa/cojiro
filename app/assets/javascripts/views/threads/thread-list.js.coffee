define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/threads/thread-list-item'
  'jquery.timeago'
], ($, _, Backbone, BaseView, ThreadListItemView) ->

  class ThreadListView extends BaseView
    template: _.template '<tbody></tbody>'
    tagName: 'table'
    className: 'threads_list table table-striped'

    initialize: (options = {}) ->
      @ThreadListItemView = options.ThreadListItemView || ThreadListItemView

      @collection && @collection.on('add', @render, @)

    render: ->
      @renderLayout()
      @renderListItems()
      @initTimeago()
      @

    renderLayout: ->
      @$el.html(@template())

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
