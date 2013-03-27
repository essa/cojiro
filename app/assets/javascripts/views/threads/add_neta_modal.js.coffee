define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'templates/threads/add_neta'
], ($, _, Backbone, Base, addNetaTemplate) ->

  class AddNetaModalView extends Base.View

    render: () ->
      @$el.html(addNetaTemplate())
      @
