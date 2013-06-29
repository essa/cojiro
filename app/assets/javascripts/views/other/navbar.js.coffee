define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/view',
  'templates/other/navbar'
], ($, _, Backbone, BaseView, navbarTemplate) ->

  class NavbarView extends BaseView
    className: 'navbar navbar-fixed-top'

    initialize: ->

    render: ->
      @$el.html(navbarTemplate())
      @
