define [
  'jquery'
  'underscore'
  'backbone'
  'views/modals/header'
  'views/modals/footer'
  'modules/base/view'
  'modules/translatable/form'
  'i18n'
], ($, _, Backbone, ModalHeaderView, ModalFooterView, BaseView, Form, I18n) ->

  class ConfirmLinkDetailsView extends BaseView
    template: _.template '
      <div class="modal-header"></div>
      <div class="modal-body">
        <div class="row-fluid">
          <div class="span8" id="form">
          </div>
          <div class="span4">
            <div class="thumbnail">
              <img src="<%= thumb_src %>" style="max-width: 300; max-height: 500px" />
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer"></div>'

    buildEvents: () ->
      _(super).extend
        'change select': 'updateLabels'
        'submit form': 'submitForm'

    initialize: (options = {}) ->
      super(options)
      @form = new Form(model: @model, wildcard: 'xx')
      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView
      @header = new @ModalHeaderView(title: 'Confirm link details <small>' + @model.getUrl() + '</small>')
      @ModalFooterView = options.ModalFooterView || ModalFooterView
      @footer = new @ModalFooterView(prevString: 'Back', nextString: 'Confirm')

    render: () ->
      @renderChild(@form)
      @formatForm(@form)
      if embedData = @model.getEmbedData()
        @preFillForm(@form, embedData)
      @$el.html(
        @template(
          thumb_src: @model.getThumbnailUrl()
        )
      )
      @$('#form').append(@form.el)
      @renderChildInto(@header, '.modal-header')
      @renderChildInto(@footer, '.modal-footer')
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

    submitForm: () ->
