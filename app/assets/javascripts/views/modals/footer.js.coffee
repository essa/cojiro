define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, channel, I18n) ->

  class ModalFooterView extends BaseView
    template: _.template '
      <button class="prev btn"><%= prev_string %></button>
      <button class="next btn btn-primary"><%= next_string %></button>
      '

    buildEvents: () ->
      _(super).extend
        'click button.next': 'next'
        'click button.prev': 'prev'

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

    next: () -> channel.trigger('modal:next')
    prev: () -> channel.trigger('modal:prev')
