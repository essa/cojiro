define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/threads/add-url'
  'views/threads/submit-comment-link'
  'models/link'
  'modules/modal'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, AddUrlView, SubmitCommentLinkView, Link, ModalView, channel, I18n) ->

  class AddLinkModal extends ModalView
    el: '#add-link-modal'

    initialize: (options = {}) ->
      super(options)

      throw('model required') unless options.model
      @step = options.step || 1
      @AddUrlView = options.AddUrlView || AddUrlView
      @SubmitCommentLinkView = options.SubmitCommentLinkView || SubmitCommentLinkView
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
          @reset()
          @$el.addClass('add-url')
          @modal = new @AddUrlView(model: @model, link: @link)
          @appendChild(@modal)
        when 2
          # we've now got the normalized url (set by the server),
          # but we might not have the same instance that's in the store.
          # to be sure, let's find it.
          coll = Backbone.Relational.store.getCollection(Link)
          linkInStore = coll.findWhere(url: @link.getUrl())
          @link = linkInStore if linkInStore

          @reset()
          @$el.addClass('submit-comment-link')
          @modal = new @SubmitCommentLinkView(model: @link, thread: @model)
          @appendChild(@modal)
        when 3
          @hideModal()
        else
          throw('invalid step')
      @

    leave: () ->
      channel.off('modal:next')
      channel.off('modal:prev')
      super

    showModal: () ->
      @step = 1
      super
