define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base',
  'templates/other/navbar'
], ($, _, Backbone, Base, navbarTemplate) ->

  class NavbarView extends Base.View
    className: 'navbar navbar-fixed-top'

    initialize: ->

    render: ->
      @$el.html(navbarTemplate())
      @
