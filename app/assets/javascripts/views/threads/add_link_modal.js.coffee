define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/links/register_url'
  'views/links/confirm_link_details'
  'views/modals/footer'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, RegisterUrlView, ConfirmLinkDetailsView, ModalFooterView, channel, I18n) ->

  class AddLinkModalView extends BaseView
    template: _.template '
        <div class="modal-header">
          <button class="close"
                  type="button"
                  data-dismiss="modal"
                  aria-hidden="true">&times;</button>
          <h3><%= title %></h3>
        </div>
        <div class="modal-body"></div>
        <div class="modal-footer"></div>'

    initialize: (options = {}) ->
      super(options)

      throw('model required') unless options.model
      @step = options.step || 1
      @RegisterUrlView = options.RegisterUrlView || RegisterUrlView
      @ConfirmLinkDetailsView = options.ConfirmLinkDetailsView || ConfirmLinkDetailsView
      @ModalFooterView = options.ModalFooterView || ModalFooterView
      self = @
      channel.on 'modal:next', ->
        self.step = self.step + 1
        self.render()
      channel.on 'modal:prev', ->
        self.step = self.step - 1 unless self.step == 1
        self.render()

    render: () ->
      @modal.leave() if @modal
      @footer.leave() if @footer
      switch @step
        when 1
          @$el.html(@template(title: 'Add a link'))
          @modal = new @RegisterUrlView(model: @model)
          @renderChildInto(@modal, '.modal-body')
        when 2
          @$el.html(@template(title: 'Confirm link details'))
          @modal = new @ConfirmLinkDetailsView(model: @model)
          @renderChildInto(@modal, '.modal-body')
          @footer = new @ModalFooterView(prevString: 'Back', nextString: 'Confirm')
          @renderChildInto(@footer, '.modal-footer')
        else
          throw('invalid step')
      @
