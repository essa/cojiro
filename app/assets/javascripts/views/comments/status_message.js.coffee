define [
  'underscore'
  'modules/base/view'
], (_, BaseView) ->

  class StatusMessageView extends BaseView
    template: _.template '
      <img src="<%= avatarUrl %>" />
      <div class="message"><%= msg %></div>
      &nbsp;
    '
    className: 'status-message'

    render: () ->
      @$el.html(
        @template(
          msg: @model.getStatusMessage()
          avatarUrl: @model.getUserAvatarUrl()
        ))
      @
