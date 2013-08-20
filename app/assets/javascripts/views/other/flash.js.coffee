define [
  'jquery'
  'underscore'
  'modules/base/view'
], ($, _, BaseView) ->

  class FlashView extends BaseView
    template: _.template '
      <div class="alert alert-<%= name %> <%= name %>" id="flash-<%= name %>">
        <% if (close) { %>
          <a class="close" href="#" data-dismiss="alert" data-bypass="true" type="button">
            &times;
          </a>
        <% } %>
        <%= msg %>
      </div>
    '

    initialize: (options = {}) ->
      @name = options.name || 'notice'
      @msg = options.msg || ''
      @close = true
      if options.close?
        @close = options.close

    render: ->
      @$el.html(@template(name: @name, msg: @msg, close: @close))
      @
