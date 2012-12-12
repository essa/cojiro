define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base',
  'templates/homepage/thread_filter'
], ($, _, Backbone, Base, threadFilterTemplate) ->

  class ThreadFilterView extends Base.View
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
