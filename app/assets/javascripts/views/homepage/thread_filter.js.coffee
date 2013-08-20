define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/view',
], ($, _, Backbone, BaseView) ->

  class ThreadFilterView extends BaseView
    template: _.template '
      <fieldset>
        <label class="control-label" for="thread-filter">
          Show me:
        </label>
        <select id="thread-filter" class="span3">
          <option value="all">everything</option>
          <option value="mine">threads that I started</option>
        </select>
      </fieldset>
    '
    className: 'commentheader form-horizontal'
    tagName: 'form'
    id: 'thread-filter'

    buildEvents: () ->
      _(super).extend
        "change select": "selectFilter"

    render: =>
      @$el.html(@template())
      @

    selectFilter: (e) =>
      val = $(e.currentTarget).val()
      @trigger("changed", val)
