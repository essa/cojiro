define [
  'jquery'
  'underscore'
  'modules/base/view'
], ($, _, BaseView) ->

  class FormActionsView extends BaseView
    className: 'form-actions'
    template: _.template '
      <button class="btn btn-primary">
        <%= submit %>
      </button>
      <div class="btn">
        <%= cancel %>
      </div>
    '

    initialize: (options = {}) ->
      @submit = options.submit
      @cancel = options.cancel
      super

    render: ->
      @$el.html(@template(submit: @submit, cancel: @cancel))
      @
