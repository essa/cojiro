define [
  'underscore'
  'modules/base/view'
], (_, BaseView) ->

  class StatusMessageView extends BaseView
    template: _.template '
      <div class="status-avatar">
        <img src=\'<%= avatarUrl %>\' />
      </div>
      <%= msg %>
    '

    render: () ->
      @$el.html(
        @template(
          msg: @model.getStatusMessage()
          avatarUrl: @model.getUserAvatarUrl()
        ))
      @
