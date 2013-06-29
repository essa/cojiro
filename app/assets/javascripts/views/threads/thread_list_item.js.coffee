define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'templates/threads/list_item'
], ($, _, Backbone, BaseView, threadsListItemTemplate) ->

  class ThreadListItemView extends BaseView
    tagName: 'tr'
    id: 'thread-list-item'
    className: 'clickable'

    initialize: ->
      @$el.attr('data-href': @model.url())

    render: ->
      @$el.html(threadsListItemTemplate( model: @model ))
      @
