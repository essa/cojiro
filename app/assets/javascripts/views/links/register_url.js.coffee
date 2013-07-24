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
            <label>URL&nbsp;</label>
            <input type="text" name="url" placeholder="<%= enter_a_url_string %>" />
            <button type="submit" class="btn"><%= go_string %></button>
          </fieldset>
        </form>
      </div>
      <div class="modal-footer"></div>'

    buildEvents: () ->
      _(super).extend
        'submit form' : 'registerUrl'

    initialize: (options = {}) ->
      super(options)

      @ModalHeaderView = options.ModalHeaderView || ModalHeaderView
      @header = new @ModalHeaderView(title: 'Add a link')

    render: () ->
      enter_a_url_string = I18n.t('templates.threads.show.enter_a_url')
      @$el.html(
        @template(
          title: 'Add a link'
          enter_a_url_string: enter_a_url_string
          go_string: 'Go!'
        )
      )
      @renderChildInto(@header, '.modal-header')
      @

    registerUrl: (e) ->
      e.preventDefault()
      @model.set('url', @.$('input[name="url"]').val())
      self = @
      @model.save {},
        success: (model, resp) ->
          self.next()

    next: () ->
      @leave()
      channel.trigger('modal:next')
