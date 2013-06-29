define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/view',
  'templates/homepage/thread_filter'
], ($, _, Backbone, BaseView, threadFilterTemplate) ->

  class ThreadFilterView extends BaseView
    className: 'commentheader form-horizontal'
    tagName: 'form'
    id: 'thread-filter'

    buildEvents: () ->
      _(super).extend
        "change select": "selectFilter"

    render: =>
      @$el.html(threadFilterTemplate())
      @

    selectFilter: (e) =>
      val = $(e.currentTarget).val()
      @trigger("changed", val)
