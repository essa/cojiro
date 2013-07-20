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
      <div class="row-fluid">
        <div class="span8">
          <form class="form-horizontal">
            <fieldset>
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
                  <textarea type="text" rows="2" name="title" readonly />
                </div>
              </div>
              <div class="control-group summary">
                <label class="control-label"><%= summary_string %></label>
                <div class="controls">
                  <textarea type="text" rows="5" name="summary" readonly />
                </div>
              </div>
            </fieldset>
          </form>
        </div>
        <div class="span4">
          <div class="thumbnail">
            <img src="<%= thumb_src %>" style="max-width: 300; max-height: 500px" />
          </div>
        </div>
      </div>
    '

    buildEvents: () ->
      _(super).extend
        'change select': 'updateLabels'

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
          summary_string: 'Summary'
          thumb_src: @model.getThumbnailUrl()
      )
      @preFill()
      @

    preFill: () ->
      if (embed_data = @model.getEmbedData())
        @$('textarea[name="title"]').val(embed_data['title'])
        @$('textarea[name="summary"]').val(embed_data['description'])

    updateLabels: () ->
      self = @
      lang = @$('select option:selected').text()
      @$('.title label').text('Title in ' + lang)
      @$('.summary label').text('Summary in ' + lang)
      @$('.title textarea').attr('readonly', false)
      @$('.summary textarea').attr('readonly', false)
      @$('select[name="source_locale"] option[value=""]').remove()
