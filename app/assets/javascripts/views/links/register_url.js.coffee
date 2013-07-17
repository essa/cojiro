define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/channel'
  'i18n'
], ($, _, Backbone, BaseView, channel, I18n) ->

  class RegisterUrlView extends BaseView
    className: 'form'
    template: _.template '
      <form class="form-inline register-url-form">
        <fieldset>
          <label>URL&nbsp;</label>
          <input type="text" name="url" placeholder="<%= enter_a_url_string %>" />
          <button type="submit" class="btn"><%= go_string %></button>
        </fieldset>
      </form>'

    buildEvents: () ->
      _(super).extend
        'submit form.register-url-form' : 'registerUrl'

    render: () ->
      enter_a_url_string = I18n.t('templates.threads.show.enter_a_url')
      @$el.html(@template(enter_a_url_string: enter_a_url_string, go_string: 'Go!'))
      @

    registerUrl: (e) ->
      e.preventDefault()
      @model.set('url', @.$('input[name="url"]').val())
      self = @
      @model.save {},
        success: (model, resp) ->
          self.goToNext()

    goToNext: () ->
      @leave()
      channel.trigger('modal:next')
