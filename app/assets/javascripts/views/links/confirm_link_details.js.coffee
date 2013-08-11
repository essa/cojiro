define [
  'jquery'
  'underscore'
  'backbone'
  'models/comment'
  'views/modals/header'
  'views/modals/footer'
  'modules/base/view'
  'modules/translatable/form'
  'modules/channel'
  'templates/other/flash'
  'i18n'
], ($, _, Backbone, Comment, ModalHeaderView, ModalFooterView, BaseView, Form, channel, flashTemplate, I18n) ->

  class ConfirmLinkDetailsView extends BaseView
    template: _.template '
      <div class="modal-header"></div>
      <div class="modal-body">
        <div class="row-fluid hide">
          <div class="span12" id="flash-box"></div>
        </div>
        <div class="row-fluid">
          <div class="span12" id="link-details"></div>
        </div>
      </div>
      <div class="modal-footer"></div>'

    buildEvents: () ->
      _(super).extend
        'change select': 'updateLabels'
        'click button.next': 'next'
        'click button.prev': 'prev'

    initialize: (options = {}) ->
      super(options)
      @form = new Form
        model: @model
        sourceLocale: -> @$('.source_locale select').val()
      @Comment = options.Comment || Comment
      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView
      @header = new @ModalHeaderView(title: 'Add <small>' + @model.getDisplayUrl() + '</small>')
      @ModalFooterView = options.ModalFooterView || ModalFooterView
      @footer = new @ModalFooterView(prevString: 'Back', nextString: 'Add to this thread')
      @thread = options.thread

    render: () ->
      @$el.html(@template())
      @renderChildInto(@header, '.modal-header')
      @renderChildInto(@footer, '.modal-footer')
      @renderChild(@form)
      @formatForm(@form)
      if embedData = @model.getEmbedData()
        @preFillForm(@form, embedData)
      @$('#link-details').html(@form.el)
      @

    formatForm: (form) ->
      # link already exists
      if @model.getStatus()
        sourceLocale = @model.getSourceLocale()
        form.$('.source_locale select').replaceWith($("<span class='uneditable-input'>#{I18n.t(sourceLocale)}</span>"))
        title = @model.getAttrInSourceLocale('title')
        form.$('.title textarea').replaceWith($("<div class='uneditable-input'>#{title}</div>"))
        summary = @model.getAttrInSourceLocale('summary')
        form.$('.summary textarea').replaceWith($("<div class='uneditable-input'>#{summary}</div>"))
        @$('.row-fluid.hide').removeClass('hide').html(
          flashTemplate(
            name: 'notice'
            msg: I18n.t(
              'views.links.confirm_link_details.already_registered'
              name: @model.getUserName()
              date: @model.getCreatedAt())))

      # this is a new link
      else
        # set to readonly
        form.$('.title textarea').attr('readonly', true)
        form.$('.summary textarea').attr('readonly', true)

    preFillForm: (form, embedData) ->
      @form.$('.title textarea').val(embedData.title)
      @form.$('.summary textarea').val(embedData.description)

    updateLabels: () ->
      self = @
      locale = @form.$('select option:selected').text()
      @form.$('.title label').text('Title in ' + locale)
      @form.$('.summary label').text('Summary in ' + locale)
      @form.$('.title textarea').attr('readonly', false)
      @form.$('.summary textarea').attr('readonly', false)
      @form.$('.control-group.source_locale').removeClass('error')
      @form.$('.control-group .help-block').empty()
      @form.$('.source_locale select option[value=""]').remove()

    next: () ->
      self = @
      if @model.getStatus() || @model.set(@form.serialize(), validate: true)
        comment = new @Comment(link: @model, thread: @thread)
        comment.save {},
          success: (model, resp) ->
            channel.trigger('modal:next')
            self.leave()

    prev: () -> channel.trigger('modal:prev')
