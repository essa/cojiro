define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'hamlcoffee',
  'hamlcoffee_globals',
  'templates/homepage/thread_filter'
], ($, _, Backbone, BaseView) ->

  class ThreadFilterView extends BaseView
    className: 'commentheader form-horizontal'
    tagName: 'form'
    id: 'thread-filter'

    buildEvents: () ->
      _(super).extend
        "change select": "selectFilter"

    render: =>
      @$el.html(JST['homepage/thread_filter'])
      @

    selectFilter: (e) =>
      val = $(e.currentTarget).val()
      @trigger("changed", val)
