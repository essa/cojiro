define [
  'jquery'
  'underscore'
  'backbone'
  'views/modals/header'
  'modules/base/view'
  'modules/channel'
  'i18n'
], ($, _, Backbone, ModalHeaderView, BaseView, channel, I18n) ->

  class RegisterUrlView extends BaseView
    template: _.template '
      <div class="modal-header"></div>
      <div class="modal-body">
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
        'submit form' : 'registerUrl'

    initialize: (options = {}) ->
      super(options)

      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView
      @header = new @ModalHeaderView(title: I18n.t('views.links.register_url.add_a_link'))

    render: () ->
      @$el.html(@template(t: I18n.scoped('views.links.register_url').t))
      @renderChildInto(@header, '.modal-header')
      @

    registerUrl: (e) ->
      e.preventDefault()
      if (url = @.$('input[name="url"]').val())
        @model.set('url', url)
        self = @
        @model.save {},
          validate: false
          success: (model, resp) ->
            self.next()
      else
        @$('input[name="url"]').addClass('error')

    next: () ->
      @leave()
      channel.trigger('modal:next')
