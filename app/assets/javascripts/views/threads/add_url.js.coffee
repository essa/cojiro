define [
  'jquery'
  'underscore'
  'backbone'
  'views/modals/header'
  'views/other/flash'
  'modules/base/view'
  'modules/channel'
  'i18n'
], ($, _, Backbone, ModalHeaderView, FlashView, BaseView, channel, I18n) ->

  class AddUrlView extends BaseView
    template: _.template '
      <div class="modal-header"></div>
      <div class="modal-body">
        <div id="flash-box"></div>
        <form class="form-inline">
          <fieldset>
            <label>URL:&nbsp;</label>
            <div class="input-append">
              <input class="span4" type="text" name="url" placeholder="<%= t(".enter_a_url") %>" />
              <button type="submit" class="btn"><%= t(".go") %></button>
            </div>
          </fieldset>
        </form>
      </div>'

    buildEvents: () ->
      _(super).extend
        'submit form' : 'addUrl'

    initialize: (options = {}) ->
      super(options)

      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView

      @header = new @ModalHeaderView(title: I18n.t('views.threads.add_url.add_a_link'))
      @link = options.link

    render: () ->
      @$el.html(@template(t: I18n.scoped('views.threads.add_url').t))
      @renderChildInto(@header, '.modal-header')
      @

    addUrl: (e) ->
      e.preventDefault()
      @flash.leave() if @flash
      @$('#flash-box').empty()
      if (url = @.$('input[name="url"]').val())
        @link.set('url', url)
        self = @
        @link.save {},
          validate: false
          success: (model, resp) ->
            if self.model.hasLink(model.getUrl())
              self.renderError(I18n.t('views.threads.add_url.already_added'))
            else
              self.next()
      else
        @renderError(I18n.t('views.threads.add_url.blank'))

    renderError: (msg) ->
      @$('input[name="url"]').addClass('error')
      if msg?
        @flash = new FlashView(
          name: 'error'
          msg: msg
          close: false
        )
        @renderChild(@flash)
        @.$('#flash-box').html(@flash.el)

    next: () ->
      @leave()
      channel.trigger('modal:next')
