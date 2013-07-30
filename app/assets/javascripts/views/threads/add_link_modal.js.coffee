define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/links/register_url'
  'views/links/confirm_link_details'
  'models/link'
  'modules/modal'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, RegisterUrlView, ConfirmLinkDetailsView, Link, ModalView, channel, I18n) ->

  class AddLinkModal extends ModalView

    initialize: (options = {}) ->
      super(options)

      throw('model required') unless options.model
      @step = options.step || 1
      @RegisterUrlView = options.RegisterUrlView || RegisterUrlView
      @ConfirmLinkDetailsView = options.ConfirmLinkDetailsView || ConfirmLinkDetailsView
      @Link = options.Link || Link
      self = @
      channel.on 'modal:next', ->
        self.step = self.step + 1
        self.render()
      channel.on 'modal:prev', ->
        self.step = self.step - 1 unless self.step == 1
        self.render()

    render: () ->
      @modal.leave() if @modal
      switch @step
        when 1
          @link = new @Link
          @$el.removeClass('confirm-link-details')
          @$el.addClass('register-url')
          @modal = new @RegisterUrlView(model: @link)
          @appendChild(@modal)
        when 2
          @$el.removeClass('register-url')
          @$el.addClass('confirm-link-details')
          @modal = new @ConfirmLinkDetailsView(model: @link, thread: @model)
          @appendChild(@modal)
        else
          throw('invalid step')
      @

    showModal: () ->
      @step = 1
      super
