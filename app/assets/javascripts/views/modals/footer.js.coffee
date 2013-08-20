define [
  'jquery'
  'underscore'
  'modules/base/view'
], ($, _, BaseView) ->

  class ModalFooterView extends BaseView
    template: _.template '
      <button class="prev btn"><%= prev_string %></button>
      <button class="next btn btn-primary"><%= next_string %></button>
      '

    initialize: (options = {}) ->
      super(options)

      @prevString = options.prevString
      @nextString = options.nextString

    render: () ->
      @$el.html(
        @template
          prev_string: @prevString
          next_string: @nextString
      )
      @
