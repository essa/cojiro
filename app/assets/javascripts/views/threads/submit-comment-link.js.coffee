define [
  'jquery'
  'underscore'
  'backbone'
  'models/comment'
  'views/modals/header'
  'views/modals/footer'
  'views/other/flash'
  'modules/base/view'
  'modules/translatable/form'
  'modules/channel'
  'i18n'
  'globals'
], ($, _, Backbone, Comment, ModalHeaderView, ModalFooterView, FlashView, BaseView, Form, channel, I18n, globals) ->

  class SubmitCommentLinkView extends BaseView
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
        'change select': 'updateForm'
        'click button[type="submit"]': 'next'
        'click button[type="cancel"]': 'prev'

    initialize: (options = {}) ->
      super(options)
      @linkForm = new Form model: @model
      @Comment = options.Comment || Comment
      @comment = new @Comment(link: @model)
      @commentForm = new Form model: @comment
      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView
      @header = new @ModalHeaderView(title: 'Add <small>' + @model.getDisplayUrl() + '</small>')
      @ModalFooterView = options.ModalFooterView || ModalFooterView
      @footer = new @ModalFooterView(cancel: 'Back', submit: 'Add to this thread')
      @thread = options.thread

    render: () ->
      @renderTemplate()
      @renderHeader()
      @renderFooter()
      @renderLinkForm()
      @renderCommentForm()
      if embedData = @model.getEmbedData()
        @prefillLinkForm(embedData)
      @$('#link-details').html(@linkForm.el)
      @$('#link-details').append(@commentForm.el)
      @

    renderTemplate: -> @$el.html(@template())
    renderHeader: -> @renderChildInto(@header, '.modal-header')
    renderFooter: -> @renderChildInto(@footer, '.modal-footer')

    renderLinkForm: () ->
      @renderChild(@linkForm)
      form = @linkForm

      form.$el.addClass('link-form')

      # link already exists
      if @model.getStatus()
        sourceLocale = @model.getSourceLocale()
        form.$('.source_locale select').replaceWith($("<span class='uneditable-input'>#{I18n.t(sourceLocale)}</span>"))
        title = @model.getAttrInSourceLocale('title')
        form.$('.title textarea').replaceWith($("<div class='uneditable-input'>#{title}</div>"))
        summary = @model.getAttrInSourceLocale('summary')
        form.$('.summary textarea').replaceWith($("<div class='uneditable-input'>#{summary}</div>"))
        @flash.leave() if @flash
        @flash = new FlashView(
          name: 'info'
          msg: I18n.t(
            'views.threads.submit-comment-link.already_registered'
            name: @model.getUserName()
            date: @model.getCreatedAt()
          )
          close: false
        )
        @renderChild(@flash)
        @$('.row-fluid.hide').removeClass('hide').find('#flash-box').html(@flash.el)

      # this is a new link
      else
        # set to readonly
        form.$('.title textarea').attr('readonly', true)
        form.$('.summary textarea').attr('readonly', true)

    renderCommentForm: () ->
      @renderChild(@commentForm)
      @commentForm.$el.addClass('comment-form')

    prefillLinkForm: (embedData) ->
      @linkForm.$('.title textarea').val(embedData.title)
      @linkForm.$('.summary textarea').val(embedData.description)

    updateForm: () ->
      selected = @linkForm.$('select option:selected')
      locale = selected.text()
      @linkForm.trigger('changeLocale', selected.val())
      @linkForm.$('.title textarea').attr('readonly', false)
      @linkForm.$('.summary textarea').attr('readonly', false)
      @linkForm.$('.control-group.source_locale').removeClass('error')
      @linkForm.$('.control-group .help-block').empty()
      @linkForm.$('.source_locale select option[value=""]').remove()

    next: () ->
      self = @
      if @model.getStatus() || @model.set(@linkForm.serialize(), validate: true)
        @comment.set('user', globals.currentUser)
        @comment.save _(@commentForm.serialize()).extend(thread: @thread),
          wait: true
          success: (model, resp) ->
            channel.trigger('modal:next')
            self.leave()

    prev: () -> channel.trigger('modal:prev')
