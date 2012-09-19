# ref: http://fiznool.com/post/29347337512/backbone-js-view-inheritance
define [
  'jquery',
  'underscore',
  'backbone',
  'backbone-support'
], ($, _, Backbone) ->

  class BaseView extends Support.CompositeView

    buildEvents: () -> {}
    initialize: (options) -> @delegateEvents(@buildEvents())
