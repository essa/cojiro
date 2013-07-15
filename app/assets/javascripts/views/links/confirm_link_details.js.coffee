define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'i18n'
], ($, _, Backbone, BaseView, I18n) ->

  class ConfirmLinkDetailsView extends BaseView
    className: 'form'
    template: _.template '
      <form class="form-horizontal confirm-link-details-form">
        <fieldset>
          <div class="control-group">
            <label class="control-label">URL</label>
            <div class="controls">
              <input type="text" name="url" value="<%= url %>" readonly />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label"><%= source_locale_string %></label>
            <div class="controls">
              <select name="source_locale">
                <option value=""><%= select_language_string %></option>
                <% _(locales).each(function(locale, name) { %>
                  <option value=<%= locale %>><%= name %></option>
                <% }) %>
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label"><%= title_string %></label>
            <div class="controls">
              <input type="text" name="title" readonly />
            </div>
          </div>
        </fieldset>
      </form>
    '

    render: () ->
      @$el.html(
        @template
          url: @model.getUrl()
          locales: _.object(_.map(I18n.availableLocales, (locale) ->
            [I18n.t(locale), locale]))
          source_locale_string: 'This link is in'
          select_language_string: 'Select a language'
          title_string: 'Title'
      )
      # pre-fill from embedly data
      if (embed_data = @model.get('embed_data'))
        @$('input[name="title"]').val(embed_data['title'])
      @
