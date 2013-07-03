# ref: http://fiznool.com/post/29347337512/backbone-js-view-inheritance
define [
  'backbone',
  'backbone-support'
], (Backbone, Support) ->

  class BaseView extends Support.CompositeView

    buildEvents: () -> {}
    initialize: (options) -> @delegateEvents(@buildEvents())
