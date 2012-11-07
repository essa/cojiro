define [
  'jquery'
  'underscore'
  'backbone'
  'mixins/base_view'
  'templates/threads/list_item'
  'templates/shared/_translatable_attribute'
  'templates/shared/_new_label'
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
