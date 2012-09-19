define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'hamlcoffee',
  'hamlcoffee_globals',
  'templates/other/navbar'
], ($, _, Backbone, BaseView) ->

  class NavbarView extends BaseView
    className: 'navbar navbar-fixed-top'

    initialize: ->

    render: ->
      @$el.html(JST['other/navbar'])
      @
