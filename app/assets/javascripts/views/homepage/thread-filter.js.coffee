define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/view',
], ($, _, Backbone, BaseView) ->

  class ThreadFilterView extends BaseView
    template: _.template '
      <fieldset>
        <div class="form-group">
          <label class="col-xs-4 control-label" for="thread-filter">
            Show me:
          </label>
          <div class="col-xs-8">
            <select id="thread-filter" class="form-control">
              <option value="all">everything</option>
              <option value="mine">threads that I started</option>
            </select>
          </div>
        </div>
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
