define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'templates/threads/add_link'
], ($, _, Backbone, Base, addLinkTemplate) ->

  class AddLinkModalView extends Base.View

    render: () ->
      @$el.html(addLinkTemplate())
      @
