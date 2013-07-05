define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'i18n'
], ($, _, Backbone, BaseView, I18n) ->

  class AddLinkModalView extends BaseView
    template: _.template '
        <div class="modal-header">
          <button class="close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h3>Add a link</h3>
        </div>
        <div class="modal-body">
          <form class="form-inline add-url-form">
            <fieldset>
              <label>URL&nbsp;</label>
              <input type="text" name="url" placeholder="<%= enter_a_url %>" />
              <button type="submit" class="btn">Go!</button>
            </fieldset>
          </form>
        </div>
      '

    buildEvents: () ->
      _(super).extend
        'submit form.add-url-form' : 'submitURL'

    render: () ->
      enter_a_url = I18n.t('templates.threads.show.enter_a_url')
      @$el.html(@template(enter_a_url: enter_a_url))
      @

    submitURL: () ->
      @model.set('url', @.$('input[name="url"]').val())
      @model.save()
      return false
