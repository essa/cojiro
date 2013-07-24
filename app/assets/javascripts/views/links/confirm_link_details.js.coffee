define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/translatable/form'
  'i18n'
], ($, _, Backbone, BaseView, Form, I18n) ->

  class ConfirmLinkDetailsView extends BaseView
    className: 'form'
    template: _.template '
      <div class="row-fluid">
        <div class="span8" id="form">
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
      @form = new Form(model: @model, wildcard: 'xx')

    render: () ->
      @renderChild(@form)
      @formatForm(@form)
      if embedData = @model.getEmbedData()
        @preFillForm(@form, embedData)
      @$el.html(
        @template
          thumb_src: @model.getThumbnailUrl()
      )
      @$('#form').append(@form.el)
      @

    formatForm: (form) ->
      # set rows
      form.$('textarea[name="title-xx"]').attr('rows', 2)
      form.$('textarea[name="summary-xx"]').attr('rows', 5)
      # set to readonly
      form.$('textarea[name="title-xx"]').attr('readonly', true)
      form.$('textarea[name="summary-xx"]').attr('readonly', true)

    preFillForm: (form, embedData) ->
      @form.$('textarea[name="title-xx"]').val(embedData['title'])
      @form.$('textarea[name="summary-xx"]').val(embedData['description'])

    updateLabels: () ->
      self = @
      locale = @form.$('select option:selected').text()
      @form.$('.title-xx label').text('Title in ' + locale)
      @form.$('.summary-xx label').text('Summary in ' + locale)
      @form.$('.title-xx textarea').attr('readonly', false)
      @form.$('.summary-xx textarea').attr('readonly', false)
      @form.$('select[name="source_locale"] option[value=""]').remove()
