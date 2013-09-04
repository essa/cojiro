define [
  'jquery'
  'underscore'
  'modules/base/view'
], ($, _, BaseView) ->

  class FormActionsView extends BaseView
    className: 'form-group row'
    template: _.template '
      <div class="col-md-10 col-md-offset-2">
        <button class="btn btn-primary">
          <%= submit %>
        </button>
        <div class="btn btn-default">
          <%= cancel %>
        </div>
      </div>
    '

    initialize: (options = {}) ->
      @submit = options.submit
      @cancel = options.cancel
      super

    render: ->
      @$el.html(@template(submit: @submit, cancel: @cancel))
      @
