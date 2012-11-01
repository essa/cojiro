define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'hamlcoffee',
  'templates/homepage/thread_filter'
  'hamlcoffee_globals',
], ($, _, Backbone, BaseView, hc, threadFilter) ->

  class ThreadFilterView extends BaseView
    className: 'commentheader form-horizontal'
    tagName: 'form'
    id: 'thread-filter'

    buildEvents: () ->
      _(super).extend
        "change select": "selectFilter"

    render: =>
      @$el.html(threadFilter())
      @

    selectFilter: (e) =>
      val = $(e.currentTarget).val()
      @trigger("changed", val)
