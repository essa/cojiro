define [
  'jquery'
  'underscore'
  'modules/base/view'
], ($, _, BaseView) ->

  class ModalHeaderView extends BaseView
    template: _.template '
      <button class="close"
              type="button"
              data-dismiss="modal"
              aria-hidden="true">&times;</button>
      <h4 class="modal-title"><%= title %></h4>'

    initialize: (options = {}) ->
      super(options)

      @title = options.title

    render: () ->
      @$el.html(@template(title: @title))
      @
