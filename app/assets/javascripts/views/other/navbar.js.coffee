define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'hamlcoffee',
  'templates/other/navbar'
  'hamlcoffee_globals',
], ($, _, Backbone, BaseView, hc, navbar) ->

  class NavbarView extends BaseView
    className: 'navbar navbar-fixed-top'

    initialize: ->

    render: ->
      @$el.html(navbar())
      @
