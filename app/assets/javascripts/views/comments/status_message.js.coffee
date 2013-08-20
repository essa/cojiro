define [
  'underscore'
  'modules/base/view'
], (_, BaseView) ->

  class StatusMessageView extends BaseView
    template: _.template '
      <img src="<%= avatarUrl %>" />
      <div class="status-message"><%= msg %></div>
    '
    className: 'status-avatar'

    render: () ->
      @$el.html(
        @template(
          msg: @model.getStatusMessage()
          avatarUrl: @model.getUserAvatarUrl()
        ))
      @
