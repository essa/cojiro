define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, channel, I18n) ->

  class ModalHeaderView extends BaseView
    template: _.template '
      <button class="close"
              type="button"
              aria-hidden="true">&times;</button>
      <h3><%= title %></h3>'

    initialize: (options = {}) ->
      super(options)

      @title = options.title

    render: () ->
      @$el.html(@template(title: @title))
      @
