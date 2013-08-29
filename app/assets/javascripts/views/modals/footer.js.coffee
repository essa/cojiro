define [
  'jquery'
  'underscore'
  'modules/base/view'
], ($, _, BaseView) ->

  class ModalFooterView extends BaseView
    template: _.template '
      <button type="cancel" class="btn"><%= cancel %></button>
      <button type="submit" class="btn btn-primary"><%= submit %></button>
      '

    initialize: (options = {}) ->
      super(options)

      @cancel = options.cancel
      @submit = options.submit

    render: () ->
      @$el.html(
        @template
          cancel: @cancel
          submit: @submit
      )
      @
