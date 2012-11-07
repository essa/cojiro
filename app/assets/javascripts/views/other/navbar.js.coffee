define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'templates/other/navbar'
], ($, _, Backbone, BaseView, navbar) ->

  class NavbarView extends BaseView
    className: 'navbar navbar-fixed-top'

    initialize: ->

    render: ->
      @$el.html(navbar())
      @
