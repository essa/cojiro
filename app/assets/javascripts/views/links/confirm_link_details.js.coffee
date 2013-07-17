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
          <div class="control-group url">
            <label class="control-label">URL</label>
            <div class="controls">
              <input type="text" name="url" value="<%= url %>" readonly />
            </div>
          </div>
          <div class="control-group source-locale">
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
          <div class="control-group title">
            <label class="control-label"><%= title_string %></label>
            <div class="controls">
              <input type="text" name="title" readonly />
            </div>
          </div>
        </fieldset>
      </form>
    '

    buildEvents: () ->
      _(super).extend
        'change select': 'updateTitleLabel'

    initialize: (options = {}) ->
      super(options)

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
      @preFill()
      @

    preFill: () ->
      if (embed_data = @model.getEmbedData())
        @$('input[name="title"]').val(embed_data['title'])

    updateTitleLabel: () ->
      self = @
      @$('.title label').text('Title in ' + self.$('select option:selected').text())
      @$('.title input').attr('readonly', false)
      @$('select[name="source_locale"] option[value=""]').remove()
