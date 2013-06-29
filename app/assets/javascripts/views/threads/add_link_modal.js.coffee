define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'templates/threads/add_link'
], ($, _, Backbone, BaseView, addLinkTemplate) ->

  class AddLinkModalView extends BaseView

    buildEvents: () ->
      _(super).extend
        'submit form.add-url-form' : 'submitURL'

    render: () ->
      @$el.html(addLinkTemplate())
      @

    submitURL: () ->
      @model.set('url', @.$('input[name="url"]').val())
      @model.save()
      return false
