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
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header"></div>
          <div class="modal-body">
            <div class="row hide">
              <div class="col-xs-12" id="flash-box"></div>
            </div>
            <div class="row">
              <div class="col-xs-12" id="link-details"></div>
            </div>
          </div>
          <div class="modal-footer"></div>
        </div>
      </div>'

    buildEvents: () ->
      _(super).extend
        'change select': 'updateForm'
        'click button[type="submit"]': 'next'
        'click button[type="cancel"]': 'prev'

    initialize: (options = {}) ->
      super(options)
      @linkForm = new Form model: @model
      @Comment = options.Comment || Comment
      @comment = new @Comment
      @commentForm = new Form model: @comment
      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView
      @header = new @ModalHeaderView(title: 'Add &nbsp; <small>' + @model.getDisplayUrl() + '</small>')
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
        form.$('.source_locale select').replaceWith($("<p class='form-control-static'>#{I18n.t(sourceLocale)}</span>"))
        title = @model.getAttrInSourceLocale('title')
        form.$('.title textarea').replaceWith($("<p class='form-control-static'>#{title}</div>"))
        summary = @model.getAttrInSourceLocale('summary')
        form.$('.summary textarea').replaceWith($("<p class='form-control-static'>#{summary}</div>"))
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
        @$('.row.hide').removeClass('hide').find('#flash-box').html(@flash.el)

    renderCommentForm: () ->
      @renderChild(@commentForm)
      @commentForm.$el.addClass('comment-form')

    prefillLinkForm: (embedData) ->
      @linkForm.$('.title textarea').val(embedData.title)
      @linkForm.$('.summary textarea').val(embedData.description)

    updateForm: () ->
      selected = @linkForm.$('select option:selected')
      @linkForm.trigger('changeLocale', selected.val())
      @linkForm.$('.form-group.source_locale').removeClass('error')
      @linkForm.$('.form-group .help-block').empty()

    next: () ->
      self = @
      if @model.getStatus() || @model.set(@linkForm.serialize(), validate: true)
        @comment.set(link: @model, user: globals.currentUser)
        @comment.save _(@commentForm.serialize()).extend(thread: @thread),
          wait: true
          success: (model, resp) ->
            channel.trigger('modal:next')
            self.leave()

    prev: () -> channel.trigger('modal:prev')
