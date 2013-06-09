define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'templates/threads/add_link'
], ($, _, Backbone, Base, addLinkTemplate) ->

  class AddLinkModalView extends Base.View

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
