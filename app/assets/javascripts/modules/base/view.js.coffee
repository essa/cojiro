# ref: http://fiznool.com/post/29347337512/backbone-js-view-inheritance
define (require) ->
  _ = require('underscore')
  Backbone = require('backbone')
  Support = require('backbone-support')

  class BaseView extends Support.CompositeView
    template: -> ''

    buildEvents: () -> {}
    initialize: (options) -> @delegateEvents(@buildEvents())
    render: -> @$el.html(@template())
