define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'i18n'
], ($, _, Backbone, BaseView, I18n) ->

  class RegisterUrlView extends BaseView
    tagName: 'form'
    className: 'form-inline register-url-form'
    template: _.template '
      <fieldset>
        <label>URL&nbsp;</label>
        <input type="text" name="url" placeholder="<%= enter_a_url_string %>" />
        <button type="submit" class="btn"><%= go_string %></button>
      </fieldset>'

    buildEvents: () ->
      _(super).extend
        'submit form.register-url-form' : 'registerUrl'

    render: () ->
      enter_a_url_string = I18n.t('templates.threads.show.enter_a_url')
      @$el.html(@template(enter_a_url_string: enter_a_url_string, go_string: 'Go!'))
      @

    registerUrl: () ->
      @model.set('url', @.$('input[name="url"]').val())
      @model.save()
      return false
