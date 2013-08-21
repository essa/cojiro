define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
], ($, _, Backbone, BaseView) ->

  class ThreadListItemView extends BaseView
    template: _.template '
      <td>
        <span class="<%= translated %>"><%= title %></span>
        <% if (isNew) { %>
          <span class="label label-info">
            <%= t(".new_label") %>
          </span>
        <% } %>
      </td>
      <td>
        <%= t(".started_by", { username: username }) %> /
        <%= t(".updated_ago", { datetime: datetime }) %>
      </td>
    '
    tagName: 'tr'
    id: 'thread-list-item'
    className: 'clickable'

    initialize: ->
      @$el.attr('data-href': @model.url())

    render: ->
      if title = @model.getAttr('title')
        translated = 'translated'
      else
        title = @model.getAttrInSourceLocale('title')
        translated = 'untranslated'
      isNew = (Date.now() - $.timeago.parse(@model.get('created_at'))) < 86400000
      @$el.html(@template(
        translated: translated
        title: title
        t: I18n.scoped('views.threads.thread-list-item').t
        username: @model.getUserName()
        datetime: @model.get('updated_at')
        isNew: isNew
      ))
      @
