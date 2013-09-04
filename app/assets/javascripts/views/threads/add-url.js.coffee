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
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header"></div>
          <div class="modal-body">
            <div id="flash-box"></div>
            <form class="form-inline">
              <fieldset>
                <label for="new-link-url" class="sr-only">URL:&nbsp;</label>
                <div class="form-group col-xs-10">
                  <input id="new-link-url" class="form-control" type="text" name="url" placeholder="<%= t(".enter_a_url") %>" />
                </div>
                <div class="form-group col-xs-2">
                  <button type="submit" class="btn btn-primary"><%= t(".go") %></button>
                </div>
              </fieldset>
            </form>
          </div>
        </div>
      </div>'

    buildEvents: () ->
      _(super).extend
        'submit form' : 'addUrl'
        'click button' : 'addUrl'

    initialize: (options = {}) ->
      super(options)

      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView

      @header = new @ModalHeaderView(title: I18n.t('views.threads.add-url.add_a_link'))
      @link = options.link

    render: () ->
      @$el.html(@template(t: I18n.scoped('views.threads.add-url').t))
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
            @.$('#loading').remove()
            @.$('.modal-body').show()
            if self.model.hasLink(model.getUrl())
              self.renderError(I18n.t('views.threads.add-url.already_added'))
            else
              self.next()
        @$el.append('<img id="loading" src="/images/loading.gif"></img>')
      else
        @renderError(I18n.t('views.threads.add-url.blank'))

    renderError: (msg) ->
      @$('input[name="url"]').addClass('error')
      if msg?
        @flash = new FlashView(
          name: 'danger'
          msg: msg
          close: false
        )
        @renderChild(@flash)
        @.$('#flash-box').html(@flash.el)

    next: () ->
      @leave()
      channel.trigger('modal:next')
