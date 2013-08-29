define (require) ->

  # static dependencies
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  BaseView = require 'modules/base/view'
  require 'jquery.timeago'

  class ThreadListView extends BaseView
    template: _.template '<tbody></tbody>'
    tagName: 'table'
    className: 'threads_list table table-striped'

    initialize: (options = {}) ->

      # dynamic dependencies
      @ThreadListItemView = options.ThreadListItemView || require('views/threads/thread-list-item')

      # event listeners
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
