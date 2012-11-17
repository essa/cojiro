define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'templates/threads/list_item'
], ($, _, Backbone, Base, threadsListItemTemplate) ->

  class ThreadListItemView extends Base.View
    tagName: 'tr'
    id: 'thread-list-item'
    className: 'clickable'

    initialize: ->
      @$el.attr('data-href': @model.url())

    render: ->
      @$el.html(threadsListItemTemplate( model: @model ))
      @
