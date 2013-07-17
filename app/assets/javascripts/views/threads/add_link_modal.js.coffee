define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/links/register_url'
  'views/links/confirm_link_details'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, RegisterUrlView, ConfirmLinkDetailsView, channel, I18n) ->

  class AddLinkModalView extends BaseView
    template: _.template '
        <div class="modal-header">
          <button class="close"
                  type="button"
                  data-dismiss="modal"
                  aria-hidden="true">&times;</button>
          <h3><%= title %></h3>
        </div>
        <div class="modal-body"></div>'

    initialize: (options = {}) ->
      super(options)

      throw('model required') unless options.model
      @step = options.step || 1
      @RegisterUrlView = options.RegisterUrlView || RegisterUrlView
      @ConfirmLinkDetailsView = options.ConfirmLinkDetailsView || ConfirmLinkDetailsView
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
          @$el.html(@template(title: 'Add a link'))
          @modal = new @RegisterUrlView(model: @model)
        when 2
          @$el.html(@template(title: 'Confirm link details'))
          @modal = new @ConfirmLinkDetailsView(model: @model)
      @renderChildInto(@modal, '.modal-body')
      @
